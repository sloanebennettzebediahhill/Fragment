
import SwiftUI
import PhotosUI

struct CustomGameScreen: View {
    @StateObject private var viewModel: CustomGameViewModel
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    @AppStorage("selectedBackground") private var selectedBackground: String = "mainBackground"
    
    @State private var isImagePickerPresented: Bool = false
    @State private var selectedItem: PhotosPickerItem?
    
    private let fixedAspectRatio: CGFloat = 4.0 / 5.0
    
    init(viewModel: CustomGameViewModel, path: Binding<NavigationPath>) {
        self._viewModel = .init(wrappedValue: viewModel)
        self._path = path
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                Spacer()
                gameBoard
                Spacer()
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image(selectedBackground)
                    .resizable()
                    .ignoresSafeArea()
            )
            .sheet(isPresented: $isImagePickerPresented) {
                // Обрабатываем выбор изображения
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images
                ) {
                    Text("Select an Image")
                        .font(.headline)
                        .padding()
                }
                .presentationDetents([.medium, .large])
                .onChange(of: selectedItem) { newItem in
                    if let newItem = newItem {
                        loadTransferable(from: newItem)
                    }
                }
            }
            
            if viewModel.isGameWon {
                FinishScreen(time: viewModel.formattedTime) {
                    dismiss()
                } onQuitTap: {
                    dismiss()
                }
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.clear)
            }
        }
    }
    
    private func loadTransferable(from item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    if let unwrappedData = data, let uiImage = UIImage(data: unwrappedData) {
                        viewModel.setCustomImage(uiImage)
                    }
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
                selectedItem = nil
                isImagePickerPresented = false
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
            Spacer()
            
            Button {
                isImagePickerPresented = true
            } label: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.init(red: 42/255, green: 72/255, blue: 91/255))
                    .padding(7)
                    .background(LinearGradient(colors: [
                        Color.init(red: 200/255, green: 215/255, blue: 240/255),
                        Color.init(red: 138/255, green: 176/255, blue: 203/255)
                    ], startPoint: .leading, endPoint: .trailing))
                    .clipShape(Circle())
            }
        }
    }
    
    private var gameBoard: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            
            // Рассчитываем размеры с фиксированным соотношением 4:5
            let availableWidth = screenWidth
            let availableHeight = screenHeight * 0.8 // Используем 80% высоты экрана
            
            // Определяем размер игрового поля, сохраняя соотношение 4:5
            let gridWidth: CGFloat
            let gridHeight: CGFloat
            
            // Расчет размеров, чтобы вписаться в доступное пространство
            if availableWidth / fixedAspectRatio <= availableHeight {
                // Ограничение по ширине
                gridWidth = availableWidth
                gridHeight = availableWidth / fixedAspectRatio
            } else {
                // Ограничение по высоте
                gridHeight = availableHeight
                gridWidth = availableHeight * fixedAspectRatio
            }
            
            // Размер элемента пазла
            let pieceSize = gridWidth / CGFloat(viewModel.gridCount)
            
            return VStack {
                Spacer()
                CustomGameGrid(
                    viewModel: viewModel,
                    gridCount: viewModel.gridCount,
                    pieceSize: pieceSize,
                    fixedAspectRatio: fixedAspectRatio
                )
                .frame(width: gridWidth, height: gridHeight)
                .background(Color(red: 217/255, green: 217/255, blue: 217/255, opacity: 1))
                .cornerRadius(30)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                viewModel.setFixedAspectРatio(fixedAspectRatio)
                viewModel.setupGame()
            }
        }
    }
}

// Custom game grid view remains the same
struct CustomGameGrid: View {
    @ObservedObject var viewModel: CustomGameViewModel
    let gridCount: Int
    let pieceSize: CGFloat
    let fixedAspectRatio: CGFloat
    
    // Reduced spacing between cells
    private let spacing: CGFloat = 1
    
    var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.fixed(pieceSize), spacing: spacing), count: gridCount),
            spacing: spacing
        ) {
            ForEach(0..<viewModel.imagePieces.count, id: \.self) { index in
                Image(uiImage: viewModel.imagePieces[index])
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: pieceSize, height: pieceSize / fixedAspectRatio * CGFloat(gridCount) / CGFloat(gridCount))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(red: 255/255, green: 249/249, blue: 249/249), lineWidth: 2)
                    )
                    .cornerRadius(8)
                    .opacity(viewModel.isSelected[index] ? 0.4 : 1)
                    .onTapGesture {
                        viewModel.handleTap(index: index)
                    }
            }
        }
    }
}

