import Foundation

enum QuoteError: Error {
    case quoteNotFound
    case saveLimitReached
    case invalidQuote
    case databaseError
}

class QuoteUseCases {
    private let repository: QuoteRepository
    
    init(repository: QuoteRepository) {
        self.repository = repository
    }
    
    // MARK: - Quote Management
    
    func getAllQuotes() async throws -> [Quote] {
        try await repository.getAllQuotes()
    }
    
    func getFavoriteQuotes() async throws -> [Quote] {
        try await repository.getFavoriteQuotes()
    }
    
    func saveQuote(_ quote: Quote) async throws {
        guard !quote.text.isEmpty && !quote.author.isEmpty else {
            throw QuoteError.invalidQuote
        }
        
        let canSave = try await repository.canSaveMoreQuotes()
        guard canSave else {
            throw QuoteError.saveLimitReached
        }
        
        try await repository.saveQuote(quote)
    }
    
    func updateQuote(_ quote: Quote) async throws {
        guard !quote.text.isEmpty && !quote.author.isEmpty else {
            throw QuoteError.invalidQuote
        }
        
        try await repository.updateQuote(quote)
    }
    
    func deleteQuote(byId id: UUID) async throws {
        try await repository.deleteQuote(byId: id)
    }
    
    // MARK: - Favorites Management
    
    func toggleFavorite(quoteId: UUID) async throws {
        try await repository.toggleFavorite(quoteId: quoteId)
    }
    
    func getFavoriteQuotesCount() async throws -> Int {
        try await repository.getFavoriteQuotesCount()
    }
    
    // MARK: - Premium Features
    
    func isPremiumUser() async throws -> Bool {
        try await repository.isPremiumUser()
    }
    
    func canSaveMoreQuotes() async throws -> Bool {
        try await repository.canSaveMoreQuotes()
    }
} 