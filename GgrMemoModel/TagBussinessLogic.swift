import GgrMemoUtility

public class TagBussinessLogic {}

public extension TagBussinessLogic {
    static func addTag(tag: Tag){
        guard !tag.value.isEmptyByTrimming else { return }
        if let savedTagData = TagCoreLogic.searchTag(tag: tag) {
            TagCoreLogic.updateTag(tag: tag, savedTagDate: savedTagData)
        } else {
            TagCoreLogic.addNewTag(tag: tag)
        }
    }
    
    static func searchIncludeSpaceTagList() -> [Tag] {
        var tagList = searchAllTag()
        tagList.insert(Tag("", color: .sub, isChecked: false), at: 0)
        return tagList
    }
    
    static func searchAllTag() -> [Tag] {
        TagCoreLogic.searchAllTag()
    }
    
    static func deleteCheckedTags() {
        TagCoreLogic.searchCheckedTags(isChecked: true).forEach {
            MemoCoreLogic.searchtMemoWithMatchTag(tag: $0).forEach { MemoCoreLogic.deleteMemo(memo: $0) }
            TagCoreLogic.deleteTag(tag: $0)
        }
    }

    static func togleTagCheckedStatus(tag: Tag) {
        guard let savedTagData = TagCoreLogic.searchTag(tag: tag) else { return }
        TagCoreLogic.updateTagCheckedStatus(savedTagDate: savedTagData, bool: savedTagData.togleCheckStatus)
    }
    
    static func deselectionAllTag() {
        TagCoreLogic.searchCheckedTags(isChecked: true).forEach {         TagCoreLogic.updateTagCheckedStatus(savedTagDate: TagCoreLogic.searchTag(tag: $0)!, bool: false) }
    }
    
}
