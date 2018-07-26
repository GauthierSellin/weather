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
    
    private let baseUrl = "https://api.openweathermap.org/data/2.5/"
    private let forecasteUrl = "forecast"
    private let cityId = "?id=6455259"
    private let appId = "&appid=191fd4d1087569b2e5ac9e98043e8402"
    private let params = "&lang=fr&units=metric"
    
    public func getWeather() -> Promise<WeatherForecast> {
        return Promise<WeatherForecast> { fulfill, reject in
            guard let weatherUrl = URL(string: baseUrl + forecasteUrl + cityId + appId + params) else {
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
                            print("invalide json")
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
