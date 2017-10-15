//  Copyright © 2017 Tyler Yang. All rights reserved.

import UIKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let apiClient = DarkSkyAPIClient()
    apiClient.fetchForecastWith(latitude: 33.8650, longitude: 151.2094) { result in
      print(result)
    }
  }
}
