import GgrMemoUtility

public class MemoBussinessLogic {}

public extension MemoBussinessLogic {
    static func addMemo(memo: Memo, tag: Tag){
        guard !memo.value.isEmptyByTrimming else { return }
        
        if let savedMemoData = MemoCoreLogic.searchMemo(memo: memo) {
            MemoCoreLogic.updateMemo(memo: memo, tag: tag, savedMemoDate: savedMemoData)
        } else {
            MemoCoreLogic.addNewMemo(memo: memo, tag: tag)
        }
    }
    
    static func togleMemoCheckedStatus(memo: Memo) {
        guard let savedMemoData = MemoCoreLogic.searchMemo(memo: memo) else { return }
        MemoCoreLogic.updateMemoCheckedStatus(savedMemoDate: savedMemoData, bool: savedMemoData.togleCheckStatus)
    }
    
    static func deleteCheckedMemos() {
        MemoCoreLogic.searchCheckedMemos(isChecked: true).forEach { MemoCoreLogic.deleteMemo(memo: $0) }
    }
    
    static func searchAllMemoData() -> [Memo] {
        MemoCoreLogic.searchAllMemoData()
    }
    
    static func searchtMemoWithMatchTag(tag: Tag) -> [Memo] {
        MemoCoreLogic.searchtMemoWithMatchTag(tag: tag)
    }
    
    static func deselectionAllMemo() {
        MemoCoreLogic.searchCheckedMemos(isChecked: true).forEach {         MemoCoreLogic.updateMemoCheckedStatus(savedMemoDate: MemoCoreLogic.searchMemo(memo: $0)!, bool: false) }
    }
}
