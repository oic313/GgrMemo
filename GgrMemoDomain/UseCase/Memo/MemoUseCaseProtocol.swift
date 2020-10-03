import GgrMemoUtility

public protocol MemoUseCaseProtocol {
    func addMemo(memo: Memo, tag: Tag)
    
    func togleMemoCheckedStatus(memo: Memo)
    
    func deleteCheckedMemos()
    
    func searchAllMemoData() -> [Memo]
    
    func searchMemoWithMatchTag(tag: Tag) -> [Memo]
    
    func deselectionAllMemo()
    
}
