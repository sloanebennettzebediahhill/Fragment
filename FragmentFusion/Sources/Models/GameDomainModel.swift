
import Foundation
import RealmSwift

struct GameDomainModel {
    var id: UUID
    var puzzles: List<ItemDomainModel>
    
    init(id: UUID = .init(), puzzles: List<ItemDomainModel>) {
        self.id = id
        self.puzzles = puzzles
    }
}
