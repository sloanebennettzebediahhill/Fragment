
import Foundation
import RealmSwift

final class SettingsViewModel: ObservableObject {
    
    func deleteAcc() {
        UserDefaults.standard.set("", forKey: "userProfileImage")
        
        let gameStorage: GameDomainModelStorage = .init()

        gameStorage.deleteAll()
        
        let list = RealmSwift.List<ItemDomainModel>()

        list.append(.init(image: "lvl1", cellsCount: 3, difficulty: "EASY", time: 0, isResolved: false))
        list.append(.init(image: "lvl2", cellsCount: 3, difficulty: "EASY", time: 0, isResolved: false))
        list.append(.init(image: "lvl3", cellsCount: 4, difficulty: "EASY", time: 0, isResolved: false))
        list.append(.init(image: "lvl4", cellsCount: 4, difficulty: "MEDIUM", time: 0, isResolved: false))
        list.append(.init(image: "lvl5", cellsCount: 5, difficulty: "MEDIUM", time: 0, isResolved: false))
        list.append(.init(image: "lvl6", cellsCount: 5, difficulty: "MEDIUM", time: 0, isResolved: false))
        list.append(.init(image: "lvl7", cellsCount: 6, difficulty: "HARD", time: 0, isResolved: false))
        list.append(.init(image: "lvl8", cellsCount: 6, difficulty: "HARD", time: 0, isResolved: false))
        list.append(.init(image: "lvl9", cellsCount: 7, difficulty: "HARD", time: 0, isResolved: false))
        list.append(.init(image: "lvl10", cellsCount: 7, difficulty: "HARD", time: 0, isResolved: false))
        
        if gameStorage.read().isEmpty {
            gameStorage.store(item: .init(puzzles: list))
        }
    }
}
