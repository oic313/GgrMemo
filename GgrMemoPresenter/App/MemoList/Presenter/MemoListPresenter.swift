import GgrMemoUtility
import GgrMemoDomain

public protocol MemoListView: AnyObject {
    func redraw(model: MemoListViewModel)
}

final public class MemoListPresenter {
    private let memoUseCase: MemoUseCaseProtocol = RepositoryResolverHolder.shared.resolver.resolveMemoUseCase()
    private let tagUseCase: TagUseCaseProtocol = RepositoryResolverHolder.shared.resolver.resolveTagUseCase()
    public weak var view: MemoListView?  // NOTE: これがdelegate
    
    private var settingList: [SettingViewCellType] {
        [
            .edit(EditAction.allCases),
            .tapActionEdit(TapAction.allCases),
            .useOfficialAppFlag
        ]
    }
    
    private var tagAndMemoList: [CollectionViewCellType] {
        tagUseCase.searchIncludeSpaceTagList().flatMap {
            [
                .tag($0),
                .memoList(MemoListModel(memos: memoUseCase.searchMemoWithMatchTag(tag: $0), color: $0.color))
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

}

public extension MemoListPresenter {
    
    func showPage() {
        guard let view = view else { return }
        view.redraw(model: MemoListViewModel(displayList: displayList))
    }
    
    func checkedMemo(memo: Memo) {
        guard let view = view else { return }
        memoUseCase.togleMemoCheckedStatus(memo: memo)
        view.redraw(model: MemoListViewModel(displayList: displayList))
    }
    
    func checkedTag(tag: Tag, indexPath: IndexPath) {
        guard let view = view else { return }
        tagUseCase.togleTagCheckedStatus(tag: tag)
        view.redraw(model: MemoListViewModel(displayList: displayList))
    }
    
    func deleteCheckedMemos() {
        guard let view = view else { return }
        memoUseCase.deleteCheckedMemos()
        view.redraw(model: MemoListViewModel(displayList: displayList))
    }
    
    func deleteCheckedTags() {
        guard let view = view else { return }
        tagUseCase.deleteCheckedTags()
        view.redraw(model: MemoListViewModel(displayList: displayList))
    }
    
    func deselectionAll() {
        guard let view = view else { return }
        memoUseCase.deselectionAllMemo()
        tagUseCase.deselectionAllTag()
        view.redraw(model: MemoListViewModel(displayList: displayList))
    }
    
}
