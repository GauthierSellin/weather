//
//  ViewController.swift
//  weather
//
//  Created by Sellin Gauthier on 20/07/2018.
//  Copyright © 2018 Sellin Gauthier. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
}

class ViewController: UIViewController {
    
    let weatherApi = WeatherApi()
    var weather = WeatherForecast()
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        
        refreshWeather()
    }
    
    private func refreshWeather() {
        activityIndicator.startAnimating()
        
        weatherApi.getWeather()
            .then { [weak self] weather -> Void in
                self?.weather = weather
                self?.weatherTableView.reloadData()
            }.catch { error in
                print(error.localizedDescription)
            }.always {
                self.activityIndicator.stopAnimating()
        }
    }
    
    private func getDate(date dateString: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EEEE dd MMMM HH:mm"
        dateFormatterPrint.locale = Locale(identifier: "fr_FR")
        
        if let date = dateFormatterGet.date(from: dateString) {
            return dateFormatterPrint.string(from: date)
        } else {
            print("There was an error decoding the string")
        }
        return dateString
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
        return weather.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherTableViewCell else {
            fatalError("Cell type is not supported.")
        }
        
        guard indexPath.row < weather.list.count else {
            fatalError("Index of bound when getting weather.")
        }
        
        let weatherElement = weather.list[indexPath.row]
        
        cell.dateLabel.text = getDate(date: weatherElement.date)
        cell.temperatureLabel.text = "\(Int(weatherElement.main.temperature))°C"
        
        if let mainDescript = weatherElement.weather.first?.mainDescription, let descript = weatherElement.weather.first?.description {
            cell.descriptionLabel.text = mainDescript + " : " + descript
        } else {
            print("Description indisponible")
        }
        
        if let iconUrl = URL(string: "https://openweathermap.org/img/w/\(weatherElement.weather.first?.icon ?? "").png") {
            cell.iconImageView.af_setImage(withURL: iconUrl)
        } else {
            print("Icône indisponible")
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Meteo"
    }
    
}
