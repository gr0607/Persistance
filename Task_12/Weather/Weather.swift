import Foundation
import RealmSwift

class Weather: Object{

    @objc dynamic var desc: String = ""
    @objc dynamic var windSpeed : Double = 0.0
    @objc dynamic var temperature: Double = 0
    @objc dynamic var date: NSDate = NSDate()
    
    init(description: String, windSpeed: Double, temperature: Double, date: Double) {
        self.desc = description
        self.windSpeed = windSpeed
        self.temperature = temperature
        self.date = NSDate(timeIntervalSince1970: date)
    }
    
        required init() {
           desc = ""
           windSpeed  = 0
           temperature = 0
           date = NSDate()
    }
}

