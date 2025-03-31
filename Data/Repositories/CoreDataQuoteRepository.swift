import Foundation
import CoreData

class CoreDataQuoteRepository: QuoteRepository {
    private let container: NSPersistentContainer
    private let maxFreeQuotes = 10
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Quote")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private var context: NSManagedObjectContext {
        container.viewContext
    }
    
    // MARK: - CRUD Operations
    
    func getAllQuotes() async throws -> [Quote] {
        let request = QuoteEntity.fetchRequest()
        let entities = try context.fetch(request)
        return entities.map { entity in
            Quote(
                id: entity.id ?? UUID(),
                text: entity.text ?? "",
                author: entity.author ?? "",
                isFavorite: entity.isFavorite
            )
        }
    }
    
    func getFavoriteQuotes() async throws -> [Quote] {
        let request = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == YES")
        let entities = try context.fetch(request)
        return entities.map { entity in
            Quote(
                id: entity.id ?? UUID(),
                text: entity.text ?? "",
                author: entity.author ?? "",
                isFavorite: entity.isFavorite
            )
        }
    }
    
    func getQuote(byId id: UUID) async throws -> Quote? {
        let request = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let entities = try context.fetch(request)
        
        guard let entity = entities.first else { return nil }
        
        return Quote(
            id: entity.id ?? UUID(),
            text: entity.text ?? "",
            author: entity.author ?? "",
            isFavorite: entity.isFavorite
        )
    }
    
    func saveQuote(_ quote: Quote) async throws {
        let entity = QuoteEntity(context: context)
        entity.id = quote.id
        entity.text = quote.text
        entity.author = quote.author
        entity.isFavorite = quote.isFavorite
        entity.createdAt = quote.createdAt
        entity.modifiedAt = quote.modifiedAt
        
        try context.save()
    }
    
    func updateQuote(_ quote: Quote) async throws {
        let request = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", quote.id as CVarArg)
        let entities = try context.fetch(request)
        
        guard let entity = entities.first else {
            throw QuoteError.quoteNotFound
        }
        
        entity.text = quote.text
        entity.author = quote.author
        entity.isFavorite = quote.isFavorite
        entity.modifiedAt = quote.modifiedAt
        
        try context.save()
    }
    
    func deleteQuote(byId id: UUID) async throws {
        let request = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        let entities = try context.fetch(request)
        
        guard let entity = entities.first else {
            throw QuoteError.quoteNotFound
        }
        
        context.delete(entity)
        try context.save()
    }
    
    // MARK: - Favorites Management
    
    func toggleFavorite(quoteId: UUID) async throws {
        let request = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", quoteId as CVarArg)
        let entities = try context.fetch(request)
        
        guard let entity = entities.first else {
            throw QuoteError.quoteNotFound
        }
        
        entity.isFavorite.toggle()
        try context.save()
    }
    
    func getFavoriteQuotesCount() async throws -> Int {
        let request = QuoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == YES")
        return try context.count(for: request)
    }
    
    // MARK: - Premium Features
    
    func isPremiumUser() async throws -> Bool {
        // TODO: Implement StoreKit integration
        return false
    }
    
    func canSaveMoreQuotes() async throws -> Bool {
        let isPremium = try await isPremiumUser()
        if isPremium { return true }
        
        let request = QuoteEntity.fetchRequest()
        let count = try context.count(for: request)
        return count < maxFreeQuotes
    }
} 