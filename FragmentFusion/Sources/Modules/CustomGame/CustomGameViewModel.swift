

import Foundation
import SwiftUI

final class CustomGameViewModel: ObservableObject, Hashable {
    @Published var id: String
    @Published var image: String
    @Published var gridCount: Int
    @Published var isResolved: Bool
    
    // Timer properties instead of moveCounter
    @Published var elapsedTime: TimeInterval = 0
    @Published var isTimerRunning = false
    private var timerStartTime: Date?
    private var timer: Timer?
    
    @Published var imagePieces: [UIImage] = []
    @Published var originalImagePieces: [UIImage] = []
    @Published var selectedIndices: [Int] = []
    @Published var isGameWon = false
    @Published var isSelected: [Bool] = []
    
    // Соотношение сторон изображения
    @Published var imageAspectRatio: CGFloat = 4.0 / 5.0 // Фиксированное соотношение 4:5
    
    // Добавлены для поддержки пользовательского изображения
    @Published var customImage: UIImage?
    @Published var isUsingCustomImage: Bool = false
    
    init(id: String, image: String, gridCount: Int, isResolved: Bool) {
        self.id = id
        self.image = image
        self.gridCount = gridCount
        self.isResolved = isResolved
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CustomGameViewModel, rhs: CustomGameViewModel) -> Bool {
        return lhs.id == rhs.id &&
            lhs.image == rhs.image &&
            lhs.gridCount == rhs.gridCount &&
            lhs.isResolved == rhs.isResolved
    }
    
    // Устанавливает фиксированное соотношение сторон
    func setFixedAspectРatio(_ ratio: CGFloat) {
        imageAspectRatio = ratio
    }
    
