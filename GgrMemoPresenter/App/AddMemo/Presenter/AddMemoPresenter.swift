import GgrMemoUtility
import GgrMemoDomain

public protocol AddMemoView: AnyObject {
    func dissmiss()
}

final public class AddMemoPresenter {
    private let memoUseCase: MemoUseCaseProtocol = RepositoryResolverHolder.shared.resolver.resolveMemoUseCase()
    private let tagUseCase: TagUseCaseProtocol = RepositoryResolverHolder.shared.resolver.resolveTagUseCase()
    public weak var view: AddMemoView?
    public lazy var tagList = tagUseCase.searchAllTag()
    public lazy var tagColorList = [ColorAsset.red, ColorAsset.orange, ColorAsset.sub, ColorAsset.green, ColorAsset.lightBlue, ColorAsset.blue, ColorAsset.purple]
    
    public init() {}

    public func addMemoData(addModel: AddMemoViewModel) {
        guard let view = view else { return }
        tagUseCase.addTag(tag: addModel.tag)
        addModel.memos.forEach {
            memoUseCase.addMemo(memo: $0, tag: addModel.tag)
        }
        view.dissmiss()
    }

}
