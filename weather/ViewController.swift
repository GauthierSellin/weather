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
    
    fileprivate let weatherApi = WeatherApi()
    fileprivate var weather = WeatherForecast()
    
    fileprivate let dateFormatter = DateFormatter()
    
    // PullToRefresh mechanism
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        
        refreshControl.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.orange
        
        return refreshControl
    }()
    
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    // Switch temperature unit (°C or °F)
    @IBAction func indexChanged(_ sender: Any) {
        refreshWeather(unit: segmentedControl.selectedSegmentIndex)
        UserDefaults.standard.set(segmentedControl.selectedSegmentIndex, forKey: "userUnit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        
        self.dateFormatter.dateStyle = DateFormatter.Style.short
        self.dateFormatter.timeStyle = DateFormatter.Style.short
        
        segmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "userUnit")
        
        refreshWeather(unit: segmentedControl.selectedSegmentIndex)
        
        self.weatherTableView.addSubview(self.refreshControl)
    }
    
    fileprivate func refreshWeather(unit: Int) {
        let activityIndicator = CustomActivityIndicator(text: "Chargement")
        self.view.addSubview(activityIndicator)
        
        weatherApi.getWeather(unit)
            .then { [weak self] weather -> Void in
                self?.weather = weather
                
                // update pullToRefresh date
                let now = Date()
                let updateString = "Dernière MAJ : " + (self?.dateFormatter.string(from: now) ?? "")
                self?.refreshControl.attributedTitle = NSAttributedString(string: updateString)
                
                self?.weatherTableView.reloadData()
            }.catch { error in
                print(error.localizedDescription)
            }.always {
                activityIndicator.hide()
        }
    }
    
    @objc fileprivate func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshWeather(unit: segmentedControl.selectedSegmentIndex)
        
        refreshControl.endRefreshing()
    }
    
    fileprivate func getDate(date dateString: String) -> String {
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
        return 70
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherTableViewCell else {
            return UITableViewCell()
        }
        
        let weatherElement = weather.list[indexPath.row]
        
        cell.dateLabel.text = getDate(date: weatherElement.date)
        cell.temperatureLabel.text = "\(Int(weatherElement.main.temperature))°" + ((segmentedControl.selectedSegmentIndex == 0) ? "C" : "F")
        
        if let weatherDescription = weatherElement.weather.first?.description {
            cell.descriptionLabel.text = "- " + weatherDescription
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
    
}
