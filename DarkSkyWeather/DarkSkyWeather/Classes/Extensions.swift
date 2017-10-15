//  Copyright © 2017 Tyler Yang. All rights reserved.

import Foundation

extension Date {
  var weekdayName: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "E"
    return dateFormatter.string(from: self)
  }
}
