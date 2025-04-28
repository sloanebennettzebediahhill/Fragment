
import Foundation

final class MainViewModel: ObservableObject {
    
    func loadData() -> Int {
        var score: Int = 0
        let gameStorage: GameDomainModelStorage = .init()
        
        guard let items = gameStorage.read().first?.puzzles else { return .max }
        
        for item in items {
            if item.isResolved == true {
                score += 1
            }
        }
        
        return score
    }
}
