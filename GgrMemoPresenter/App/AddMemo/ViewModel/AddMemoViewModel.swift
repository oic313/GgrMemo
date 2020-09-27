import GgrMemoUtility

public struct AddMemoViewModel {
    public let tag: Tag
    public let memos: [Memo]

    public init(tag: Tag, memos: [Memo]) {
        self.tag = tag
        self.memos = memos
    }
}
