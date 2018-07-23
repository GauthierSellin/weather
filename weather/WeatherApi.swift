//
//  WeatherApi.swift
//  weather
//
//  Created by Sellin Gauthier on 22/07/2018.
//  Copyright © 2018 Sellin Gauthier. All rights reserved.
//

import Foundation
import Alamofire

public class WeatherApi {
    
    private let weatherUrl = "https://api.openweathermap.org/data/2.5/forecast?id=6455259&appid=59fdeafbfbd18388fcd1fdd097678330&lang=fr&units=metric"
    
    func getWeather() -> [WeatherElement] {
        
        var weather = [WeatherElement]()
        
        // Performing an Alamofire request to get the data from the URL
        Alamofire.request(self.weatherUrl).responseJSON { response in
            switch response.result {
            case .success:
                // the response data to parse
                let json = response.data
                do {
                    let decoder = JSONDecoder()
                    
                    let myStruct = try decoder.decode(WeatherForecast.self, from: json!)
                    
                    for item in myStruct.list {
                        let date = item.dt_txt
                        let temperature = (item.main.temp * 100).rounded() / 100
                        let description = item.weather.first?.description ?? ""
                        let icon = item.weather.first?.icon ?? ""
                        let weatherElement = WeatherElement(date, temperature, description, icon)
                        
                        weather.append(weatherElement)
                    }
                    print(weather)
                } catch let err {
                    print(err.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        print(weather)
        return weather
    }
    
}
