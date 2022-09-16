// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

import SwiftUI
import Combine
import Logging

enum FerryPorts: String, CaseIterable {
  case tsawwassen = "tsawwassen"
  case swartzBay = "swartz bay"
  case southernGulfIslands = "southern gulf islands"
  case dukePoint = "duke point"
  case fulfordHarbour = "fulford harbour"
  case horseshoeBay = "horseshoe bay"
  case departureBay = "departure bay"
  case langdale = "langdale"
  case snugCove = "snug cove"
}

enum DataError: Error {
  case invalidDecode, invalidData
}

extension FerryView {
  class FerryViewModel: ObservableObject {
    let logger = Logger(label: "FerryView+")
  
    @Published private(set) var feed: Feed?
    
    @AppStorage(StorageName.mode.rawValue)
    var mode: String?
        
    internal init() {
      updateData()
      let _ = Timer.scheduledTimer(withTimeInterval: 60.0 * 10, repeats: true) { timer in
        self.updateData()
      }
    }
        
    func changeMode() {
      mode = nil
    }

    func sailings(for originPort: String) -> [[Sailing]] {

      var sailings = [[Sailing]]()

      guard let schedule = feed?.schedule else { return sailings }
      
      switch originPort {
      case FerryPorts.tsawwassen.rawValue:
        var sailing = schedule.tsa.swb.sailings
        sailing[0].vesselName = FerryPorts.tsawwassen.rawValue
        sailing[0].vesselStatus = FerryPorts.swartzBay.rawValue
        sailings.append(sailing)
        sailing = schedule.tsa.sgi.sailings
        sailing[0].vesselName = FerryPorts.tsawwassen.rawValue
        sailing[0].vesselStatus = FerryPorts.southernGulfIslands.rawValue
        sailings.append(sailing)
        sailing = schedule.tsa.duk.sailings
        sailing[0].vesselName = FerryPorts.tsawwassen.rawValue
        sailing[0].vesselStatus = FerryPorts.dukePoint.rawValue
        sailings.append(sailing)
      case FerryPorts.horseshoeBay.rawValue:
        var sailing = schedule.hsb.nan.sailings
        sailing[0].vesselName = FerryPorts.horseshoeBay.rawValue
        sailing[0].vesselStatus = FerryPorts.departureBay.rawValue
        sailings.append(sailing)
        sailing = schedule.hsb.lng.sailings
        sailing[0].vesselName = FerryPorts.horseshoeBay.rawValue
        sailing[0].vesselStatus = FerryPorts.langdale.rawValue
        sailings.append(sailing)
        sailing = schedule.hsb.bow.sailings
        sailing[0].vesselName = FerryPorts.horseshoeBay.rawValue
        sailing[0].vesselStatus = FerryPorts.snugCove.rawValue
        sailings.append(sailing)
      case FerryPorts.swartzBay.rawValue:
        var sailing = schedule.swb.tsa.sailings
        sailing[0].vesselName = FerryPorts.swartzBay.rawValue
        sailing[0].vesselStatus = FerryPorts.tsawwassen.rawValue
        sailings.append(sailing)
        sailing = schedule.swb.ful.sailings
        sailing[0].vesselName = FerryPorts.swartzBay.rawValue
        sailing[0].vesselStatus = FerryPorts.fulfordHarbour.rawValue
        sailings.append(sailing)
        sailing = schedule.swb.sgi.sailings
        sailing[0].vesselName = FerryPorts.swartzBay.rawValue
        sailing[0].vesselStatus = FerryPorts.southernGulfIslands.rawValue
        sailings.append(sailing)
      case FerryPorts.departureBay.rawValue:
        var sailing = schedule.duk.tsa.sailings
        sailing[0].vesselName = FerryPorts.departureBay.rawValue
        sailing[0].vesselStatus = FerryPorts.horseshoeBay.rawValue
        sailings.append(sailing)
      case FerryPorts.dukePoint.rawValue:
        var sailing = schedule.duk.tsa.sailings
        sailing[0].vesselName = FerryPorts.dukePoint.rawValue
        sailing[0].vesselStatus = FerryPorts.tsawwassen.rawValue
        sailings.append(sailing)
      case FerryPorts.langdale.rawValue:
        var sailing = schedule.duk.tsa.sailings
        sailing[0].vesselName = FerryPorts.langdale.rawValue
        sailing[0].vesselStatus = FerryPorts.horseshoeBay.rawValue
        sailings.append(sailing)
      default:
        break
      }
      
      return sailings
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
