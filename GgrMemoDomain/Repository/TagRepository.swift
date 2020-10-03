import  GgrMemoUtility

public protocol TagRepository {
    
    func searchTag(tag: Tag) -> Tag?
    
    func addNewTag(tag: Tag)
    
    func updateTag(tag: Tag)
    
    func searchCheckedTags(isChecked: Bool) -> [Tag]
    
    func deleteTag(tag: Tag)
    
    func updateTagCheckedStatus(savedTag: Tag, bool: Bool)
    
    func searchAllTag() -> [Tag]
    
}
