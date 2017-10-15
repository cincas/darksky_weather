//  Copyright © 2017 Tyler Yang. All rights reserved.

import Foundation
import Result

enum APIError: Error {
  case malformedEndpoint, network(Error)
  case unknown
}

struct DarkSkyAPIClient {
  let domain: String
  let apiKey: String
  let session: URLSession
  
  init(apiKey: String,
       domain: String = "https://api.darksky.net/",
       session: URLSession = URLSession.shared) {
    self.domain = domain
    self.apiKey = apiKey
    self.session = session
  }
  
  func fetchForecastWith(latitude: Double, longitude: Double,
                         completionHandler: @escaping (Result<Forecast, APIError>) -> Void) {
    guard let urlRequest = urlRequestFor(path: "/forecast",
                                         latitude: latitude,
                                         longitude: longitude) else {
      completionHandler(.failure(.malformedEndpoint))
      return
    }
    
    let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
      if let error = error {
        completionHandler(.failure(.network(error)))
        return
      }
      
      guard let data = data else {
        completionHandler(.failure(.unknown))
        return
      }
      
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .secondsSince1970
      guard let weeklyForecast = try? decoder.decode(Forecast.self, from: data) else {
        completionHandler(.failure(.unknown))
        return
      }
      
      completionHandler(.success(weeklyForecast))
    }
    
    dataTask.resume()
  }
}

extension DarkSkyAPIClient {
  private func urlRequestFor(path: String, latitude: Double, longitude: Double) -> URLRequest? {
    var urlComponents = URLComponents(string: domain)
    guard let fullPath = [path, apiKey, "\(latitude),\(longitude)"].joined(separator: "/")
      .addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
        return nil
    }
    urlComponents?.path = fullPath
    guard let url = urlComponents?.url else { return nil }
    return URLRequest(url: url)
  }
}
