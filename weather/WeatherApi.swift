//
//  WeatherApi.swift
//  weather
//
//  Created by Sellin Gauthier on 22/07/2018.
//  Copyright © 2018 Sellin Gauthier. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

public class WeatherApi {
    
    // URL to fetch data from OpenWeatherMap
    private let baseUrl = "https://api.openweathermap.org/data/2.5/"
    private let forecasteUrl = "forecast"
    private let cityId = "?id=6455259" // Paris ID
    private let appId = "&appid=191fd4d1087569b2e5ac9e98043e8402" // account ID
    private let paramLang = "&lang=fr" // language: french
    
    public enum Unit: String {
        case celsius = "metric"
        case fahrenheit = "imperial"
    }
    
    public func getWeather(_ unit: Int) -> Promise<WeatherForecast> {
        return Promise<WeatherForecast> { fulfill, reject in
            let paramUnit = (unit == 0) ? "&units=\(Unit.celsius.rawValue)" : "&units=\(Unit.fahrenheit.rawValue)"
            guard let weatherUrl = URL(string: baseUrl + forecasteUrl + cityId + appId + paramLang + paramUnit) else {
                reject(WeatherApi.ApiError.invalidUrl)
                return
            }
            
            // Performing an Alamofire request to get the data from the URL
            Alamofire.request(weatherUrl).responseJSON { response in
                switch response.result {
                case .success:
                    // the response data to parse
                    if let json = response.data {
                        do {
                            let decoder = JSONDecoder()
                            
                            let myStruct = try decoder.decode(WeatherForecast.self, from: json)
                            fulfill(myStruct)
                        } catch let err {
                            reject(err)
                        }
                    } else {
                        print("Erreur : pas de données")
                        reject(WeatherApi.ApiError.weatherNoData)
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
    
    enum ApiError: Error {
        case invalidUrl, weatherNoData
    }
}
