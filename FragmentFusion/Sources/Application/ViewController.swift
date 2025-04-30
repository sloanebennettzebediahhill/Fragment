
import UIKit
import SwiftUI

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func rootViewC(_ viewController: UIViewController) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = viewController
        }
    }
    
    func secondOpen(string: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            for child in self.children {
                if child is FirstViewController {
                    return
                }
            }
            guard !string.isEmpty else { return }
            let secondController = FirstViewController(url: string)
            self.addChild(secondController)
            secondController.view.frame = self.view.bounds
            secondController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.view.addSubview(secondController.view)
            secondController.didMove(toParent: self)
        }
    }

    
    func helpStr(mainSting: String, deviceID: String, advertaiseID: String, appsflId: String) -> (String) {
        var str = ""
        
        str = "\(mainSting)?fghj=\(deviceID)&uytr=\(advertaiseID)&poiu=\(appsflId)"
        
        return str
    }
    
    func firstOpen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let onboardingScreen = RootScreen(viewModel: .init())
            let hostingController = UIHostingController(rootView: onboardingScreen)
            self.rootViewC(hostingController)
        }
    }
}
