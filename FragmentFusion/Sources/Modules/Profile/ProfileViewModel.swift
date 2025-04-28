
import Foundation
import SwiftUI
import PhotosUI
import RealmSwift

class ProfileViewModel: ObservableObject {
    @Published var displayImage: UIImage?
    @Published var completedPuzzlesCount: Int = 0
    @Published var averageCompletionTime: String = "00:00"
    
    init() {
        loadProfileImage()
        updateGameStats()
    }
    
    func loadProfileImage() {
        if let imageData = UserDefaults.standard.data(forKey: "userProfileImage"),
           let savedImage = UIImage(data: imageData) {
            self.displayImage = savedImage
        }
    }
    
    @MainActor
    func saveProfileImageAsync(item: PhotosPickerItem) async {
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                Task { @MainActor in
                    self.displayImage = uiImage
                }
                objectWillChange.send()
                UserDefaults.standard.set(data, forKey: "userProfileImage")
            }
        } catch {
            print("Failed to load image: \(error)")
        }
    }
    
    func updateGameStats() {
        let gameStorage: GameDomainModelStorage = .init()
        let gameData = gameStorage.read()
        
        // Calculate completed puzzles count
        if let puzzles = gameData.first?.puzzles {
            completedPuzzlesCount = puzzles.filter { $0.isResolved == true }.count
            
            // Calculate average completion time
            let completedPuzzles = puzzles.filter { $0.isResolved == true && $0.time > 0 }
            if !completedPuzzles.isEmpty {
                let totalTime = completedPuzzles.reduce(0) { $0 + $1.time }
                let avgTime = totalTime / completedPuzzles.count
                averageCompletionTime = formatTime(seconds: avgTime)
            } else {
                averageCompletionTime = "00:00"
            }
        }
    }
    
    private func formatTime(seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    func resetData() {
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
        
        // Update stats after reset
        updateGameStats()
    }
}