//struct CustomGameScreen: View {
//    @ObservedObject private var viewModel: CustomGameViewModel
//    @Binding var path: NavigationPath
//    @Environment(\.dismiss) var dismiss
//    @AppStorage("selectedBackground") private var selectedBackground: String = "mainBackground"
//    
//    // Для выбора изображения
//    @State private var isImagePickerPresented: Bool = false
//    @State private var selectedItem: PhotosPickerItem?
//    
//    // Фиксированное соотношение сторон 4:5
//    private let fixedAspectRatio: CGFloat = 4.0 / 5.0
//    
//    init(viewModel: CustomGameViewModel, path: Binding<NavigationPath>) {
//        self.viewModel = viewModel
//        self._path = path
//    }
//    
//    var body: some View {
//        if viewModel.isGameWon {
//            FinishScreen()
//        } else {
//            VStack(spacing: 0) {
//                header
//                Spacer()
//                gameBoard
//                Spacer()
//            }
//            .padding(.horizontal, 10)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(
//                Image(selectedBackground)
//                    .resizable()
//                    .ignoresSafeArea()
//            )
//            .sheet(isPresented: $isImagePickerPresented) {
//                // Обрабатываем выбор изображения
//                PhotosPicker(
//                    selection: $selectedItem,
//                    matching: .images
//                ) {
//                    Text("Выберите изображение")
//                        .font(.headline)
//                        .padding()
//                }
//                .presentationDetents([.medium, .large])
//                .onChange(of: selectedItem) { newItem in
//                    if let newItem = newItem {
//                        loadTransferable(from: newItem)
//                    }
//                }
//            }
//        }
//    }
//    
//    private func loadTransferable(from item: PhotosPickerItem) {
//        item.loadTransferable(type: Data.self) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let data):
//                    if let unwrappedData = data, let uiImage = UIImage(data: unwrappedData) {
//                        viewModel.setCustomImage(uiImage)
//                    }
//                case .failure(let error):
//                    print("Error loading image: \(error)")
//                }
//                selectedItem = nil
//                isImagePickerPresented = false
//            }
//        }
//    }
//    
//    private var header: some View {
//        HStack {
//            Button {
//                dismiss()
//            } label: {
//                Image(.backButton)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: 44, height: 44)
//            }
//            Spacer()
//            Text("Levels")
//                .foregroundStyle(.white)
//                .font(.custom("Dosis-Bold", size: 44))
////                .padding(.trailing, 44)
//            Spacer()
//            
//            Button {
//                isImagePickerPresented = true
//            } label: {
//                Image(systemName: "photo")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 30, height: 30)
//                    .foregroundColor(.init(red: 42/255, green: 72/255, blue: 91/255))
//                    .padding(7)
//                    .background(LinearGradient(colors: [
//                        Color.init(red: 200/255, green: 215/255, blue: 240/255),
//                        Color.init(red: 138/255, green: 176/255, blue: 203/255)
//                    ], startPoint: .leading, endPoint: .trailing))
//                    .clipShape(Circle())
//            }
//        }
//    }
//    
//    private var gameBoard: some View {
//        GeometryReader { geometry in
//            let screenWidth = geometry.size.width
//            let screenHeight = geometry.size.height
//            
//            // Рассчитываем размеры с фиксированным соотношением 4:5
//            let availableWidth = screenWidth
//            let availableHeight = screenHeight * 0.8 // Используем 80% высоты экрана
//            
//            // Определяем размер игрового поля, сохраняя соотношение 4:3
//            let gridWidth: CGFloat
//            let gridHeight: CGFloat
//            
//            // Расчет размеров, чтобы вписаться в доступное пространство
//            if availableWidth / fixedAspectRatio <= availableHeight {
//                // Ограничение по ширине
//                gridWidth = availableWidth
//                gridHeight = availableWidth / fixedAspectRatio
//            } else {
//                // Ограничение по высоте
//                gridHeight = availableHeight
//                gridWidth = availableHeight * fixedAspectRatio
//            }
//            
//            // Размер элемента пазла
//            let pieceSize = gridWidth / CGFloat(viewModel.gridCount)
//            
//            return VStack {
//                Spacer()
//                CustomGameGrid(
//                    viewModel: viewModel,
//                    gridCount: viewModel.gridCount,
//                    pieceSize: pieceSize,
//                    fixedAspectRatio: fixedAspectRatio
//                )
//                .frame(width: gridWidth, height: gridHeight)
//                .background(Color(red: 217/255, green: 217/255, blue: 217/255, opacity: 1))
//                .cornerRadius(30)
//                Spacer()
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .onAppear {
//                viewModel.setFixedAspectRatio(fixedAspectRatio)
//                viewModel.setupGame()
//            }
//        }
//    }
//}
//
//struct CustomGameGrid: View {
//    @ObservedObject var viewModel: CustomGameViewModel
//    let gridCount: Int
//    let pieceSize: CGFloat
//    let fixedAspectRatio: CGFloat
//    
//    // Reduced spacing between cells
//    private let spacing: CGFloat = 1
//    
//    var body: some View {
//        LazyVGrid(
//            columns: Array(repeating: GridItem(.fixed(pieceSize), spacing: spacing), count: gridCount),
//            spacing: spacing
//        ) {
//            ForEach(0..<viewModel.imagePieces.count, id: \.self) { index in
//                Image(uiImage: viewModel.imagePieces[index])
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: pieceSize, height: pieceSize / fixedAspectRatio * CGFloat(gridCount) / CGFloat(gridCount))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color(red: 255/255, green: 249/249, blue: 249/249), lineWidth: 2)
//                    )
//                    .cornerRadius(8)
//                    .opacity(viewModel.isSelected[index] ? 0.4 : 1)
//                    .onTapGesture {
//                        viewModel.handleTap(index: index)
//                    }
//            }
//        }
//    }
//}

#Preview {
    CustomGameScreen(viewModel: .init(id: "", image: "", gridCount: 3, isResolved: false), path: .constant(.init()))
}
