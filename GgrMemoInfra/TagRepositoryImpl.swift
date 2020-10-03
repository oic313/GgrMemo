import GgrMemoDomain
import GgrMemoUtility
import RealmSwift

public class TagRepositoryImpl: TagRepository {
    
    public init(){}
    
    //
    public func searchTag(tag: Tag) -> Tag? {
        let realm = try! Realm()
        let savedTagData = realm.objects(TagData.self).filter("tag == %@" , tag.value).sorted(byKeyPath: "updateDate", ascending: false).first
        return savedTagData?.value
    }
    
    public func addNewTag(tag: Tag) {
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        // Realmに書き込み
        let savedTagData = TagData()
        try! realm.write {
            savedTagData.tag = tag.value
            savedTagData.updateDate = NSDate()
            savedTagData.color = tag.color.rawValue
            savedTagData.isChecked = false
            realm.add(savedTagData)
        }
    }
    
    //
    public func updateTag(tag: Tag, savedTagDate: Tag) {
//        let realm = try! Realm()
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
//        // Realmに書き込み
//        let savedTagData = savedTagDate
//        try! realm.write {
//            savedTagData.updateDate = NSDate()
//            savedTagData.color = tag.color.rawValue
//            savedTagData.isChecked = false
//            realm.add(savedTagData)
//        }
    }
    
    public func searchCheckedTags(isChecked: Bool) -> [Tag] {
        let realm = try! Realm()
        let savedTagData = realm.objects(TagData.self).filter("isChecked == %@", isChecked)
        let tags = Array(savedTagData.map{ $0.value })
        return tags
    }
    
    public func deleteTag(tag: Tag) {
        let realm = try! Realm()
        guard let savedTagData = realm.objects(TagData.self).filter("tag == %@", tag.value ).first else { return }
        try! realm.write {
            realm.delete(savedTagData)
        }
    }
    
    //
    public func updateTagCheckedStatus(savedTagDate: Tag, bool: Bool) {
//        // Realmを初期化
//        let realm = try! Realm()
//        // Realmに書き込み
//        try! realm.write {
//            savedTagDate.isChecked = bool
//        }
    }
    
    public func searchAllTag() -> [Tag] {
        let realm = try! Realm()
        let savedMemoData = realm.objects(TagData.self).sorted(byKeyPath: "updateDate", ascending: false)
        let tags = Array(savedMemoData.map{ $0.value })
        return tags
    }
    
}
