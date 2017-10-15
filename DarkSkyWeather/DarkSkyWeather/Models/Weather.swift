//  Copyright © 2017 Tyler Yang. All rights reserved.

import Foundation

struct Forecast: Decodable {
  let latitude: Float
  let longitude: Float
  let daily: DailyForecast
}

struct DailyForecast: Decodable {
  let summary: String
  let icon: String
  let weathers: [Weather]
  enum CodingKeys: String, CodingKey {
    case summary
    case icon
    case weathers = "data"
  }
}

struct Weather: Decodable {
  let time: Date
  let summary: String
  let icon: String
  let temperatureHigh: Float
  let temperatureHighTime: Date
  let temperatureLow: Float
  let temperatureLowTime: Date
  let apparentTemperatureHigh: Float
  let apparentTemperatureHighTime: Date
  let apparentTemperatureLow: Float
  let apparentTemperatureLowTime: Date
}
