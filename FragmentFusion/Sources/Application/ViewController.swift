
import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let onbScreen = RootScreen(viewModel: .init())
//        let onbScreen = GameScreen(viewModel: .init(id: "1", image: "lvl3", gridCount: 3, isResolved: false), path: .constant(.init()))
        let onbScreen = OnboardingScreen()
        let hostContr = UIHostingController(rootView: onbScreen)
        
        addChild(hostContr)
        view.addSubview(hostContr.view)
        hostContr.didMove(toParent: self)
        
        hostContr.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostContr.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostContr.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostContr.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostContr.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
