import GgrMemoUtility

final public class MemoUseCase: MemoUseCaseProtocol {
    
    private let repository: MemoRepository

    public init(repository: MemoRepository) {
      self.repository = repository
    }
    
    public func addMemo(memo: Memo, tag: Tag){
        guard !memo.value.isEmptyByTrimming else { return }
        
        if (repository.searchMemo(memo: memo)) != nil {
            repository.updateMemo(memo: memo, tag: tag)
        } else {
            repository.addNewMemo(memo: memo, tag: tag)
        }
    }
    
    public func togleMemoCheckedStatus(memo: Memo) {
        guard let savedMemo = repository.searchMemo(memo: memo) else { return }
        repository.updateMemoCheckedStatus(savedMemo: savedMemo, bool: savedMemo.togleCheckStatus)
    }
    
    public func deleteCheckedMemos() {
        repository.searchCheckedMemos(isChecked: true).forEach { repository.deleteMemo(memo: $0) }
    }
    
    public func searchAllMemoData() -> [Memo] {
        repository.searchAllMemoData()
    }
    
    public func searchMemoWithMatchTag(tag: Tag) -> [Memo] {
        repository.searchMemoWithMatchTag(tag: tag)
    }
    
    public func deselectionAllMemo() {
        repository.searchCheckedMemos(isChecked: true).forEach {
            repository.updateMemoCheckedStatus(savedMemo: $0, bool: false)
        }
    }
}
