import  GgrMemoUtility

public protocol MemoRepository {
    //MemoData -> Memo
    func searchMemo(memo: Memo) -> Memo?
    
    func searchCheckedMemos(isChecked: Bool) -> [Memo]
    
    func deleteMemo(memo: Memo)
    
    func addNewMemo(memo: Memo, tag: Tag)
    
    //
    func updateMemo(memo: Memo, tag: Tag, savedMemoDate: Memo)
    
    
    //
    func updateMemoCheckedStatus(savedMemoDate: Memo, bool: Bool)
    
    func searchAllMemoData() -> [Memo]
    
    func searchtMemoWithMatchTag(tag: Tag) -> [Memo]
}
