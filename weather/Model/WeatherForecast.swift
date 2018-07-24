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
        // swiftlint:disable all
        public let dt_txt: String
        // swiftlint:enable all
    }
    
    public struct Main: Codable {
        public let temp: Double
    }
    
    public struct Weather: Codable {
        public let description: String
        public let icon: String
    }

    public init() {
        self.list = []
    }
}
