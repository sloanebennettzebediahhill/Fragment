
import Foundation
import RealmSwift

final class ItemDomainModel: Object {
    @Persisted(primaryKey: true)  var id: UUID = .init()
    @Persisted var image: String = ""
    @Persisted var cellsCount: Int = 0
    @Persisted var difficulty: String = ""
    @Persisted var time: Int = 0
    @Persisted var isResolved: Bool = false
        
    convenience init(
        id: UUID = .init(),
        image: String,
        cellsCount: Int,
        difficulty: String,
        time: Int,
        isResolved: Bool
    ) {
        self.init()
        self.id = id
        self.image = image
        self.cellsCount = cellsCount
        self.difficulty = difficulty
        self.time = time
        self.isResolved = isResolved
    }
}

