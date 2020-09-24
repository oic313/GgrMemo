import GgrMemoUtility
import GgrMemoModel

public protocol AddMemoView: AnyObject {
    func dissmiss()
}

final public class AddMemoPresenter {
    public weak var view: AddMemoView?
    public lazy var tagList = FatLogic.searchAllTag()
    public lazy var tagColorList = [ColorAsset.red, ColorAsset.orange, ColorAsset.sub, ColorAsset.green, ColorAsset.lightBlue, ColorAsset.blue, ColorAsset.purple]
    
    public init() {}

    public func addMemoData(addModel: AddMemoViewModel) {
        guard let view = view else { return }
        FatLogic.addTag(tag: addModel.tag)
        addModel.memos.forEach {
            FatLogic.addMemo(memo: $0, tag: addModel.tag)
            
        }
        view.dissmiss()
    }

}

public struct AddMemoViewModel {
    public let tag: Tag
    public let memos: [Memo]

    public init(tag: Tag, memos: [Memo]) {
        self.tag = tag
        self.memos = memos
    }

}
