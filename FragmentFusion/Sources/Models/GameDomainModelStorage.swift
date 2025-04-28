
import Foundation
import RealmSwift

final class GameDomainModelStorage {
    let storage: RealmStorage = .shared
    
    func store(item: GameDomainModel) {
        storage.create(object: transformToDBO(domainModel: item))
    }
    
    func read() -> [GameDomainModel] {
        guard let results = storage.read(type: RealmDomainModel.self) else {
            return []
        }
    
        return results
            .compactMap(transformToDomainModel)
    }
        
    func delete(ids: [UUID]) {
        storage.delete(type: RealmDomainModel.self, where: { $0.id.in(ids) })
    }
    
    func deleteAll() {
        guard let results = storage.read(type: RealmDomainModel.self) else { return }
        storage.delete(objects: Array(results))
    }
}

private extension GameDomainModelStorage {
    func transformToDBO(domainModel model: GameDomainModel) -> RealmDomainModel {
        return .init(id: model.id, puzzles: model.puzzles)
    }
    
    func transformToDomainModel(model: RealmDomainModel) -> GameDomainModel? {
        return .init(id: model.id, puzzles: model.puzzles)
    }
}
