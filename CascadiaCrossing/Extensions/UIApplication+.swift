// Copyright (c) 2024 PDX Technologies, LLC. All rights reserved.

import SwiftUI

extension UIApplication {
  static var appVersion: String? {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
  }
}
