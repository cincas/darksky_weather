//  Copyright © 2017 Tyler Yang. All rights reserved.

import Foundation
import Result

class ForecastViewModel {
  fileprivate let apiClient = DarkSkyAPIClient()
  var model: Forecast?
  let latitude = 33.8650
  let longitude = 151.2094
}

extension ForecastViewModel {
  func load(_ completionHandler: @escaping (Result<Forecast, APIError>) -> Void) {
    apiClient.fetchForecastWith(latitude: latitude, longitude: longitude) { [weak self] result in
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
    return model?.daily.weathers.count ?? 0
  }
  
  func weather(at indexPath: IndexPath) -> Weather? {
    return model?.daily.weathers[indexPath.item]
  }
}
