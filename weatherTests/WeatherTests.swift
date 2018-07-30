//
//  weatherTests.swift
//  weatherTests
//
//  Created by Sellin Gauthier on 20/07/2018.
//  Copyright © 2018 Sellin Gauthier. All rights reserved.
//

import XCTest
import PromiseKit
@testable import weather

class WeatherTests: XCTestCase {
    
    func testWeatherApi() {
        let weatherApi = WeatherApi()
        
        let expectationEnd = expectation(description: "End of getWeather")
        
        weatherApi.getWeather(0)
            .then { weather -> Void in
                XCTAssertEqual(weather.list.count, 40)
                
                expectationEnd.fulfill()
        }
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}
