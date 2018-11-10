// Protocol for the image source that we want to use in the project
protocol ImageSourceAPI: class {
    func load(query: String?, page: Int?, perPage: Int, callback: ((ImageResponse?) -> Void)?)
}
