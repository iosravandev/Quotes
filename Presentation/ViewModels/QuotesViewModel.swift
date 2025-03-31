import Foundation
import Combine

@MainActor
class QuotesViewModel: ObservableObject {
    private let useCases: QuoteUseCases
    
    @Published var quotes: [Quote] = []
    @Published var favoriteQuotes: [Quote] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var selectedTab: Tab = .all
    
    enum Tab {
        case all
        case favorites
    }
    
    init(useCases: QuoteUseCases) {
        self.useCases = useCases
    }
    
    // MARK: - Quote Management
    
    func loadQuotes() async {
        isLoading = true
        error = nil
        
        do {
            quotes = try await useCases.getAllQuotes()
            favoriteQuotes = try await useCases.getFavoriteQuotes()
        } catch {
            self.error = error
        }
        
        isLoading = false
    }
    
    func saveQuote(_ quote: Quote) async {
        do {
            try await useCases.saveQuote(quote)
            await loadQuotes()
        } catch {
            self.error = error
        }
    }
    
    func updateQuote(_ quote: Quote) async {
        do {
            try await useCases.updateQuote(quote)
            await loadQuotes()
        } catch {
            self.error = error
        }
    }
    
    func deleteQuote(byId id: UUID) async {
        do {
            try await useCases.deleteQuote(byId: id)
            await loadQuotes()
        } catch {
            self.error = error
        }
    }
    
    // MARK: - Favorites Management
    
    func toggleFavorite(quoteId: UUID) async {
        do {
            try await useCases.toggleFavorite(quoteId: quoteId)
            await loadQuotes()
        } catch {
            self.error = error
        }
    }
    
    // MARK: - Premium Features
    
    func canSaveMoreQuotes() async -> Bool {
        do {
            return try await useCases.canSaveMoreQuotes()
        } catch {
            self.error = error
            return false
        }
    }
    
    func isPremiumUser() async -> Bool {
        do {
            return try await useCases.isPremiumUser()
        } catch {
            self.error = error
            return false
        }
    }
} 