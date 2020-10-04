import GgrMemoUtility

public protocol TagUseCaseProtocol {
    func addTag(tag: Tag)
    
    func searchIncludeSpaceTagList() -> [Tag]
    
    func searchAllTag() -> [Tag]
    
    func deleteCheckedTags()

    func togleTagCheckedStatus(tag: Tag)
    
    func deselectionAllTag()
    
}
