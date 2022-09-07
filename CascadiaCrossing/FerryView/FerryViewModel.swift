// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

import SwiftUI
import Combine
import Logging

extension FerryView {
  class FerryViewModel: ObservableObject {
    let logger = Logger(label: "FerryView+")

    var anyCancellables = Set<AnyCancellable>()
  
    @Published private(set) var feed: Feed? {
      didSet {
        logger.info("Feed updated")
      }
    }
    
    internal init() {
      updateData()
      let _ = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { timer in
        self.updateData()
      }
    }
      
    private func updateData() {
      if let url = URL(string: SourceURLs.ferryTime.rawValue) {
        if let data = try? Data(contentsOf: url) {
          let decoder = JSONDecoder()
          if let feed = try? decoder.decode(Feed.self, from: data) {
            self.feed = feed
          }
        }
      }
    }
    
  }
}
