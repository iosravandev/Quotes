import Foundation
import Combine

protocol QuoteRepository {
    // MARK: - CRUD Operations
    func getAllQuotes() async throws -> [Quote]
    func getFavoriteQuotes() async throws -> [Quote]
    func getQuote(byId id: UUID) async throws -> Quote?
    func saveQuote(_ quote: Quote) async throws
    func updateQuote(_ quote: Quote) async throws
    func deleteQuote(byId id: UUID) async throws
    
    // MARK: - Favorites Management
    func toggleFavorite(quoteId: UUID) async throws
    func getFavoriteQuotesCount() async throws -> Int
    
    // MARK: - Premium Features
    func isPremiumUser() async throws -> Bool
    func canSaveMoreQuotes() async throws -> Bool
} 