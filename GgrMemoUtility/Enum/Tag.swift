public struct Tag {
    public let value: String
    public let color: ColorAsset
    public var isChecked: Bool

    public var displayValue: String {
        if value == "" {
            return "メモ"
        }
        return value
    }
    
    public init(_ tag: String, color: ColorAsset, isChecked: Bool){
        self.value = tag
        self.color = color
        self.isChecked = isChecked
    }
}
