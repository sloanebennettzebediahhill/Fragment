
import SwiftUI
import PhotosUI

struct ProfileScreen: View {
    @StateObject private var viewModel: ProfileViewModel
    @ObservedObject var authMain: AuthMain
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    @State private var showingImagePicker = false
    @State private var selectedImage: PhotosPickerItem? = nil
    @AppStorage("selectedBackground") private var selectedBackground: String = "mainBackground"
    
    init(viewModel: ProfileViewModel, authMain: AuthMain, path: Binding<NavigationPath>) {
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
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                }
                Spacer()
                Text("Profile")
                    .foregroundStyle(.white)
                    .font(.custom("Dosis-Bold", size: 44))
                    .padding(.trailing, 44)
                Spacer()
            }
            
            if let image = viewModel.displayImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .background(Color(red: 197/255, green: 197/255, blue: 197/255))
                    .cornerRadius(40)
                    .onTapGesture {
                        showingImagePicker = true
                    }
                    .padding(.horizontal, 86)
                    .padding(.top, 60)
            } else {
                Rectangle()
                    .fill(Color(red: 197/255, green: 197/255, blue: 197/255))
                    .cornerRadius(40)
                    .frame(height: 200)
                    .onTapGesture {
                        showingImagePicker = true
                    }
                    .padding(.horizontal, 86)
                    .padding(.top, 60)
            }
            
            Text(authMain.currentuser?.name ?? "Anonimous")
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundStyle(Color.init(red: 200/255, green: 215/255, blue: 240/255))
                .font(.custom("Dosis-Bold", size: 24))
                .textCase(.uppercase)
                .lineLimit(1)
                .padding(.top, 10)
            Spacer()
            HStack {
                VStack {
                    Text("puzzles complete:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.init(red: 200/255, green: 215/255, blue: 240/255))
                        .font(.custom("Dosis-Bold", size: 16))
                        .textCase(.uppercase)
                        .lineLimit(1)
                    Text("\(viewModel.completedPuzzlesCount)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.init(red: 200/255, green: 215/255, blue: 240/255))
                        .font(.custom("Dosis-Bold", size: 44))
                        .textCase(.uppercase)
                        .lineLimit(1)
                }
                .padding(16)
                .background(Color.init(red: 44/255, green: 150/255, blue: 201/255))
                .cornerRadius(20)

                VStack {
                    Text("average time:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.init(red: 200/255, green: 215/255, blue: 240/255))
                        .font(.custom("Dosis-Bold", size: 16))
                        .textCase(.uppercase)
                        .lineLimit(1)
                    Text(viewModel.averageCompletionTime)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(Color.init(red: 200/255, green: 215/255, blue: 240/255))
                        .font(.custom("Dosis-Bold", size: 44))
                        .textCase(.uppercase)
                        .lineLimit(1)
                }
                .padding(16)
                .background(Color.init(red: 44/255, green: 150/255, blue: 201/255))
                .cornerRadius(20)
            }
            
            Spacer()
            
            Button {
                viewModel.resetData()
            } label: {
                Text("Reset progress")
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
                authMain.signOut()
                dismiss()
            } label: {
                Text("Log out")
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .font(.custom("Dosis-Bold", size: 32))
                    .textCase(.uppercase)
                    .padding(.vertical, 21)
            }
            .background(LinearGradient(colors: [
                Color.init(red: 245/255, green: 80/255, blue: 80/255),
                Color.init(red: 171/255, green: 0/255, blue: 0/255)
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
                .transition(.opacity)
                .animation(.linear, value: selectedBackground)
        )
        .photosPicker(
            isPresented: $showingImagePicker,
            selection: $selectedImage,
            matching: .images,
            photoLibrary: .shared()
        )
        .task(id: selectedImage) {
            if let item = selectedImage {
                await viewModel.saveProfileImageAsync(item: item)
                selectedImage = nil
            }
        }
        .onAppear {
            viewModel.updateGameStats()
        }
    }
}

#Preview {
    ProfileScreen(viewModel: .init(), authMain: .init(), path: .constant(.init()))
}
