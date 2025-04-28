
import Foundation
import RealmSwift

final class RealmDomainModel: Object {
    @Persisted(primaryKey: true)  var id: UUID = .init()
    @Persisted var puzzles: List<ItemDomainModel>

    convenience init(
        id: UUID = .init(),
        puzzles: List<ItemDomainModel>
    ) {
        self.init()
        self.id = id
        self.puzzles = puzzles
    }
}
