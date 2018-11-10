import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?

    private func setInitialScreen() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let galleryView = GalleryRouter.setupGalleryModule()
        window?.rootViewController = galleryView
        window?.makeKeyAndVisible()
    }

}

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setInitialScreen()
        return true
    }
    
}

