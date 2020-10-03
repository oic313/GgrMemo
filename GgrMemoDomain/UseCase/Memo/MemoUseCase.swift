import GgrMemoUtility

final public class MemoUseCase: MemoUseCaseProtocol {
    
    private let repository: MemoRepository

    public init(repository: MemoRepository) {
      self.repository = repository
    }
    
    public func addMemo(memo: Memo, tag: Tag){
        guard !memo.value.isEmptyByTrimming else { return }
        
        if let savedMemoData = repository.searchMemo(memo: memo) {
            repository.updateMemo(memo: memo, tag: tag, savedMemoDate: savedMemoData)
        } else {
            repository.addNewMemo(memo: memo, tag: tag)
        }
    }
    
    public func togleMemoCheckedStatus(memo: Memo) {
        guard let savedMemoData = repository.searchMemo(memo: memo) else { return }
        repository.updateMemoCheckedStatus(savedMemoDate: savedMemoData, bool: savedMemoData.togleCheckStatus)
    }
    
    public func deleteCheckedMemos() {
        repository.searchCheckedMemos(isChecked: true).forEach { repository.deleteMemo(memo: $0) }
    }
    
    public func searchAllMemoData() -> [Memo] {
        repository.searchAllMemoData()
    }
    
    public func searchtMemoWithMatchTag(tag: Tag) -> [Memo] {
        repository.searchtMemoWithMatchTag(tag: tag)
    }
    
    public func deselectionAllMemo() {
        repository.searchCheckedMemos(isChecked: true).forEach {         repository.updateMemoCheckedStatus(savedMemoDate: repository.searchMemo(memo: $0)!, bool: false) }
    }
}
