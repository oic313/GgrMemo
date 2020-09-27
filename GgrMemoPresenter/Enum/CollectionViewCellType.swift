import GgrMemoUtility

public enum CollectionViewCellType {
    case setting([SettingViewCellType])
    case tag(Tag)
    case memoList(MemoListModel)
    case space
}
