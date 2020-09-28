import GgrMemoUtility
import GgrMemoModel

public protocol AddMemoView: AnyObject {
    func dissmiss()
}

final public class AddMemoPresenter {
    public weak var view: AddMemoView?
    public lazy var tagList = TagBussinessLogic.searchAllTag()
    public lazy var tagColorList = [ColorAsset.red, ColorAsset.orange, ColorAsset.sub, ColorAsset.green, ColorAsset.lightBlue, ColorAsset.blue, ColorAsset.purple]
    
    public init() {}

    public func addMemoData(addModel: AddMemoViewModel) {
        guard let view = view else { return }
        TagBussinessLogic.addTag(tag: addModel.tag)
        addModel.memos.forEach {
            MemoBussinessLogic.addMemo(memo: $0, tag: addModel.tag)
        }
        view.dissmiss()
    }

}
