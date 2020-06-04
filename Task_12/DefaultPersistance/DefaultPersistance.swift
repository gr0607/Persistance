
import Foundation

class DefaultPersistance {
    static let shared = DefaultPersistance()
    
    private let kUserNameKey = "DefaultPersistance.kUserNameKey"
    
    var name: String? {
        set {UserDefaults.standard.set(newValue, forKey: kUserNameKey)}
        get {UserDefaults.standard.string(forKey: kUserNameKey)}
    }
    
    var secondName: String? {
        set {UserDefaults.standard.set(newValue, forKey: kUserNameKey)}
        get {UserDefaults.standard.string(forKey: kUserNameKey)}
    }
}
