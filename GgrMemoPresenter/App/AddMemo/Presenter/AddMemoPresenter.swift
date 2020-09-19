import GgrMemoUtility
import GgrMemoModel

final public class AddMemoPresenter {
    public lazy var tagList = FatLogic.searchAllTag()
    public lazy var tagColorList = [ColorAsset.red, ColorAsset.orange, ColorAsset.sub, ColorAsset.green, ColorAsset.lightBlue, ColorAsset.blue, ColorAsset.purple]
    
    public init() {}

    public func addMemoData(addModel: AddMemoViewModel) {
        addModel.memoList.memos.forEach {
            FatLogic.addTag(tag: Tag($0.tag, color: addModel.memoList.color))
            FatLogic.addMemo(memo: $0)
            
        }
    }

}

public struct AddMemoViewModel {
    public let memoList: MemoListModel

    public init(memos: [Memo], color: ColorAsset) {
        self.memoList = MemoListModel(memos: memos, color: color)
    }

}
