
import UIKit

class WeatherTableViewController: UIViewController {

    @IBOutlet weak var weatherData: UITableView!
    var weathers : [Weather] = []
    
    let dateFormatter = DateFormatter()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if let weathersR = WeatherPersistance.shared.getWeather() {
            
            self.weathers = weathersR
            print(weathers[0])
            self.weatherData.reloadData()
        }
          WeatherLoader().loadWeatherWithAlamo() { weathers in
                  self.weathers = weathers
                  self.weatherData.reloadData()
            WeatherPersistance.shared.removeWeather()
            WeatherPersistance.shared.saveWeather(weathers: weathers)
          }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension WeatherTableViewController: UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return weathers.count - 2
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherSimpleCell", for: indexPath) as! WeatherSimpleCell
           let weather = weathers[indexPath.row + 2]
        
           dateFormatter.dateFormat = "dd-MM-yyyy"
           let stringDate: String = dateFormatter.string(from: weather.date as Date)
        
           cell.dateLabel.text = stringDate
           cell.mainLabel.text = weather.desc
           cell.windSpeedLabel.text = "WindSpeed is \(weather.windSpeed) m/s"
           cell.temperatureLabel.text = "Temperature is \(weather.temperature) c"
           return cell
       }
}
