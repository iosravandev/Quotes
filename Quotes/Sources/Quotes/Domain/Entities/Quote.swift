import Foundation

struct Quote: Identifiable, Codable, Equatable {
    let id: UUID
    var text: String
    var author: String
    var isFavorite: Bool
    var createdAt: Date
    var modifiedAt: Date
    
    init(id: UUID = UUID(), text: String, author: String, isFavorite: Bool = false) {
        self.id = id
        self.text = text
        self.author = author
        self.isFavorite = isFavorite
        self.createdAt = Date()
        self.modifiedAt = Date()
    }
    
    mutating func update(text: String? = nil, author: String? = nil, isFavorite: Bool? = nil) {
        if let text = text {
            self.text = text
        }
        if let author = author {
            self.author = author
        }
        if let isFavorite = isFavorite {
            self.isFavorite = isFavorite
        }
        self.modifiedAt = Date()
    }
} 