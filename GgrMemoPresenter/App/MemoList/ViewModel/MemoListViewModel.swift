import GgrMemoUtility

public struct MemoListViewModel {
    public let displayList: [CollectionViewCellType]
    
    public init(displayList: [CollectionViewCellType]){
        self.displayList = displayList
    }
}

public struct MemoListModel {
    public let memos: [Memo]
    public let color: ColorAsset
    
    public init(memos: [Memo], color: ColorAsset){
        self.memos = memos
        self.color = color
    }
}
