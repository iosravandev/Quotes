import SwiftUI

struct SettingsView: View {
    @StateObject private var localizationManager = LocalizationManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Language".localized)) {
                    Picker("Language".localized, selection: $localizationManager.currentLanguage) {
                        ForEach([Language.english, .german], id: \.self) { language in
                            Text(language.displayName)
                                .tag(language)
                        }
                    }
                }
                
                Section(header: Text("Theme".localized)) {
                    Picker("Theme".localized, selection: $themeManager.currentTheme) {
                        ForEach(AppTheme.allCases, id: \.self) { theme in
                            Text(theme.displayName.localized)
                                .tag(theme)
                        }
                    }
                }
                
                Section(header: Text("About".localized)) {
                    HStack {
                        Text("Version".localized)
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings".localized)
        }
    }
} 