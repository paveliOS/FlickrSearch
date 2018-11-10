import Foundation

// Protocol for the response that we expect from the image source
protocol ImageResponse {
    var images: [Image] { get }
    var page: Int { get }
    var pages: Int { get }
    var perpage: Int { get }
    var total: Int { get }
}
