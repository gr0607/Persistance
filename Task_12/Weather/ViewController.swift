//
//  ViewController.swift
//  Task_12
//
//  Created by Admin on 23/05/2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var weathers : [Weather] = []
  
    
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WeatherLoader().loadWeather() { weathers in
            self.weathers = weathers
                        
            let todayWeather = weathers[0]
            
            self.mainLabel.text = todayWeather.desc
            self.temperatureLabel.text = "Temperature is \(todayWeather.temperature)с"
            self.windSpeedLabel.text = "WindSpeed is \(todayWeather.windSpeed)m/s"
    }
  }
}


