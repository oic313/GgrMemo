import  GgrMemoUtility

public protocol TagRepository {
    
    //
    func searchTag(tag: Tag) -> Tag?
    
    func addNewTag(tag: Tag)
    
    //
    func updateTag(tag: Tag, savedTagDate: Tag)
    
    func searchCheckedTags(isChecked: Bool) -> [Tag]
    
    func deleteTag(tag: Tag)
    
    //
    func updateTagCheckedStatus(savedTagDate: Tag, bool: Bool)
    
    func searchAllTag() -> [Tag]
    
}
