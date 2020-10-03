
public struct Memo {
    public let value: String
    public var isChecked: Bool
    public let id: String?

    public var togleCheckStatus: Bool { !isChecked }

    public init(_ memo: String, isChecked: Bool, id: String? = nil){
        self.value = memo
        self.isChecked = isChecked
        self.id = id
    }
}
