import GgrMemoUtility
import GgrMemoModel
import GgrMemoDomain

public protocol AddMemoView: AnyObject {
    func dissmiss()
}

final public class AddMemoPresenter {
    private let memoUseCase: MemoUseCaseProtocol = RepositoryResolverHolder.shared.resolver.resolveMemoUseCase()
    public weak var view: AddMemoView?
    public lazy var tagList = TagBussinessLogic.searchAllTag()
    public lazy var tagColorList = [ColorAsset.red, ColorAsset.orange, ColorAsset.sub, ColorAsset.green, ColorAsset.lightBlue, ColorAsset.blue, ColorAsset.purple]
    
    public init() {}

    public func addMemoData(addModel: AddMemoViewModel) {
        guard let view = view else { return }
        TagBussinessLogic.addTag(tag: addModel.tag)
        addModel.memos.forEach {
            memoUseCase.addMemo(memo: $0, tag: addModel.tag)
        }
        view.dissmiss()
    }

}
