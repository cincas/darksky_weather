//  Copyright © 2017 Tyler Yang. All rights reserved.

import Foundation
import Result

struct Location {
  let latitude: Double
  let longitude: Double
}

class ForecastViewModel {
  private(set) var model: Forecast?
  fileprivate let apiClient: DarkSkyAPIClient
  fileprivate let location: Location
  
  var numberOfItemsInRow = 1
  init(location: Location, apiClient: DarkSkyAPIClient) {
    self.location = location
    self.apiClient = apiClient
  }
}

extension ForecastViewModel {
  func load(_ completionHandler: @escaping (Result<Forecast, APIError>) -> Void) {
    apiClient.fetchForecastWith(latitude: location.latitude,
                                longitude: location.longitude) { [weak self] result in
      guard let sself = self else {
        completionHandler(.failure(.unknown))
        return
      }
      
      defer {
        completionHandler(result)
      }
      
      switch result {
      case let .success(forecast):
        sself.model = forecast
        break
      case let .failure(error):
        print(error)
        break
      }
    }
  }
}

extension ForecastViewModel {
  func numberOfForecastDays() -> Int {
    return model?.daily.weatherList.count ?? 0
  }
  
  func weather(at indexPath: IndexPath) -> Weather? {
    return model?.daily.weatherList[indexPath.item]
  }
  
  func detailViewController(for weather: Weather) -> UIViewController {
    let title = "\(weather.time.weekdayName.uppercased()) forecast"
    let message = """
    Summary: \(weather.summary)
    Status: \(weather.icon)
    High: \(weather.apparentTemperatureHigh) @ \(Calendar.current.component(.hour, from: weather.apparentTemperatureHighTime))
    Low: \(weather.apparentTemperatureLow) @ \(Calendar.current.component(.hour, from: weather.apparentTemperatureLowTime))
"""
    let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let cancleAction = UIAlertAction(title: "OK", style: .default) { _ in }
    alertViewController.addAction(cancleAction)
    return alertViewController
  }
  
}
