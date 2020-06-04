

import UIKit

class ToDoViewController: UIViewController
{

    @IBOutlet var userInputTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RealmPersistance.shared.getItems()
    }
    @IBAction func addTask(_ sender: Any) {
        let str = userInputTextField.text ?? "Empty value"
        RealmPersistance.shared.addItem(str)
    }
    
   
    
}
