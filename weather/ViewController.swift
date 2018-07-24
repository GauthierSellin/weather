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
        
        let iconUrl = URL(string: "https://openweathermap.org/img/w/\(weatherElement.weather.first?.icon ?? "").png")
        
        cell.dateLabel.text = weatherElement.date
        cell.temperatureLabel.text = "\(Int(weatherElement.main.temperature))°C"
        cell.descriptionLabel.text = weatherElement.weather.first?.description
        cell.iconImageView.af_setImage(withURL: iconUrl!)
        
        return cell
    }
    
}
