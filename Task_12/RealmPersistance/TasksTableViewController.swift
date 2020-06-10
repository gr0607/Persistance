

import UIKit

class TasksTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RealmPersistance.shared.myItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)

        cell.textLabel?.text = RealmPersistance.shared.myItems[indexPath.row].item
        
        let status = RealmPersistance.shared.myItems[indexPath.row].status
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Create main alert controller
        let alert = UIAlertController(title: "Options", message: "Chose", preferredStyle: .alert)
          
          let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action: UIAlertAction!) -> Void in
              
              let item = RealmPersistance.shared.myItems[indexPath.row]
              RealmPersistance.shared.removeItem(item)
              RealmPersistance.shared.myItems.remove(at: indexPath.row)
              tableView.deleteRows(at: [indexPath], with: .automatic)
          }
        
        //create alert controller for edit item
        let editAction = UIAlertAction(title: "Edit", style: .default) {
            (action: UIAlertAction!) -> Void in
            
            let alertEdit = UIAlertController(title: "Input new item", message: nil, preferredStyle: .alert)
            
            alertEdit.addTextField { (textField) in
            }
           
            let okAction = UIAlertAction(title: "OK", style: .default) {
                (action: UIAlertAction!) -> Void in
                let textField = alertEdit.textFields![0]
                let item = RealmPersistance.shared.myItems[indexPath.row]
                
                RealmPersistance.shared.updateItem(item, textField.text!)
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
                let item = RealmPersistance.shared.myItems[indexPath.row]
                RealmPersistance.shared.updateStatus(item, 0)
                tableView.reloadData()
            }
            let inProgressAction = UIAlertAction(title: "In progress", style: .default) { (action: UIAlertAction!) -> Void in
                let item = RealmPersistance.shared.myItems[indexPath.row]
                RealmPersistance.shared.updateStatus(item, 1)
                tableView.reloadData()
            }
            let doneAction = UIAlertAction(title: "Done", style: .default) { (action: UIAlertAction!) -> Void in
                let item = RealmPersistance.shared.myItems[indexPath.row]
                RealmPersistance.shared.updateStatus(item, 2)
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
}
