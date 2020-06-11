import Foundation
import RealmSwift

class WeatherPersistance {
    static let shared = WeatherPersistance()
    
    private let realm = try! Realm()
    
  
    
    func getWeather() -> [Weather]? {
        var realmWeather = [Weather]()
        
        let weathers = realm.objects(Weather.self)
        for weather in weathers {
            realmWeather.append(weather)
        }
        
        return realmWeather
    }
    
    func saveWeather(weathers: [Weather]) {
        try! realm.write {
            for w in weathers {
            realm.add(w)
            }
        }
    }
    
    func removeWeather(){
        try! realm.write {
                    realm.deleteAll()
        }
    }
}
