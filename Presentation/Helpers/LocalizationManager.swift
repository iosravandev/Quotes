import Foundation

enum Language: String {
    case english = "en"
    case german = "de"
    
    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .german:
            return "Deutsch"
        }
    }
}

class LocalizationManager: ObservableObject {
    @Published var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set([currentLanguage.rawValue], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
        }
    }
    
    static let shared = LocalizationManager()
    
    private init() {
        let preferredLanguage = Bundle.main.preferredLocalizations.first ?? "en"
        currentLanguage = Language(rawValue: preferredLanguage) ?? .english
    }
    
    func localizedString(_ key: String) -> String {
        let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj")
        let bundle = Bundle(path: path ?? "") ?? Bundle.main
        return NSLocalizedString(key, tableName: nil, bundle: bundle, value: key, comment: "")
    }
}

extension String {
    var localized: String {
        LocalizationManager.shared.localizedString(self)
    }
} 