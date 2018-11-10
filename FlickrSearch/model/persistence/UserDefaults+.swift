import Foundation

extension UserDefaults {
    
    var searchQueries: [String] {
        get {
            return object(forKey: #function) as? [String] ?? []
        }
        set {
            set(newValue, forKey: #function)
        }
    }
    
}
