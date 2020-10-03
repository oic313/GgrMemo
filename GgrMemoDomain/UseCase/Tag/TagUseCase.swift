import GgrMemoUtility

final public class TagUseCase: TagUseCaseProtocol {
    
    private let tagRepository: TagRepository
    private let memoRepository: MemoRepository
    
    public init(tagRepository: TagRepository, memoRepository: MemoRepository) {
        self.tagRepository = tagRepository
        self.memoRepository = memoRepository
    }
    
    public func addTag(tag: Tag){
        guard !tag.value.isEmptyByTrimming else { return }
        if (tagRepository.searchTag(tag: tag)) != nil {
            tagRepository.updateTag(tag: tag)
        } else {
            tagRepository.addNewTag(tag: tag)
        }
    }
    
    public func searchIncludeSpaceTagList() -> [Tag] {
        var tagList = searchAllTag()
        tagList.insert(Tag("", color: .sub, isChecked: false), at: 0)
        return tagList
    }
    
    public func searchAllTag() -> [Tag] {
        tagRepository.searchAllTag()
    }
    
    public func deleteCheckedTags() {
        tagRepository.searchCheckedTags(isChecked: true).forEach {
            memoRepository.searchMemoWithMatchTag(tag: $0).forEach { memoRepository.deleteMemo(memo: $0) }
            tagRepository.deleteTag(tag: $0)
        }
    }
    
    public func togleTagCheckedStatus(tag: Tag) {
        guard let savedTag = tagRepository.searchTag(tag: tag) else { return }
        tagRepository.updateTagCheckedStatus(savedTag: savedTag, bool: savedTag.togleCheckStatus)
    }
    
    public func deselectionAllTag() {
        tagRepository.searchCheckedTags(isChecked: true).forEach {
            tagRepository.updateTagCheckedStatus(savedTag: $0, bool: false)
        }
    }
    
}
