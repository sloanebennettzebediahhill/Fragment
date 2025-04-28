
import Foundation
import UIKit

final class GameViewModel: ObservableObject, Hashable {
    @Published var id: String
    @Published var image: String
    @Published var gridCount: Int
    @Published var isResolved: Bool
    
    @Published var elapsedTime: TimeInterval = 0
    @Published var isTimerRunning = false
    private var timerStartTime: Date?
    private var timer: Timer?
    
    @Published var imagePieces: [UIImage] = []
    @Published var originalImagePieces: [UIImage] = []
    @Published var selectedIndices: [Int] = []
    @Published var isGameWon = false
    @Published var isSelected: [Bool] = []
    
    @Published var imageAspectRatio: CGFloat = 4.0 / 3.0
    
    init(id: String, image: String, gridCount: Int, isResolved: Bool) {
        self.id = id
        self.image = image
        self.gridCount = gridCount
        self.isResolved = isResolved
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: GameViewModel, rhs: GameViewModel) -> Bool {
        return lhs.id == rhs.id &&
            lhs.image == rhs.image &&
            lhs.gridCount == rhs.gridCount &&
            lhs.isResolved == rhs.isResolved
    }
    
    func handleTap(index: Int) {
        // Start timer on first tap if not already running
        if !isTimerRunning {
            startTimer()
        }
        
        if selectedIndices.contains(index) {
            selectedIndices.removeAll(where: { $0 == index })
            isSelected[index] = false
        } else {
            selectedIndices.append(index)
            isSelected[index] = true
        }

        if selectedIndices.count == 2 {
            swapPieces()
        }
    }

    private func swapPieces() {
        let firstIndex = selectedIndices[0]
        let secondIndex = selectedIndices[1]
        
        imagePieces.swapAt(firstIndex, secondIndex)
        
        isSelected[firstIndex] = false
        isSelected[secondIndex] = false
        selectedIndices.removeAll()
        
        checkWinCondition()
    }

    func checkWinCondition() {
        if imagePieces == originalImagePieces {
            isGameWon = true
            stopTimer()
        }
    }
    
    // Timer functions
    func startTimer() {
        timerStartTime = Date()
        isTimerRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.timerStartTime else { return }
            self.elapsedTime = Date().timeIntervalSince(startTime)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerRunning = false
    }
    
    func resetTimer() {
        stopTimer()
        elapsedTime = 0
    }
    
    var formattedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func splitImage(image: UIImage) -> [UIImage] {
        guard let cgImage = image.cgImage else { return [] }
        
        // Calculate the aspect ratio of the original image
        let originalAspectRatio = CGFloat(cgImage.width) / CGFloat(cgImage.height)
        imageAspectRatio = originalAspectRatio
        
        let width = CGFloat(cgImage.width) / CGFloat(gridCount)
        let height = CGFloat(cgImage.height) / CGFloat(gridCount)
        
        var pieces: [UIImage] = []
        
        for row in 0 ..< gridCount {
            for col in 0 ..< gridCount {
                let rect = CGRect(x: CGFloat(col) * width, y: CGFloat(row) * height, width: width, height: height)
                if let croppedCGImage = cgImage.cropping(to: rect) {
                    let piece = UIImage(cgImage: croppedCGImage)
                    pieces.append(piece)
                }
            }
        }
        
        return pieces
    }

    func setupGame() {
        guard let originalImage = UIImage(named: image) ?? UIImage(named: "userButton") else {
            return
        }
        
        originalImagePieces = splitImage(image: originalImage)
        imagePieces = originalImagePieces
        
        while imagePieces == originalImagePieces {
            imagePieces.shuffle()
        }
        
        isSelected = Array(repeating: false, count: gridCount * gridCount)
        resetTimer()
    }
    
    deinit {
        stopTimer()
    }
}

extension GameViewModel {
    // Add property to access game storage
    private var gameStorage: GameDomainModelStorage {
        return GameDomainModelStorage()
    }
    
    func levelPassed() {
        guard var user = gameStorage.read().first else { return }
        
        let levels = user.puzzles
        
        guard let currentIndex = levels.firstIndex(where: { $0.id.uuidString == id }) else { return }
        
        let nextIndex = levels.index(after: currentIndex)
        
        guard nextIndex < levels.count else { return }
        
        let currentItem = levels[currentIndex]
        let nextItem = levels[nextIndex]
        
        do {
            try gameStorage.storage.realm?.write {
                if currentItem.time == 0 || currentItem.time > Int(elapsedTime) {
                    currentItem.time = Int(elapsedTime)
                }
                
                nextItem.isResolved = true
            }
            
            gameStorage.store(item: user)
        } catch {
            print("Failed to write to Realm, reason: \(error.localizedDescription)")
        }
    }
    
    func getLevel() -> Int {
        guard let levels = gameStorage.read().first?.puzzles else { return 100 }
        guard let currentIndex = levels.firstIndex(where: { $0.id.uuidString == id }) else {
            return 100
        }
        var result = currentIndex
        result += 1
        
        return result
    }
    
    func getNextLevel() -> GameViewModel? {
        guard let levels = gameStorage.read().first?.puzzles else { return nil }
        guard let currentIndex = levels.firstIndex(where: { $0.id.uuidString == id }) else { return nil }
        let nextIndex = levels.index(after: currentIndex)
        guard nextIndex < levels.count else { return nil }
        
        let nextLevel = levels[nextIndex]
        return GameViewModel(id: nextLevel.id.uuidString,
                             image: nextLevel.image,
                             gridCount: nextLevel.cellsCount,
                             isResolved: nextLevel.isResolved)
    }
}
