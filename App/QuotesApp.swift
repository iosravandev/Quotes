import SwiftUI

@main
struct QuotesApp: App {
    // MARK: - Dependencies
    
    private let repository: QuoteRepository
    private let useCases: QuoteUseCases
    private let viewModel: QuotesViewModel
    @StateObject private var themeManager = ThemeManager.shared
    
    init() {
        // Initialize dependencies
        self.repository = CoreDataQuoteRepository()
        self.useCases = QuoteUseCases(repository: repository)
        self.viewModel = QuotesViewModel(useCases: useCases)
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                QuotesView(viewModel: viewModel)
                    .tabItem {
                        Label("Quotes".localized, systemImage: "quote.bubble")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings".localized, systemImage: "gear")
                    }
            }
            .preferredColorScheme(themeManager.colorScheme)
        }
    }
} 