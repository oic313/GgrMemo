
public enum ColorAsset: String {
    case main
    case sub
    case thin
    case text
    case blue
    case green
    case lightBlue
    case orange
    case purple
    case red
}


public struct Tag {
    public let value: String
    public let color: ColorAsset
    
    public var displayValue: String {
        if value == "" {
            return "メモ"
        }
        return value
    }
    
    public init(_ tag: String, color: ColorAsset){
        self.value = tag
        self.color = color
    }
}

public struct Memo {
    public let value: String
    public let tag: String
    public var isChecked: Bool
    public let id: String?

    public init(_ memo: String, tag: String, isChecked: Bool, id: String? = nil){
        self.value = memo
        self.tag = tag
        self.isChecked = isChecked
        self.id = id
    }
}






public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String { String(describing: self) }

    var className: String { type(of: self).className }
}

extension NSObject: ClassNameProtocol {}
