//  Copyright © 2017 Tyler Yang. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    let apiClient = DarkSkyAPIClient(apiKey: "7ac63069af3f8767de3e8767d8151025")
    let location = Location(latitude: 33.8650, longitude: 151.2094)
    let viewModel = ForecastViewModel(location: location, apiClient: apiClient)
    let viewController = ViewController(viewModel: viewModel)
    
    let navigationViewController = UINavigationController(rootViewController: viewController)
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = navigationViewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}
