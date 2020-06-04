import Foundation
import RealmSwift

class WeatherPersistance {
    static let shared = WeatherPersistance()
    
    private let realm = try! Realm()
    
    var realmWeather = [Weather]()
    
    func getWeather() {
        let weathers = realm.objects(Weather.self)
        for weather in weathers {
            realmWeather.append(weather)
        }
    }
    
    func saveWeather(weathers: [Weather]) {
        try! realm.write {
            for w in weathers {
            realm.add(w)
            }
        }
    }
}
