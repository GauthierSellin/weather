//
//  ViewController.swift
//  weather
//
//  Created by Sellin Gauthier on 20/07/2018.
//  Copyright © 2018 Sellin Gauthier. All rights reserved.
//

import UIKit
import Alamofire

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
}

class ViewController: UIViewController {
    
    let weatherApi = WeatherApi()
    var weather = [WeatherElement]()
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        
//        weatherApi.getWeather()
        
        print(weather)
        
        myFunction()
    }
    
//    private func refreshWeather() {
//        weatherApi.getWeather()
//    }

    func myFunction() {
        var a: Int?
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.main.async {
            a = 1
            group.leave()
        }
        
        // does not wait. But the code in notify() gets run
        // after enter() and leave() calls are balanced
        
        group.notify(queue: .main) {
            print(a ?? 0)
        }
    }


}


extension ViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension ViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherTableViewCell else {
            fatalError("Cell type is not supported.")
        }
        
        guard indexPath.row < weather.count else {
            fatalError("Index of bound when getting weather.")
        }
        
        let weatherElement = weather[indexPath.row]

        cell.dateLabel.text = weatherElement.date
        cell.temperatureLabel.text = "\(weatherElement.temperature)°C"
        cell.descriptionLabel.text = weatherElement.description
        // TODO : icon

        return cell
    }


}
