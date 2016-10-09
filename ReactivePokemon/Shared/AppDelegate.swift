import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootViewController: UIViewController? {
        return window?.rootViewController
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        URLCache.shared = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: nil)
        return true
    }
}

