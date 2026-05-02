import Foundation

/// App-level configuration surfaced from `Info.plist` (driven by `Config.xcconfig`).
///
/// Values are read lazily so misconfiguration surfaces with a clear error at the
/// call site rather than crashing at launch.
public struct AppConfig: Sendable {
    public let supabaseURL: URL
    public let supabaseAnonKey: String

    public init(supabaseURL: URL, supabaseAnonKey: String) {
        self.supabaseURL = supabaseURL
        self.supabaseAnonKey = supabaseAnonKey
    }

    public enum ConfigError: Error, CustomStringConvertible {
        case missingKey(String)
        case invalidURL(String)

        public var description: String {
            switch self {
            case .missingKey(let key):
                return "Missing Info.plist key: \(key). Check ArkivApp/Config.xcconfig."
            case .invalidURL(let value):
                return "Invalid URL in Info.plist: \(value)."
            }
        }
    }

    public static func fromMainBundle(_ bundle: Bundle = .main) throws -> AppConfig {
        guard let urlString = bundle.object(forInfoDictionaryKey: "SupabaseURL") as? String,
              !urlString.isEmpty else {
            throw ConfigError.missingKey("SupabaseURL")
        }
        guard let url = URL(string: urlString) else {
            throw ConfigError.invalidURL(urlString)
        }
        guard let key = bundle.object(forInfoDictionaryKey: "SupabaseAnonKey") as? String,
              !key.isEmpty else {
            throw ConfigError.missingKey("SupabaseAnonKey")
        }
        return AppConfig(supabaseURL: url, supabaseAnonKey: key)
    }
}
