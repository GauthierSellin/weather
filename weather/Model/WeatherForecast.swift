//
//  WeatherForecast.swift
//  weather
//
//  Created by Sellin Gauthier on 20/07/2018.
//  Copyright © 2018 Sellin Gauthier. All rights reserved.
//

import Foundation

public struct WeatherForecast : Decodable {

    public struct List : Codable {

        public struct Main : Codable {
            public let temp : Double
        }

        public struct Weather : Codable {
            public let description : String
            public let icon : String
        }

        public let main : Main
        public let weather : [Weather]
        public let dt_txt : String
    }

    public let list : [List]

}
