// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

import SwiftUI

@main
struct CascadiaCrossingApp: App {
  var body: some Scene {
    WindowGroup {
      FerryView()
    }
  }
}

func openMap(coordinates: CoordinatesTuple) {
  let url = URL(string: "maps://?ll=\(coordinates.lat),\(coordinates.lng)")!
  if UIApplication.shared.canOpenURL(url) {
    UIApplication.shared.open(url)
  }
}
