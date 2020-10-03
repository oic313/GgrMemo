import GgrMemoUtility

public protocol MemoUseCaseProtocol {
    func addMemo(memo: Memo, tag: Tag)
    
    func togleMemoCheckedStatus(memo: Memo)
    
    func deleteCheckedMemos()
    
    func searchAllMemoData() -> [Memo]
    
    func searchtMemoWithMatchTag(tag: Tag) -> [Memo]
    
    func deselectionAllMemo()
}
