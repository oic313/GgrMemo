import GgrMemoUtility
import GgrMemoModel

final public class AddMemoPresenter {
    public lazy var tagList = FatLogic.searchAllTag()
    public lazy var tagColorList = [ColorAsset.red, ColorAsset.orange, ColorAsset.sub, ColorAsset.green, ColorAsset.lightBlue, ColorAsset.blue, ColorAsset.purple]
    
    public init() {}

    public func addMemoData(addModel: AddMemoViewModel) {
        FatLogic.addTag(tag: addModel.tag)
        addModel.memos.forEach {
            FatLogic.addMemo(memo: $0, tag: addModel.tag)
            
        }
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
