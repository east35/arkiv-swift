import Foundation

/// Provides a short-lived captcha token for auth requests.
/// Implemented in the app target using a hidden Turnstile WKWebView.
public protocol CaptchaTokenProvider: AnyObject, Sendable {
    func fetchToken() async throws -> String
}

public enum CaptchaError: Error, LocalizedError {
    case challengeFailed(String)
    case timeout

    public var errorDescription: String? {
        switch self {
        case .challengeFailed(let code): return "Captcha challenge failed (\(code))."
        case .timeout: return "Captcha timed out."
        }
    }
}
