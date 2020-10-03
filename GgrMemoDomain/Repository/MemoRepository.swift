import  GgrMemoUtility

public protocol MemoRepository {

    func searchMemo(memo: Memo) -> Memo?
    
    func searchCheckedMemos(isChecked: Bool) -> [Memo]
    
    func deleteMemo(memo: Memo)
    
    func addNewMemo(memo: Memo, tag: Tag)
    
    func updateMemo(memo: Memo, tag: Tag)
        
    func updateMemoCheckedStatus(savedMemo: Memo, bool: Bool)
    
    func searchAllMemoData() -> [Memo]
    
    func searchMemoWithMatchTag(tag: Tag) -> [Memo]
}
