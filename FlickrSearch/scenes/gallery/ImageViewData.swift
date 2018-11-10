import Foundation

struct ImageViewData {
    
    let url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
}

extension ImageViewData: Equatable {}
