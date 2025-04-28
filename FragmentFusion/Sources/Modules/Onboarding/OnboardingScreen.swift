
import SwiftUI
import WebKit

struct OnboardingScreen: View {
    @State var isLoad: Bool = false
    var body: some View {
        if isLoad {
            RootScreen(viewModel: .init())
        } else {
            VStack {
                Spacer()
                Spacer()
                Spacer()

                GIFView(gifName: "loader")
                    .frame(maxWidth: .infinity)
                
                Text("Loading...")
                    .foregroundStyle(.white)
                    .font(.custom("Dosis-Bold", size: 64))
                
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image(.onboardingBackground)
                    .resizable()
                    .ignoresSafeArea()
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isLoad = true
                }
            }
        }
    }
}

#Preview {
    OnboardingScreen()
}

struct GIFView: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        
        webView.isOpaque = false
        webView.backgroundColor = UIColor.clear
        webView.scrollView.backgroundColor = UIColor.clear
        
        if let path = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let url = URL(fileURLWithPath: path)
            let data = try? Data(contentsOf: url)
            webView.load(data!, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        }
        
        webView.scrollView.isScrollEnabled = false
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
