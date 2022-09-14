// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

import SwiftUI
import Combine
import Logging

extension FerryView {

  enum DataError: Error {
    case invalidDecode, invalidData
  }

  class FerryViewModel: ObservableObject {
    let logger = Logger(label: "FerryView+")
  
    @Published private(set) var feed: Feed? {
      didSet {
        logger.info("Feed updated \(String(describing: feed?.schedule.tsa.swb.sailings))")
      }
    }
    
    @AppStorage(StorageName.mode.rawValue) var mode: String? {
      willSet {
        if mode != newValue {
          objectWillChange.send()
          logger.info("mode changed: \(String(describing: mode))")
        }
      }
    }
    
    internal init() {
      updateData()
      let _ = Timer.scheduledTimer(withTimeInterval: 60.0 * 10, repeats: true) { timer in
        self.updateData()
      }
    }
        
    func changeMode() {
      mode = nil
    }
    
    private func updateData() {
      Task {
        do {
          let data = try await fetchData()
          let feed = try await decodeData(data: data)
          DispatchQueue.main.async { self.feed = feed }
        } catch {
          logger.error("updateData: \(error)")
        }
      }
    }
  
    private func fetchData(urlString: String = SourceURLs.ferryTime.rawValue) async throws -> Data {
      guard let url = URL(string: urlString),
            let data = try? Data(contentsOf: url) else {
        throw DataError.invalidData
      }

      return data
    }
    
    private func decodeData(data: Data) async throws -> Feed {
      let decoder = JSONDecoder()
      guard let feed = try? decoder.decode(Feed.self, from: data) else {
        throw DataError.invalidDecode
      }

      return feed
    }
    
  }
}
