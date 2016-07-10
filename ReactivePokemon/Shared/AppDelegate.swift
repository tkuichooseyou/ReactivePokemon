import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var rootViewController: UIViewController? {
        return window?.rootViewController
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        NSURLCache.setSharedURLCache(NSURLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: nil))
        return true
    }
}

