
extension String {
    var url: URL? {
        guard let encode = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        return URL(string: encode)
    }
}
