
import SwiftUI

struct FinishScreen: View {
    @State var time: String
    var onNextTap: (() -> Void)?
    var onQuitTap: (() -> Void)?
    
    init(time: String, onNextTap: (() -> Void)? = nil, onQuitTap: (() -> Void)? = nil) {
        self.time = time
        self.onNextTap = onNextTap
        self.onQuitTap = onQuitTap
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Congratulations \nyour time is:")
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .font(.custom("Dosis-ExtraBold", size: 32))
                .textCase(.uppercase)
                .customStroke(color: .init(red: 116/255, green: 151/255, blue: 178/255), width: 1)
                .padding(.top, 10)
            Text(time)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.white)
                .font(.custom("Dosis-ExtraBold", size: 84))
                .textCase(.uppercase)
                .customStroke(color: .init(red: 116/255, green: 151/255, blue: 178/255), width: 3)
                .padding(.bottom, 60)
            HStack(spacing: 13) {
                Button {
                    onQuitTap?()
                } label: {
                    Image(.finishQuitButton)
                        .resizable()
                        .scaledToFit()
                }
                
                Button {
                    onNextTap?()
                } label: {
                    Image(.finishNextButton)
                        .resizable()
                        .scaledToFit()
                }

            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        .frame(maxWidth: .infinity)
        .background(LinearGradient(colors: [
            Color.init(red: 200/255, green: 215/255, blue: 240/255),
            Color.init(red: 138/255, green: 176/255, blue: 203/255)
        ], startPoint: .leading, endPoint: .trailing))
        .cornerRadius(50)
        .padding(20)
        .background(.white)
        .cornerRadius(60)
    }
}


#Preview {
    FinishScreen(time: "")
//        .padding(10)
        .background(.black)
}
