// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

import SwiftUI

@main
struct CascadiaCrossingApp: App {
  @AppStorage(StorageName.mode.rawValue) private var mode: String?

  var body: some Scene {
    WindowGroup {
      if mode == nil {
        BorderView()
      } else {
        FerryView()
      }
    }
  }
}

func openMap(coordinates: CoordinatesTuple) {
  let url = URL(string: "maps://?ll=\(coordinates.lat),\(coordinates.lng)")!
  if UIApplication.shared.canOpenURL(url) {
    UIApplication.shared.open(url)
  }
}
