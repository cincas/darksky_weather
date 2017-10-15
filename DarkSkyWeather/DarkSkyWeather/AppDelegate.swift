//  Copyright © 2017 Tyler Yang. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    let viewModel = ForecastViewModel()
    let viewController = ViewController(viewModel: viewModel)
    let navigationViewController = UINavigationController(rootViewController: viewController)
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = navigationViewController
    window.makeKeyAndVisible()
    self.window = window
    return true
  }
}
