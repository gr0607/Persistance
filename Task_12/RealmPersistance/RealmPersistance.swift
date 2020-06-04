import RealmSwift
import Foundation

class MyItem: Object {
    @objc dynamic var item = ""
}

class RealmPersistance {
    
    static let shared = RealmPersistance()
    
    private let realm = try! Realm()
    
     var myItems = [MyItem]()
       
    func getItems() {
        let myItems = realm.objects(MyItem.self)
        for item in myItems {
            self.myItems.append(item)
            print(item.item + " type \(type(of: item))")
        }
    }
    
    func addItem(_ item: String) {
        let newItem = MyItem()
        newItem.item = item
        myItems.append(newItem)
        
        try! realm.write {
            realm.add(newItem)
        }
    }
    
    func removeItem(_ item: MyItem) {
        try! realm.write {
            realm.delete(item)
        }
    }
}
