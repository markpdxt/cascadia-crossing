// Copyright (c) 2024 PDX Technologies, LLC. All rights reserved.

import SwiftUI

@main
struct CascadiaCrossingApp: App {
  var body: some Scene {
    WindowGroup {
      BorderView()
    }
  }
}

func openMap(coordinates: CoordinatesTuple) {
  let url = URL(string: "maps://?ll=\(coordinates.lat),\(coordinates.lng)")!
  if UIApplication.shared.canOpenURL(url) {
    UIApplication.shared.open(url)
  }
}
