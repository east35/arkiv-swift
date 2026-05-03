import WebKit
import Core
import os
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Fetches a Cloudflare Turnstile token using a hidden WKWebView.
/// The webview is attached to the key window (off-screen) so its JS runtime
/// behaves like a real browser context — without that, Turnstile silently
/// hangs waiting for browser signals it never receives.
@MainActor
public final class TurnstileTokenProvider: NSObject, CaptchaTokenProvider {
    private let siteKey: String
    private let originURL: URL
    private var webView: WKWebView?
    private var continuation: CheckedContinuation<String, any Error>?
    private var timeoutTask: Task<Void, Never>?

    private static let timeoutSeconds: Double = 30
    private static let log = Logger(subsystem: "com.arkiv.app", category: "Turnstile")

    public init(siteKey: String, originURL: URL) {
        self.siteKey = siteKey
        self.originURL = originURL
    }

    public func fetchToken() async throws -> String {
        tearDown()
        return try await withCheckedThrowingContinuation { cont in
            self.continuation = cont
            self.launchWebView()
            self.timeoutTask = Task { [weak self] in
                try? await Task.sleep(nanoseconds: UInt64(Self.timeoutSeconds * 1_000_000_000))
                guard !Task.isCancelled else { return }
                await self?.fail(with: CaptchaError.timeout)
            }
        }
    }

    private func launchWebView() {
        let controller = WKUserContentController()
        controller.add(self, name: "turnstile")
        controller.add(self, name: "log")

        let config = WKWebViewConfiguration()
        config.userContentController = controller
        config.defaultWebpagePreferences.allowsContentJavaScript = true

        let wv = WKWebView(frame: CGRect(x: -1000, y: -1000, width: 320, height: 100), configuration: config)
        wv.isHidden = false
        webView = wv

        // Attach off-screen so JS executes in a real browser context.
        Self.attachOffscreen(wv)

        wv.loadHTMLString(challengeHTML, baseURL: originURL)
    }

    #if canImport(UIKit)
    private static func attachOffscreen(_ webView: WKWebView) {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)
        ?? UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first
        if let window {
            window.addSubview(webView)
        } else {
            log.error("No active UIWindow to attach Turnstile WKWebView")
        }
    }
    #elseif canImport(AppKit)
    private static func attachOffscreen(_ webView: WKWebView) {
        if let contentView = NSApplication.shared.keyWindow?.contentView
            ?? NSApplication.shared.windows.first?.contentView {
            contentView.addSubview(webView)
        } else {
            log.error("No active NSWindow to attach Turnstile WKWebView")
        }
    }
    #endif

    private func succeed(with token: String) {
        let cont = continuation
        continuation = nil
        tearDown()
        cont?.resume(returning: token)
    }

    private func fail(with error: any Error) {
        let cont = continuation
        continuation = nil
        tearDown()
        cont?.resume(throwing: error)
    }

    private func tearDown() {
        timeoutTask?.cancel()
        timeoutTask = nil
        if let wv = webView {
            wv.configuration.userContentController.removeScriptMessageHandler(forName: "turnstile")
            wv.configuration.userContentController.removeScriptMessageHandler(forName: "log")
            wv.removeFromSuperview()
        }
        webView = nil
    }

    private var challengeHTML: String {
        """
        <!DOCTYPE html><html><head><meta name="viewport" content="width=device-width,initial-scale=1">
        <script>
          (function() {
            function send(msg) {
              try { window.webkit.messageHandlers.log.postMessage(String(msg)); } catch(e) {}
            }
            ['log','warn','error'].forEach(function(level) {
              var orig = console[level];
              console[level] = function() {
                send('[' + level + '] ' + Array.prototype.join.call(arguments, ' '));
                orig && orig.apply(console, arguments);
              };
            });
            window.addEventListener('error', function(e) {
              send('[window.error] ' + e.message + ' @ ' + e.filename + ':' + e.lineno);
            });
            send('[boot] origin=' + window.location.origin);
          })();
        </script>
        <script src="https://challenges.cloudflare.com/turnstile/v0/api.js?render=explicit"
                onload="window.webkit.messageHandlers.log.postMessage('[boot] api.js loaded')"
                onerror="window.webkit.messageHandlers.log.postMessage('[boot] api.js FAILED to load')"
                async defer></script>
        </head><body><div id="cf"></div>
        <script>
        function renderTurnstile() {
          if (typeof turnstile === 'undefined') {
            window.webkit.messageHandlers.log.postMessage('[render] turnstile undefined, retrying');
            setTimeout(renderTurnstile, 200);
            return;
          }
          window.webkit.messageHandlers.log.postMessage('[render] calling turnstile.render');
          try {
            turnstile.render('#cf', {
              sitekey: '\(siteKey)',
              size: 'invisible',
              callback: function(token) {
                window.webkit.messageHandlers.log.postMessage('[render] got token');
                window.webkit.messageHandlers.turnstile.postMessage({type:'token',value:token});
              },
              'error-callback': function(code) {
                window.webkit.messageHandlers.log.postMessage('[render] error-callback: ' + String(code));
                window.webkit.messageHandlers.turnstile.postMessage({type:'error',value:String(code)});
                return true;
              },
              'expired-callback': function() {
                window.webkit.messageHandlers.turnstile.postMessage({type:'error',value:'expired'});
              }
            });
            window.webkit.messageHandlers.log.postMessage('[render] render() returned');
          } catch (e) {
            window.webkit.messageHandlers.log.postMessage('[render] threw: ' + (e && e.message ? e.message : String(e)));
            window.webkit.messageHandlers.turnstile.postMessage({type:'error',value:'render-threw'});
          }
        }
        if (document.readyState === 'loading') {
          document.addEventListener('DOMContentLoaded', renderTurnstile);
        } else {
          renderTurnstile();
        }
        </script></body></html>
        """
    }
}

extension TurnstileTokenProvider: WKScriptMessageHandler {
    public nonisolated func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        if message.name == "log" {
            let text = (message.body as? String) ?? "\(message.body)"
            Self.log.debug("\(text, privacy: .public)")
            return
        }
        guard let body = message.body as? [String: Any],
              let type = body["type"] as? String,
              let value = body["value"] as? String else { return }
        Task { @MainActor in
            if type == "token" {
                self.succeed(with: value)
            } else {
                self.fail(with: CaptchaError.challengeFailed(value))
            }
        }
    }
}
