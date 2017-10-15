//  Copyright © 2017 Tyler Yang. All rights reserved.

import UIKit

extension Date {
  var weekdayName: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E"
    return dateFormatter.string(from: self)
  }
}

extension UIColor {
  static func color(forWeatherIcon icon:String) -> UIColor {
    switch icon {
    case "snow":
      return #colorLiteral(red: 0.8332619071, green: 0.8075989485, blue: 0.7414989471, alpha: 1)
    case "clear-day":
      return #colorLiteral(red: 0.8868777156, green: 0.7314406633, blue: 0, alpha: 1)
    case "rain":
      return #colorLiteral(red: 0.7368612885, green: 0.7217479348, blue: 0.6772400737, alpha: 1)
    default:
      return #colorLiteral(red: 0.09358332306, green: 0.6048552394, blue: 0.7491628528, alpha: 1)
    }
  }
}
