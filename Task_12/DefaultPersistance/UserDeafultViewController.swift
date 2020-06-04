
import UIKit

class UserDeafultViewController: UIViewController {

    
    @IBOutlet var nameTextFiled: UITextField!
    @IBOutlet var secondNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let name = DefaultPersistance.shared.name,
           let secondName = DefaultPersistance.shared.secondName {
            nameTextFiled.text = name
            secondNameTextField.text = secondName
        }
       
    }
    
   
    @IBAction func updateValue(_ sender: Any) {
        DefaultPersistance.shared.name = nameTextFiled.text
        DefaultPersistance.shared.secondName = secondNameTextField.text
    }
    
}
