
import Foundation

struct Level: Identifiable, Hashable {
    let id: String
    let difficulty: String
    let numberOfPieces: Int
    let imageName: String
    let isResolved: Bool
    
    init(id: String, difficulty: String, numberOfPieces: Int, imageName: String, isResolved: Bool) {
        self.id = id
        self.difficulty = difficulty
        self.numberOfPieces = numberOfPieces
        self.imageName = imageName
        self.isResolved = isResolved
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Level, rhs: Level) -> Bool {
        return lhs.id == rhs.id &&
            lhs.difficulty == rhs.difficulty &&
            lhs.numberOfPieces == rhs.numberOfPieces &&
            lhs.imageName == rhs.imageName &&
            lhs.isResolved == rhs.isResolved
    }
}
