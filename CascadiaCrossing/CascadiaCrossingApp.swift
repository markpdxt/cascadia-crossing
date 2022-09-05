// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

import SwiftUI

@main
struct CascadiaCrossingApp: App {
  var body: some Scene {
    WindowGroup {
      MetricsView()
    }
  }
}

extension UIApplication {
  static var appVersion: String? {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
  }
}
