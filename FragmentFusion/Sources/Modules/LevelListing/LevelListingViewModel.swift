
import Foundation

// MARK: - ViewModel
final class LevelsViewModel: ObservableObject {
    @Published private(set) var levels: [Level] = []
    @Published private(set) var selectedLevelIndex: Int = 0
    
    init() {
        reloadData()
    }
    
    private func reloadData() {
        let gameStorage: GameDomainModelStorage = .init()
        
        let levelItems: [Level] = gameStorage.read().first?.puzzles
            .compactMap { makeCellViewModel(for: $0) } ?? []
        
        levels = levelItems
    }
    
    func makeCellViewModel(
        for model: ItemDomainModel
    ) -> Level? {
        return .init(id: model.id.uuidString, difficulty: model.difficulty, numberOfPieces: model.cellsCount, imageName: model.image, isResolved: model.isResolved)
    }
    
    func selectLevel(at index: Int) {
        guard index >= 0 && index < levels.count else { return }
        selectedLevelIndex = index
    }
    
    func selectNextLevel() {
        let nextIndex = (selectedLevelIndex + 1) % levels.count
        selectLevel(at: nextIndex)
    }
    
    func selectPreviousLevel() {
        let previousIndex = (selectedLevelIndex - 1 + levels.count) % levels.count
        selectLevel(at: previousIndex)
    }
    
    var currentLevel: Level {
        levels[selectedLevelIndex]
    }
}
