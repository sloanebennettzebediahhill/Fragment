
import SwiftUI

struct HowToPlayScreen: View {
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
                Text("How to play")
                    .foregroundStyle(.white)
                    .font(.custom("Dosis-Bold", size: 44))
                    .padding(.trailing, 44)
                Spacer()
            }
            ScrollView(showsIndicators: false, content: {
                Text("Choose a Puzzle")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(red: 200/255, green: 215/255, blue: 240/255))
                    .font(.custom("Dosis-Bold", size: 24))
                Text("Select a ready-made puzzle from our collection — various themes and difficulty levels are available!")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(red: 200/255, green: 215/255, blue: 240/255))
                    .font(.custom("Dosis-Bold", size: 16))
                
                Text("Create Your Own Puzzle")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(red: 200/255, green: 215/255, blue: 240/255))
                    .font(.custom("Dosis-Bold", size: 24))
                    .padding(.top, 32)
                Text("Want something unique? Upload your own photo and turn it into a custom puzzle in seconds.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(red: 200/255, green: 215/255, blue: 240/255))
                    .font(.custom("Dosis-Bold", size: 16))
                
                Text("Start Assembling")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(red: 200/255, green: 215/255, blue: 240/255))
                    .font(.custom("Dosis-Bold", size: 24))
                    .padding(.top, 32)
                Text("Click on one puzzle piece, then click on another to swap them. Keep going until the puzzle is complete.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(red: 200/255, green: 215/255, blue: 240/255))
                    .font(.custom("Dosis-Bold", size: 16))
                
                Text("Save Your Progress")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(red: 200/255, green: 215/255, blue: 240/255))
                    .font(.custom("Dosis-Bold", size: 24))
                    .padding(.top, 32)
                Text("Leave anytime — your progress is saved automatically!")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color(red: 200/255, green: 215/255, blue: 240/255))
                    .font(.custom("Dosis-Bold", size: 16))
            })
            .padding(.top, 60)
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
    HowToPlayScreen(path: .constant(.init()))
}
