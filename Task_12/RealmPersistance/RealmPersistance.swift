import RealmSwift
import Foundation

class MyItem: Object {
    @objc dynamic var item = ""
    @objc dynamic var status = 0
}

class RealmPersistance {
    
    static let shared = RealmPersistance()
    
    private var realm = try! Realm()
    
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
        newItem.status = 0
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
    
    func updateItem(_ item: MyItem,_ description: String ) {
        
        let theItem = realm.objects(MyItem.self).filter("item == %@", item.item ).first
       
        try! realm.write {
            theItem?.item = description
        }
    }
    
    func updateStatus(_ item: MyItem, _ status : Int) {
        let theItem = realm.objects(MyItem.self).filter("item == %@", item.item ).first
        
         try! realm.write {
             theItem?.status = status
         }
    }
}
