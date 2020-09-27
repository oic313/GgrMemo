import GgrMemoUtility
import GgrMemoModel

public protocol MemoListView: AnyObject {
    func redraw(model: MemoListViewModel)
}

final public class MemoListPresenter {
    public weak var view: MemoListView?  // NOTE: これがdelegate
    
    private var settingList: [SettingViewCellType] {
        [
            .edit(EditAction.allCases),
            .tapActionEdit(TapAction.allCases),
            .useOfficialAppFlag
        ]
    }
    
    private var tagAndMemoList: [CollectionViewCellType] {
        TagBussinessLogic.searchIncludeSpaceTagList().flatMap {
            [
                .tag($0),
                .memoList(MemoListModel(memos: MemoBussinessLogic.searchtMemoWithMatchTag(tag: $0), color: $0.color))
            ]
        }
    }
    
    private var displayList: [CollectionViewCellType] {
        var list = tagAndMemoList
        list.insert(.setting(settingList), at: 0)
        list.append(.space)
        return list
    }
    
    public init() {}
    
    public func showPage() {
        guard let view = view else { return }
        view.redraw(model: MemoListViewModel(displayList: displayList))
    }
    
    public func checkedMemo(memo: Memo, indexPath: IndexPath) {
        guard let view = view else { return }
        MemoBussinessLogic.togleMemoCheckedStatus(memo: memo)
        view.redraw(model: MemoListViewModel(displayList: displayList))
    }
    
    public func checkedTag(tag: Tag, indexPath: IndexPath) {
        guard let view = view else { return }
        TagBussinessLogic.togleTagCheckedStatus(tag: tag)
        view.redraw(model: MemoListViewModel(displayList: displayList))
    }
    
    public func deleteCheckedMemos() {
        guard let view = view else { return }
        MemoBussinessLogic.deleteCheckedMemos()
        view.redraw(model: MemoListViewModel(displayList: displayList))
    }
    
    public func deleteCheckedTags() {
        guard let view = view else { return }
        TagBussinessLogic.deleteCheckedTags()
        view.redraw(model: MemoListViewModel(displayList: displayList))
    }
    
    public func deselectionAll() {
        guard let view = view else { return }
        MemoBussinessLogic.deselectionAllMemo()
        TagBussinessLogic.deselectionAllTag()
        view.redraw(model: MemoListViewModel(displayList: displayList))
    }
    
}

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

public enum CollectionViewCellType {
    case setting([SettingViewCellType])
    case tag(Tag)
    case memoList(MemoListModel)
    case space
}

public enum SettingViewCellType {
    case edit([EditAction])
    case tapActionEdit([TapAction])
    case useOfficialAppFlag

}

public enum EditAction: String, CaseIterable {
    case deleteMemo = "チェックしたメモを削除"
    case deleteTag = "チェックしたタグを削除"
    case cancelCecked = "すべてのチェックを解除"
}

public enum TapAction: String, CaseIterable {
    case checked = "タップでチェック"
    case edit = "タップで編集"
    case search = "タップで検索"
    case searchOnYoutube = "タップでYoutubeで検索"
    case searchOnTwitter = "タップでTwitterで検索"
}

public enum useOfficialAppFlagState: String {
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
