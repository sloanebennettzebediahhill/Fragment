
import SwiftUI

struct MainScreen: View {
    @StateObject var viewModel: MainViewModel
    @ObservedObject var authMain: AuthMain
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    @AppStorage("selectedBackground") private var selectedBackground: String = "mainBackground"
    
    init(viewModel: MainViewModel, authMain: AuthMain, path: Binding<NavigationPath>) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.authMain = authMain
        self._path = path
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    path.append(Router.account)
                } label: {
                    Text(authMain.currentuser?.name ?? "Anonimous")
                        .foregroundStyle(Color(red: 73/255, green: 102/255, blue: 124/255))
                        .font(.custom("Dosis-Bold", size: 16))
                        .padding(8)
                        .background(LinearGradient(colors: [
                            Color.init(red: 200/255, green: 215/255, blue: 240/255),
                            Color.init(red: 138/255, green: 176/255, blue: 203/255)
                        ], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(40)
                }

            }
            Spacer()
            Spacer()
            Button {
                path.append(Router.levelListing)
            } label: {
                VStack(spacing: 0) {
                    Text("Levels")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.init(red: 230/255, green: 247/255, blue: 255/255))
                        .font(.custom("Dosis-Bold", size: 40))
                        .textCase(.uppercase)
                    
                    VStack(spacing: 0) {
                        Text("Complete:")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color.init(red: 8/255, green: 68/255, blue: 98/255))
                            .font(.custom("Dosis-Bold", size: 16))
                            .textCase(.uppercase)
                        Text("\(viewModel.loadData())/10")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color.init(red: 8/255, green: 68/255, blue: 98/255))
                            .font(.custom("Dosis-Bold", size: 44))
                            .textCase(.uppercase)
                    }
                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(16)
            }
            .background(
                Image(.gameButton)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            )
            .shadow(color: .init(red: 44/255, green: 150/255, blue: 201/255, opacity: 1), radius: 4, x: 0, y: 4)
            Spacer()
            Button {
                path.append(Router.customGame)
            } label: {
                VStack(spacing: 10) {
                    Text("Custom")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.init(red: 230/255, green: 247/255, blue: 255/255))
                        .font(.custom("Dosis-Bold", size: 40))
                        .textCase(.uppercase)
                    
                    VStack(spacing: 0) {
                        Text("Create your")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color.init(red: 91/255, green: 51/255, blue: 6/255))
                            .font(.custom("Dosis-Bold", size: 16))
                            .textCase(.uppercase)
                        Text("own puzzles")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color.init(red: 91/255, green: 51/255, blue: 6/255))
                            .font(.custom("Dosis-Bold", size: 16))
                            .textCase(.uppercase)
                    }
                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(16)
            }
            .frame(maxWidth: .infinity)
            .background(
                Image(.gameCustomButton)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    
            )
            .shadow(color: .init(red: 215/255, green: 115/255, blue: 0/255, opacity: 1), radius: 4, x: 0, y: 4)
            Spacer()
            Spacer()
            Button {
                path.append(Router.info)
            } label: {
                Text("How to play")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.init(red: 47/255, green: 72/255, blue: 91/255))
                    .font(.custom("Dosis-Bold", size: 32))
                    .textCase(.uppercase)
                    .padding(.vertical, 21)
            }
            .background(LinearGradient(colors: [
                Color.init(red: 200/255, green: 215/255, blue: 240/255),
                Color.init(red: 138/255, green: 176/255, blue: 203/255)
            ], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(60)
            
            Button {
                path.append(Router.settings)
            } label: {
                Text("Settings")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.init(red: 47/255, green: 72/255, blue: 91/255))
                    .font(.custom("Dosis-Bold", size: 32))
                    .textCase(.uppercase)
                    .padding(.vertical, 21)
            }
            .background(LinearGradient(colors: [
                Color.init(red: 200/255, green: 215/255, blue: 240/255),
                Color.init(red: 138/255, green: 176/255, blue: 203/255)
            ], startPoint: .leading, endPoint: .trailing))
            .cornerRadius(60)
            .padding(.top, 10)
            .padding(.bottom, 24)

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
    MainScreen(viewModel: .init(), authMain: .init(), path: .constant(.init()))
}
