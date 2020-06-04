

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

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .normal, title: "Delete") { action, view, completionHandler in
            let item = RealmPersistance.shared.myItems[indexPath.row]
            RealmPersistance.shared.removeItem(item)
            RealmPersistance.shared.myItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
              
            completionHandler(true)
        }

        delete.backgroundColor = UIColor.red

        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}
