
import SwiftUI

struct GameScreen: View {
    @ObservedObject private var viewModel: GameViewModel
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    @AppStorage("selectedBackground") private var selectedBackground: String = "mainBackground"
    
    init(viewModel: GameViewModel, path: Binding<NavigationPath>) {
        self.viewModel = viewModel
        self._path = path
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                Spacer()
                gameBoard
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image(selectedBackground)
                    .resizable()
                    .ignoresSafeArea()
            )
            
            if viewModel.isGameWon {
                FinishScreen(time: viewModel.formattedTime) {
                    viewModel.levelPassed()
                    dismiss()
                } onQuitTap: {
                    viewModel.levelPassed()
                    dismiss()
                }
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.clear)
            }
        }
    }
    
    private var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(.backButton)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 44, height: 44)
            }
            Spacer()
            Text(viewModel.formattedTime)
                .foregroundStyle(.white)
                .font(.custom("Dosis-Bold", size: 44))
                .padding(.trailing, 44)
            Spacer()
        }
    }
    
    private var gameBoard: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
//            let screenHeight = geometry.size.height
            
            let gridWidth = screenWidth
            let gridHeight: CGFloat
            
            if viewModel.imageAspectRatio >= 1.0 {
                gridHeight = gridWidth / viewModel.imageAspectRatio
            } else {
                gridHeight = gridWidth / viewModel.imageAspectRatio
            }
            
            let pieceSize = gridWidth / (CGFloat(viewModel.gridCount) - 0.4)
            
            return VStack {
                Spacer()
                GameGrid(
                    viewModel: viewModel,
                    gridCount: viewModel.gridCount,
                    pieceSize: pieceSize
                )
                .frame(width: gridWidth, height: gridHeight)
//                .padding(.vertical, 30)
                .background(Color(red: 217/255, green: 217/255, blue: 217/255, opacity: 1))
                .cornerRadius(60)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear(perform: viewModel.setupGame)
        }
    }
}

// Refactored Grid component specifically for the game
struct GameGrid: View {
    @ObservedObject var viewModel: GameViewModel
    let gridCount: Int
    let pieceSize: CGFloat
    
    // Reduced spacing between cells
    private let spacing: CGFloat = 1
    
    var body: some View {
        let pieceWidth: CGFloat
        let pieceHeight: CGFloat
        
        if viewModel.imageAspectRatio >= 1.0 {
            // Wider than tall (landscape)
            pieceWidth = pieceSize
            pieceHeight = pieceSize / viewModel.imageAspectRatio
        } else {
            // Taller than wide (portrait)
            pieceWidth = pieceSize * viewModel.imageAspectRatio
            pieceHeight = pieceSize
        }
        
        return LazyVGrid(
            columns: Array(repeating: GridItem(.fixed(pieceWidth), spacing: spacing), count: gridCount),
            spacing: spacing
        ) {
            ForEach(0..<viewModel.imagePieces.count, id: \.self) { index in
                Image(uiImage: viewModel.imagePieces[index])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: pieceWidth, height: pieceHeight)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(red: 255/255, green: 249/249, blue: 249/249), lineWidth: 4)
                    )
                    .cornerRadius(12)
                    .opacity(viewModel.isSelected[index] ? 0.4 : 1)
                    .onTapGesture {
                        viewModel.handleTap(index: index)
                    }
            }
        }
    }
}

#Preview {
    GameScreen(viewModel: .init(id: "", image: "lvl2", gridCount: 7, isResolved: false), path: .constant(.init()))
}
