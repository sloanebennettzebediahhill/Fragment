
import SwiftUI

struct LevelListingScreen: View {
    @StateObject private var viewModel = LevelsViewModel()
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    @AppStorage("selectedBackground") private var selectedBackground: String = "mainBackground"
    
    init(path: Binding<NavigationPath>) {
        self._path = path
    }
    
    var body: some View {
        VStack(spacing: 0) {
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
                Text("Levels")
                    .foregroundStyle(.white)
                    .font(.custom("Dosis-Bold", size: 44))
                    .padding(.trailing, 44)
                Spacer()
            }
            Spacer()
            
            VStack() {
                
                LevelDetailsView(level: viewModel.currentLevel, path: $path)
                
//                Spacer()
                
                LevelCarouselView(viewModel: viewModel)
                    .padding(.horizontal, -10)
                    .padding(.bottom, 20)
            }
            
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(selectedBackground)
                .resizable()
                .ignoresSafeArea()
        )
    }
}

#Preview {
    LevelListingScreen(path: .constant(.init()))
}


struct LevelThumbView: View {
    let level: Level
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(level.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.init(red: 255/255, green: 249/249, blue: 249/249), lineWidth: 8)
                )
                .opacity(isSelected ? 1 : 0.4)
                .cornerRadius(20)
                .padding(.vertical, 4)
        }
    }
}

struct LevelInfo: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.custom("Dosis-Bold", size: 16))
                .foregroundColor(Color.init(red: 200/255, green: 215/255, blue: 240/255))
            
            Text(value)
                .font(.custom("Dosis-Bold", size: 44))
                .foregroundColor(Color.init(red: 200/255, green: 215/255, blue: 240/255))
        }
    }
}

struct LevelDetailsView: View {
    let level: Level
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                path.append(Router.game(level))
            } label: {
                Image(level.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 60))
            }
            
            HStack(alignment: .top) {
                LevelInfo(
                    title: "DIFFICULTY:",
                    value: level.difficulty
                )
                
                Spacer()
                
                LevelInfo(
                    title: "NUMBER OF PIECES:",
                    value: "\(level.numberOfPieces * level.numberOfPieces)"
                )
            }
            .padding()
        }
    }
}

struct LevelCarouselView: View {
    @ObservedObject var viewModel: LevelsViewModel
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(viewModel.levels.enumerated()), id: \.element.id) { index, level in
                        LevelThumbView(
                            level: level,
                            isSelected: index == viewModel.selectedLevelIndex,
                            action: { viewModel.selectLevel(at: index) }
                        )
                    }
                }
                .padding(.horizontal, 64)
            }
            
            HStack(spacing: 0) {
                Button(action: viewModel.selectPreviousLevel) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.init(red: 47/255, green: 72/255, blue: 91/255))
                        .frame(width: 44, height: 100)
                        .background(LinearGradient(colors: [
                            Color.init(red: 138/255, green: 176/255, blue: 203/255),
                            Color.init(red: 200/255, green: 215/255, blue: 240/255)
                        ], startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                }
                Spacer()
                Button(action: viewModel.selectNextLevel) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.init(red: 47/255, green: 72/255, blue: 91/255))
                        .frame(width: 44, height: 100)
                        .background(LinearGradient(colors: [
                            Color.init(red: 200/255, green: 215/255, blue: 240/255),
                            Color.init(red: 138/255, green: 176/255, blue: 203/255)
                        ], startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                }
            }
            .padding(.horizontal, 10)
        }
    }
}
