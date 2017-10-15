//  Copyright © 2017 Tyler Yang. All rights reserved.

import XCTest
@testable import DarkSkyWeather
import Result

class DarkSkyWeatherTests: XCTestCase {
  override func setUp() {
    super.setUp()
    
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testViewModelLoad() {
    let location = Location(latitude: 1.0, longitude: 1.0)
    let expectation = self.expectation(description: "API client fetchForecastWith: function should be called")
    let apiClient = MockAPIClient()
    let viewModel = ForecastViewModel(location: location, apiClient: apiClient)
    viewModel.load { result in
      switch result {
      case .success(_):
        expectation.fulfill()
        break
      case .failure(_):
        XCTFail()
      }
    }
    
    wait(for: [expectation], timeout: 1.0)
  }
}

class MockAPIClient: DarkSkyAPIClient {
  func fetchForecastWith(latitude: Double, longitude: Double,
                         completionHandler: @escaping (Result<Forecast, APIError>) -> Void) {
    guard let sampleData = loadSampleData() else {
      completionHandler(.failure(.unknown))
      return
    }
    
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    guard let forecast = try? decoder.decode(Forecast.self, from: sampleData) else {
      completionHandler(.failure(.unknown))
      return
    }
    
    completionHandler(.success(forecast))

  }
  
  private func loadSampleData() -> Data? {
    let bundle = Bundle(for: type(of: self))
    
    guard let path = bundle.url(forResource: "sample_api_response", withExtension: "json") else {
      return nil
    }
    let string = try? String(contentsOf: path, encoding: .utf8)
    return string?.data(using: .utf8)
  }
}


