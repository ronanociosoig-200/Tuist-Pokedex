import UIKit
import Common

struct LaunchArguments {
    static let uiTesting = "CatchUITesting"
    static let error401 = "Error_401"
    static let leaveIt = "LeaveIt"
    static let disableAnimations = "DisableAnimations"
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let appController = AppController()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        disableAnimations()
        appController.start()
        return true
    }
    
    func disableAnimations() {
        let arguments = ProcessInfo.processInfo.arguments
        UIView.setAnimationsEnabled(!arguments.contains(LaunchArguments.disableAnimations))
    }
}
