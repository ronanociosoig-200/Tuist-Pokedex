import UIKit
import Common

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let appController = AppController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        disableAnimations()
        appController.start()
        return true
    }
    
    func disableAnimations() {
        let arguments = ProcessInfo.processInfo.arguments
        UIView.setAnimationsEnabled(!arguments.contains("UITesting"))
    }
}
