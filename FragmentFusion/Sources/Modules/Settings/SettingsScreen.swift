
import SwiftUI

struct SettingsScreen: View {
    @StateObject var viewModel: SettingsViewModel
    @ObservedObject var authMain: AuthMain
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    @State private var isPresentPrivacyWebView = false
    @State private var isPresentAlert = false
    @AppStorage("selectedBackground") private var selectedBackground: String = "mainBackground"
    
    let backgrounds = ["mainBackground", "background1", "background2", "background3", "background4", "background5"]
    
    init(viewModel: SettingsViewModel, authMain: AuthMain, path: Binding<NavigationPath>) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.authMain = authMain
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
                Text("Settings")
                    .foregroundStyle(.white)
                    .font(.custom("Dosis-Bold", size: 44))
                    .padding(.trailing, 44)
                Spacer()
            }
//            Spacer()
            Text("Choose background")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color.init(red: 200/255, green: 215/255, blue: 240/255))
                .font(.custom("Dosis-Bold", size: 24))
                .textCase(.uppercase)
                .padding(.top, 60)
//            Spacer()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                ForEach(backgrounds, id: \.self) { background in
                    Image(background)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    background == selectedBackground
                                    ? .white
                                    : .init(red: 68/255, green: 71/255, blue: 124/255)
                                )
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedBackground = background
                            }
                        }
                        .padding(6)
                }
            }
            .padding(.top, 20)
            Spacer()
            
            Button {
                isPresentPrivacyWebView = true
            } label: {
                Text("Privacy policy")
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
            .sheet(isPresented: $isPresentPrivacyWebView) {
                NavigationStack {
                    WebView(url: URL(string: "https://sites.google.com/view/fragmentfusion/privacy-policy")!)
                        .ignoresSafeArea()
                        .navigationTitle("Privacy Policy")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
            
            Button {
                viewModel.deleteAcc()
                isPresentAlert = true
            } label: {
                Text("Delete acc")
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
            .alert("Are you sure?", isPresented: $isPresentAlert) {
                Button("Delete", role: .destructive) {
                    authMain.deleteUserAccount { result in
                        switch result {
                        case .success():
                            print("Account deleted successfully.")
                            authMain.userSession = nil
                            authMain.currentuser = nil
                            dismiss()
                        case .failure(let error):
                            print("ERROR DELELETING: \(error.localizedDescription)")
                        }
                    }
                }
                Button("Cancel", role: .cancel) {
                    
                }
            } message: {
                Text("Are you sure you want to delete the account?")
            }
        }
        .padding(.horizontal, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(selectedBackground)
                .resizable()
                .ignoresSafeArea()
                .transition(.opacity)
                .animation(.linear, value: selectedBackground)
        )
    }
}

#Preview {
    SettingsScreen(viewModel: .init(), authMain: .init(), path: .constant(.init()))
}
