
import SwiftUI

struct RootScreen: View {
    @ObservedObject private var viewModel: RootViewModel
    @State private var path: NavigationPath = .init()
    @StateObject private var authMain = AuthMain()
    @Environment(\.dismiss) var dismiss
    
    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            mainView
                .onAppear(perform: {
                    viewModel.loadData()
                })
                .navigationDestination(for: Router.self) { router in
                    switch router {
                    case .main:
                        MainScreen(viewModel: .init(), authMain: authMain, path: $path)
                            .navigationBarBackButtonHidden(true)
                    case .account:
                        ProfileScreen(viewModel: .init(), authMain: authMain, path: $path)
                            .navigationBarBackButtonHidden(true)
                    case .settings:
                        SettingsScreen(viewModel: .init(), authMain: authMain, path: $path)
                            .navigationBarBackButtonHidden(true)
                    case .info:
                        HowToPlayScreen(path: $path)
                            .navigationBarBackButtonHidden(true)
                    case .levelListing:
                        LevelListingScreen(path: $path)
                            .navigationBarBackButtonHidden(true)
                    case .game(let level):
                        GameScreen(viewModel: .init(id: level.id, image: level.imageName, gridCount: level.numberOfPieces, isResolved: level.isResolved), path: $path)
                            .navigationBarBackButtonHidden(true)
                    case .customGame:
                        CustomGameScreen(viewModel: .init(id: "", image: "", gridCount: 3, isResolved: true), path: $path)
                            .navigationBarBackButtonHidden(true)
                    }
                }
        }
    }
    
    @ViewBuilder
    var mainView: some View {
        if authMain.userSession != nil {
            MainScreen(viewModel: .init(), authMain: authMain, path: $path)
        } else {
            AuthorizationScreen(viewModel: authMain, path: $path)
        }
    }
}

#Preview {
    RootScreen(viewModel: .init())
}
