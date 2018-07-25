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
    
    private let weatherUrl = "https://api.openweathermap.org/data/2.5/forecast?id=6455259&appid=191fd4d1087569b2e5ac9e98043e8402&lang=fr&units=metric"
    
    public func getWeather() -> Promise<WeatherForecast> {
        return Promise<WeatherForecast> { fulfill, reject in
            
            // Performing an Alamofire request to get the data from the URL
            Alamofire.request(self.weatherUrl).responseJSON { response in
                switch response.result {
                case .success:
                    // the response data to parse
                    if let json = response.data {
                        do {
                            let decoder = JSONDecoder()
                            
                            let myStruct = try decoder.decode(WeatherForecast.self, from: json)
                            print(myStruct)
                            fulfill(myStruct)
                        } catch let err {
                            reject(err)
                        }
                    } else {
                        print("Erreur : pas de données")
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }
}
