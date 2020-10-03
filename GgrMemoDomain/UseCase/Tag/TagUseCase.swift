import GgrMemoUtility

final public class TagUseCase: TagUseCaseProtocol {
    
    private let repository: TagRepository

    public init(repository: TagRepository) {
      self.repository = repository
    }
    
    public func addTag(tag: Tag){
        guard !tag.value.isEmptyByTrimming else { return }
        if let savedTagData = repository.searchTag(tag: tag) {
            repository.updateTag(tag: tag, savedTagDate: savedTagData)
        } else {
            repository.addNewTag(tag: tag)
        }
    }
    
    public func searchIncludeSpaceTagList() -> [Tag] {
        var tagList = searchAllTag()
        tagList.insert(Tag("", color: .sub, isChecked: false), at: 0)
        return tagList
    }
    
    public func searchAllTag() -> [Tag] {
        repository.searchAllTag()
    }
    
    public func deleteCheckedTags() {
//        repository.searchCheckedTags(isChecked: true).forEach {
//            MemoCoreLogic.searchtMemoWithMatchTag(tag: $0).forEach { MemoCoreLogic.deleteMemo(memo: $0) }
//            repository.deleteTag(tag: $0)
//        }
    }

    public func togleTagCheckedStatus(tag: Tag) {
        guard let savedTagData = repository.searchTag(tag: tag) else { return }
        repository.updateTagCheckedStatus(savedTagDate: savedTagData, bool: savedTagData.togleCheckStatus)
    }
    
    public func deselectionAllTag() {
        repository.searchCheckedTags(isChecked: true).forEach {         repository.updateTagCheckedStatus(savedTagDate: repository.searchTag(tag: $0)!, bool: false) }
    }
    
}
