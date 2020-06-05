import Foundation
import Alamofire
import SwiftyJSON

class WeatherLoader{
       
    func loadWeather(completion: @escaping ([Weather]) -> Void){
        let url = URL(string: Constants.weatherURL)!
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, repsonse, error in
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                let jsonDict = json as? NSDictionary{
                DispatchQueue.main.async {
                   
                    var weathers : [Weather] = []
                    
                   
                if let current = jsonDict["current"] as? NSDictionary {
                    let temp = current["temp"]
                    let windSpeed = current["wind_speed"]
                    
                    let weather = current["weather"] as? NSArray
                    let value = weather![0] as? NSDictionary
                    let description = value!["main"]
                    
                    let date = current["dt"]
                    
                    weathers.append(Weather(description: description as! String, windSpeed: windSpeed as! Double, temperature: temp as! Double, date: date as! Double ))
                }
               
              let sevenDays = jsonDict["daily"] as? NSArray
                for element in sevenDays!  {
                    if let jsonEl = element as? NSDictionary {
                        let windSpeed = jsonEl["wind_speed"]
                        
                        let weather = jsonEl["weather"] as? NSArray
                        let value = weather![0] as? NSDictionary
                        let description = value!["main"]
                        
                        let temp = jsonEl["temp"] as? NSDictionary
                        let myTemp = temp?["day"]
                        
                        let date = jsonEl["dt"]
                        
                        weathers.append(Weather(description: description as! String, windSpeed: windSpeed as! Double, temperature: myTemp as! Double, date: date as! Double))
                        
                    }
                   
                }
                completion(weathers)
              
            }
            }
        }
        task.resume()
    }
    
    func loadWeatherWithAlamo(completion: @escaping ([Weather]) -> Void){
        print("hhhh")
        var jsonWeather: JSON? = nil
       DispatchQueue.main.async {
        AF.request(Constants.weatherURL, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                jsonWeather = JSON(value)

                var weathers : [Weather] = []
                   
                print("alamo")
                let windSpedd = jsonWeather!["current"]["wind_speed"].double
                let date = jsonWeather!["current"]["dt"].double
                let temperature = jsonWeather!["current"]["temp"].double
                let mainWeather = jsonWeather!["current"]["weather"][0]["main"].string
                
                weathers.append(Weather(description: mainWeather! , windSpeed: Double(windSpedd!) , temperature: Double(temperature!), date: Double(date!)))
               
              
                for (_,subJson):(String, JSON) in jsonWeather!["daily"] {
                   let windSpedd = subJson["wind_speed"].double
                   let date = subJson["dt"].double
                   let temperature = subJson["temp"]["day"].double
                   let mainWeather = subJson["weather"][0]["main"].string
                   
                   weathers.append(Weather(description: mainWeather! , windSpeed: Double(windSpedd!) , temperature: Double(temperature!), date: Double(date!)))
                }
                
                print(weathers.count)
                completion(weathers)
          
            case .failure(let error):
                print(error)
            }
        }
  }
}
}