    // Добавлен метод для установки пользовательского изображения
    func setCustomImage(_ image: UIImage) {
        customImage = image
        isUsingCustomImage = true
        // Сбрасываем игру с новым изображением
        setupGame()
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
    
    // Format the elapsed time as a string (mm:ss.ms)
    var formattedTime: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func splitImage(image: UIImage) -> [UIImage] {
        guard let cgImage = image.cgImage else { return [] }
        
        // Создаем новый UIImage с фиксированным соотношением сторон
        let targetSize: CGSize
        let originalWidth = CGFloat(cgImage.width)
        let originalHeight = CGFloat(cgImage.height)
        let originalAspectRatio = originalWidth / originalHeight
        
        if originalAspectRatio > imageAspectRatio {
            // Изображение шире, чем нужно - обрезаем по ширине
            targetSize = CGSize(
                width: originalHeight * imageAspectRatio,
                height: originalHeight
            )
        } else {
            // Изображение уже, чем нужно - обрезаем по высоте
            targetSize = CGSize(
                width: originalWidth,
                height: originalWidth / imageAspectRatio
            )
        }
        
        // Определяем область обрезки по центру
        let xOffset = (originalWidth - targetSize.width) / 2
        let yOffset = (originalHeight - targetSize.height) / 2
        
        // Обрезаем изображение до нужных пропорций
        let croppedRect = CGRect(
            x: xOffset,
            y: yOffset,
            width: targetSize.width,
            height: targetSize.height
        )
        
        guard let croppedCGImage = cgImage.cropping(to: croppedRect) else { return [] }
        
        // Теперь разделяем обрезанное изображение на части
        let width = CGFloat(croppedCGImage.width) / CGFloat(gridCount)
        let height = CGFloat(croppedCGImage.height) / CGFloat(gridCount)
        
        var pieces: [UIImage] = []
        
        for row in 0 ..< gridCount {
            for col in 0 ..< gridCount {
                let rect = CGRect(
                    x: CGFloat(col) * width,
                    y: CGFloat(row) * height,
                    width: width,
                    height: height
                )
                if let pieceCGImage = croppedCGImage.cropping(to: rect) {
                    let piece = UIImage(cgImage: pieceCGImage)
                    pieces.append(piece)
                }
            }
        }
        
        return pieces
    }

    func setupGame() {
        // Выбираем источник изображения в зависимости от того, используем ли пользовательское
        let sourceImage: UIImage
        
        if isUsingCustomImage, let userImage = customImage {
            sourceImage = userImage
        } else if let originalImage = UIImage(named: image) {
            sourceImage = originalImage
        } else if let defaultImage = UIImage(named: "userButton") {
            sourceImage = defaultImage
        } else {
            return
        }
        
        // Сбрасываем состояние игры
        isGameWon = false
        resetTimer()
        selectedIndices = []
        
        // Разбиваем изображение на части с фиксированным соотношением сторон
        originalImagePieces = splitImage(image: sourceImage)
        imagePieces = originalImagePieces
        
        // Перемешиваем части
        while imagePieces == originalImagePieces {
            imagePieces.shuffle()
        }
        
        isSelected = Array(repeating: false, count: gridCount * gridCount)
    }
    
    deinit {
        stopTimer()
    }
}

//final class CustomGameViewModel: ObservableObject, Hashable {
//    @Published var id: String
//    @Published var image: String
//    @Published var gridCount: Int
//    @Published var isResolved: Bool
//    @Published var moveСounter: Int = 0
//    
//    @Published var imagePieces: [UIImage] = []
//    @Published var originalImagePieces: [UIImage] = []
//    @Published var selectedIndices: [Int] = []
//    @Published var isGameWon = false
//    @Published var isSelected: [Bool] = []
//    
//    // Соотношение сторон изображения
//    @Published var imageAspectRatio: CGFloat = 4.0 / 5.0 // Фиксированное соотношение 4:5
//    
//    // Добавлены для поддержки пользовательского изображения
//    @Published var customImage: UIImage?
//    @Published var isUsingCustomImage: Bool = false
//    
//    init(id: String, image: String, gridCount: Int, isResolved: Bool) {
//        self.id = id
//        self.image = image
//        self.gridCount = gridCount
//        self.isResolved = isResolved
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    
//    static func == (lhs: CustomGameViewModel, rhs: CustomGameViewModel) -> Bool {
//        return lhs.id == rhs.id &&
//            lhs.image == rhs.image &&
//            lhs.gridCount == rhs.gridCount &&
//            lhs.isResolved == rhs.isResolved
//    }
//    
//    // Устанавливает фиксированное соотношение сторон
//    func setFixedAspectRatio(_ ratio: CGFloat) {
//        imageAspectRatio = ratio
//    }
//    
//    // Добавлен метод для установки пользовательского изображения
//    func setCustomImage(_ image: UIImage) {
//        customImage = image
//        isUsingCustomImage = true
//        // Сбрасываем игру с новым изображением
//        setupGame()
//    }
//    
//    func handleTap(index: Int) {
//        if selectedIndices.contains(index) {
//            selectedIndices.removeAll(where: { $0 == index })
//            isSelected[index] = false
//        } else {
//            selectedIndices.append(index)
//            isSelected[index] = true
//        }
//
//        if selectedIndices.count == 2 {
//            swapPieces()
//            moveСounter += 1
//        }
//    }
//
//    private func swapPieces() {
//        let firstIndex = selectedIndices[0]
//        let secondIndex = selectedIndices[1]
//        
//        imagePieces.swapAt(firstIndex, secondIndex)
//        
//        isSelected[firstIndex] = false
//        isSelected[secondIndex] = false
//        selectedIndices.removeAll()
//        
//        checkWinCondition()
//    }
//
//    func checkWinCondition() {
//        if imagePieces == originalImagePieces {
//            isGameWon = true
//        }
//    }
//
//    func splitImage(image: UIImage) -> [UIImage] {
//        guard let cgImage = image.cgImage else { return [] }
//        
//        // Создаем новый UIImage с фиксированным соотношением сторон 4:3
//        let targetSize: CGSize
//        let originalWidth = CGFloat(cgImage.width)
//        let originalHeight = CGFloat(cgImage.height)
//        let originalAspectRatio = originalWidth / originalHeight
//        
//        if originalAspectRatio > imageAspectRatio {
//            // Изображение шире, чем 4:3 - обрезаем по ширине
//            targetSize = CGSize(
//                width: originalHeight * imageAspectRatio,
//                height: originalHeight
//            )
//        } else {
//            // Изображение уже, чем 4:3 - обрезаем по высоте
//            targetSize = CGSize(
//                width: originalWidth,
//                height: originalWidth / imageAspectRatio
//            )
//        }
//        
//        // Определяем область обрезки по центру
//        let xOffset = (originalWidth - targetSize.width) / 2
//        let yOffset = (originalHeight - targetSize.height) / 2
//        
//        // Обрезаем изображение до нужных пропорций
//        let croppedRect = CGRect(
//            x: xOffset,
//            y: yOffset,
//            width: targetSize.width,
//            height: targetSize.height
//        )
//        
//        guard let croppedCGImage = cgImage.cropping(to: croppedRect) else { return [] }
//        
//        // Теперь разделяем обрезанное изображение на части
//        let width = CGFloat(croppedCGImage.width) / CGFloat(gridCount)
//        let height = CGFloat(croppedCGImage.height) / CGFloat(gridCount)
//        
//        var pieces: [UIImage] = []
//        
//        for row in 0 ..< gridCount {
//            for col in 0 ..< gridCount {
//                let rect = CGRect(
//                    x: CGFloat(col) * width,
//                    y: CGFloat(row) * height,
//                    width: width,
//                    height: height
//                )
//                if let pieceCGImage = croppedCGImage.cropping(to: rect) {
//                    let piece = UIImage(cgImage: pieceCGImage)
//                    pieces.append(piece)
//                }
//            }
//        }
//        
//        return pieces
//    }
//
//    func setupGame() {
//        // Выбираем источник изображения в зависимости от того, используем ли пользовательское
//        let sourceImage: UIImage
//        
//        if isUsingCustomImage, let userImage = customImage {
//            sourceImage = userImage
//        } else if let originalImage = UIImage(named: image) {
//            sourceImage = originalImage
//        } else if let defaultImage = UIImage(named: "userButton") {
//            sourceImage = defaultImage
//        } else {
//            return
//        }
//        
//        // Сбрасываем состояние игры
//        isGameWon = false
//        moveСounter = 0
//        selectedIndices = []
//        
//        // Разбиваем изображение на части с фиксированным соотношением сторон
//        originalImagePieces = splitImage(image: sourceImage)
//        imagePieces = originalImagePieces
//        
//        // Перемешиваем части
//        while imagePieces == originalImagePieces {
//            imagePieces.shuffle()
//        }
//        
//        isSelected = Array(repeating: false, count: gridCount * gridCount)
//    }
//}
