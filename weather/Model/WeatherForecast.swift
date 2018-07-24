//
//  WeatherForecast.swift
//  weather
//
//  Created by Sellin Gauthier on 20/07/2018.
//  Copyright © 2018 Sellin Gauthier. All rights reserved.
//

import Foundation

public struct WeatherForecast: Decodable {
    
    public let list: [List]

    public struct List: Codable {
        public let main: Main
        public let weather: [Weather]
        public let date: String
        
        enum CodingKeys: String, CodingKey {
            case main, weather, date = "dt_txt"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case list
    }
    
    public struct Main: Codable {
        public let temperature: Double
        
        enum CodingKeys: String, CodingKey {
            case temperature = "temp"
        }
    }
    
    public struct Weather: Codable {
        public let description: String
        public let icon: String
        
        enum CodingKeys: String, CodingKey {
            case description, icon
        }
    }

    public init() {
        self.list = []
    }
}
