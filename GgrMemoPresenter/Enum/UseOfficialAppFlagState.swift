public enum UseOfficialAppFlagState: String {
    case on = "公式アプリで検索"
    case off = "アプリ内で検索"
    
    public var isOn: Bool {
        switch self {
        case .on:
            return true
        case .off:
            return false
        }
    }
    
    public mutating func toggle() {
        switch self {
        case .on:
            self = .off
        case .off:
            self = .on
        }
    }
}
