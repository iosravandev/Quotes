import SwiftUI

enum AppTheme: String, CaseIterable {
    case system
    case light
    case dark
    
    var displayName: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}

class ThemeManager: ObservableObject {
    @AppStorage("app_theme") private var storedTheme: String = AppTheme.system.rawValue {
        didSet {
            objectWillChange.send()
        }
    }
    
    @Published var currentTheme: AppTheme {
        get {
            AppTheme(rawValue: storedTheme) ?? .system
        }
        set {
            storedTheme = newValue.rawValue
        }
    }
    
    static let shared = ThemeManager()
    
    private init() {}
    
    var colorScheme: ColorScheme? {
        switch currentTheme {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
} 