import Foundation

protocol GalleryPersistenceManager: class {
    var searchQueries: [String] { get set }
}

extension UserDefaults: GalleryPersistenceManager {
    
    var searchQueries: [String] {
        get {
            return object(forKey: #function) as? [String] ?? []
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
}
