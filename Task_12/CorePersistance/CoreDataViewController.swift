import UIKit
import CoreData

class CoreDataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
  
    @IBOutlet var myTableView: UITableView!
    
    var items = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ITEMS"
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
  
        getData()
    }

   
    @IBAction func addItem(_ sender: Any) {
        let alert = UIAlertController(title: "New item", message: "Add new item", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action: UIAlertAction!) -> Void in
            
            let textField = alert.textFields![0]
            self.create(description: textField.text!)
            self.myTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) -> Void in
         }
        
        alert.addTextField { (textField) in
        }

         alert.addAction(saveAction)
         alert.addAction(cancelAction)
        
         present(alert,animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let item = items[indexPath.row]
        cell.textLabel!.text = item.value(forKey: "desc") as? String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete", message: "Delete this?", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Delete", style: .default) { (action: UIAlertAction!) -> Void in
            
            self.items.remove(at: indexPath.row)
            self.myTableView.deleteRows(at: [indexPath], with: .automatic)
            self.myTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) -> Void in
         }
      

         alert.addAction(saveAction)
         alert.addAction(cancelAction)
        
         present(alert,animated: true, completion: nil)
    }
    
   
    func create(description: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let itemEntity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext)
        
        
            let item = NSManagedObject(entity: itemEntity!, insertInto: managedContext)
            item.setValue(description, forKey: "desc")
        self.items.append(item)
       
        
        do {
            try managedContext.save()
        } catch let _ as NSError {
            print("I don't know what i do")
        }
    }
    
    func getData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else
        { return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                items.append(data)
            }
        } catch {
            print ("Failed")
        }
    }
    
    func deleteData(description: String) {
        guard  let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        fetchRequest.predicate = NSPredicate(format: "desc = %@", description)
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
}

