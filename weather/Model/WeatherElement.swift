//
//  WeatherElement.swift
//  weather
//
//  Created by Sellin Gauthier on 22/07/2018.
//  Copyright © 2018 Sellin Gauthier. All rights reserved.
//

import Foundation

struct WeatherElement {
    public let date: String
    public let temperature: Double
    public let description: String
    public let icon: String

    init(_ date: String, _ temperature: Double, _ description: String, _ icon: String) {
        self.date = date
        self.temperature = temperature
        self.description = description
        self.icon = icon
    }
}
