import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {

    var window: UIWindow?

    private func setInitialScreen() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let flickrPhotosService = FlickrPhotosService()
        let galleryView = GalleryRouter.setupGalleryModule(title: "Flickr", imageSource: flickrPhotosService)
        window?.rootViewController = galleryView
        window?.makeKeyAndVisible()
    }

}

extension AppDelegate: UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [.foregroundColor: UIColor.white]
        setInitialScreen()
        return true
    }
    
}

