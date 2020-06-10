import UIKit
import CoreData

class CoreDataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
  
    @IBOutlet var myTableView: UITableView!
    
    var items = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TODO"
       
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel!.text = item.value(forKey: "desc") as? String
        
        let status = item.value(forKey: "status") as? Int
        var strStatus = ""
        switch status {
        case 0:
            strStatus = "status: not started"
            cell.backgroundColor = .lightGray
        case 1:
            strStatus = "status: in progress"
            cell.backgroundColor = .yellow
        case 2:
            strStatus = "status: done"
            cell.backgroundColor = .green
        default:
            break
        }
        cell.detailTextLabel?.text = strStatus
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Options", message: "Chose", preferredStyle: .alert)
                 
                 let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action: UIAlertAction!) -> Void in
                     
                    self.items.remove(at: indexPath.row)
                    self.myTableView.deleteRows(at: [indexPath], with: .automatic)
                    self.myTableView.reloadData()
                 }
               
               //create alert controller for edit item
               let editAction = UIAlertAction(title: "Edit", style: .default) {
                   (action: UIAlertAction!) -> Void in
                   
                   let alertEdit = UIAlertController(title: "Input new item", message: nil, preferredStyle: .alert)
                   
                   alertEdit.addTextField { (textField) in
                   }
                  
                   let okAction = UIAlertAction(title: "OK", style: .default) {
                       (action: UIAlertAction!) -> Void in
                       let item = self.items[indexPath.row]
                       let textField = alertEdit.textFields![0]
                       self.updateData(description: item.value(forKey: "desc") as! String, newDescription: textField.text!)
                       
                       tableView.reloadData()
                   }
                   
                   let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) -> Void in
                   }
                   alertEdit.addAction(okAction)
                   alertEdit.addAction(cancelAction)
                   self.present(alertEdit,animated: true, completion: nil)
               }
               
              //create alert controller for change status
               let statusAction = UIAlertAction(title: "Status" , style:  .default) {
                   (action: UIAlertAction!) -> Void in
                   
                    let alertStatus = UIAlertController(title: "Choose status", message: nil, preferredStyle: .alert)
                   
                   let notStartedAction = UIAlertAction(title: "Not started", style: .default) { (action: UIAlertAction!) -> Void in
                   
                    let item = self.items[indexPath.row]
                    self.updateStatus(description: item.value(forKey: "desc") as! String, status: 0)
                       tableView.reloadData()
                   }
                   let inProgressAction = UIAlertAction(title: "In progress", style: .default) { (action: UIAlertAction!) -> Void in
                    let item = self.items[indexPath.row]
                       self.updateStatus(description: item.value(forKey: "desc") as! String, status: 1)
                       tableView.reloadData()
                       tableView.reloadData()
                   }
                   let doneAction = UIAlertAction(title: "Done", style: .default) { (action: UIAlertAction!) -> Void in
                    let item = self.items[indexPath.row]
                      self.updateStatus(description: item.value(forKey: "desc") as! String, status: 2)
                      tableView.reloadData()
                       tableView.reloadData()
                   }
                   
                   alertStatus.addAction(notStartedAction)
                   alertStatus.addAction(inProgressAction)
                   alertStatus.addAction(doneAction)
                   
                   self.present(alertStatus, animated: true, completion: nil)
               }
               
                 let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) -> Void in
                  }
               
                  alert.addAction(deleteAction)
                  alert.addAction(editAction)
                  alert.addAction(statusAction)
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
    
    func updateData(description: String, newDescription: String) {
           guard  let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
           
           let managedContext = appDelegate.persistentContainer.viewContext
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
           fetchRequest.predicate = NSPredicate(format: "desc = %@", description)
           
           do {
               let test = try managedContext.fetch(fetchRequest)
               let objectToUpdate = test[0] as! NSManagedObject
               objectToUpdate.setValue(newDescription, forKey: "desc")
               
               do {
                   try managedContext.save()
               } catch {
                   print(error)
               }
           } catch {
               print(error)
           }
       }
    
    func updateStatus(description: String, status: Int) {
        guard  let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        fetchRequest.predicate = NSPredicate(format: "desc = %@", description)
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            let objectToUpdate = test[0] as! NSManagedObject
            objectToUpdate.setValue(status, forKey: "status")
            
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

