import Foundation

// Protocol for the image that we expect from the image source. Contains data needed to display it
protocol Image {
    var url: URL? { get }
}
