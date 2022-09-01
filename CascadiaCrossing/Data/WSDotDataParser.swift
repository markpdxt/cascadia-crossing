// Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.

import Foundation
import SwiftyXMLParser
import Logging

class WSDotDataParser {
  let logger = Logger(label: "WSDotDataParser+")

  let url = NSURL(string: "https://wsdot.wa.gov/Traffic/api/BorderCrossings/BorderCrossingsREST.svc/GetBorderCrossingsAsXml?AccessCode=4d681f27-a992-416c-8d02-410903ab6311")
    
  func fetch() -> [Crossing] {
    let sem = DispatchSemaphore.init(value: 0)

    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    
    var crossings = [Crossing]()
  
    var i5Crossing = Crossing()
    var sr539Crossing = Crossing()
    var sr543Crossing = Crossing()
    var sr9Crossing = Crossing()

    let task = URLSession.shared.dataTask(with: url! as URL) { (data, response, error) in
      defer { sem.signal() }

      if data != nil {
        let feed = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
        let xml = try! XML.parse(feed)

        let filteredCrossings = ["I5", "I5Nexus", "SR539", "SR539Nexus", "SR543", "SR543Nexus", "SR9", "SR9Nexus"]

        for BorderCrossingData in xml["ArrayOfBorderCrossingData"]["BorderCrossingData"] {
          
          guard filteredCrossings.contains(BorderCrossingData["CrossingName"].text ?? "") else {
            continue
          }
          
          let crossingName = BorderCrossingData["CrossingName"].text ?? ""
          let lanesDelay = Int(BorderCrossingData["WaitTime"].text ?? "") ?? 0
          var lanesUpdated = BorderCrossingData["Time"].text ?? ""
          
          let dateTime = dateFormatter.date(from: lanesUpdated)
          if let updatedFormated = dateTime?.formatted(.dateTime.hour().minute()) {
            lanesUpdated = updatedFormated
          }
          
          var hasData = true
          if BorderCrossingData["Time"].text == nil {
            hasData = false
          }
          
          var isClosed = false
          if lanesDelay < 0 {
            isClosed = true
          }
          
          if crossingName.localizedStandardContains("Nexus") {
            switch crossingName {
            case filteredCrossings[1]:
              i5Crossing.nexusSentriLanesDelay = lanesDelay
              i5Crossing.nexusSentriLanesUpdated = lanesUpdated
              i5Crossing.nexusSentriLanesIsClosed = isClosed
            case filteredCrossings[3]:
              sr539Crossing.nexusSentriLanesDelay = lanesDelay
              sr539Crossing.nexusSentriLanesUpdated = lanesUpdated
              sr539Crossing.nexusSentriLanesIsClosed = isClosed
            case filteredCrossings[5]:
              sr543Crossing.nexusSentriLanesDelay = lanesDelay
              sr543Crossing.nexusSentriLanesUpdated = lanesUpdated
              sr543Crossing.nexusSentriLanesIsClosed = isClosed
            case filteredCrossings[7]:
              sr9Crossing.nexusSentriLanesDelay = lanesDelay
              sr9Crossing.nexusSentriLanesUpdated = lanesUpdated
              sr9Crossing.nexusSentriLanesIsClosed = isClosed
            default:
              break
            }
          } else {
            switch crossingName {
            case filteredCrossings[0]:
              i5Crossing.hasData = hasData
              i5Crossing.crossingName = crossingName
              i5Crossing.stanadrdLanesDelay = lanesDelay
              i5Crossing.standardLanesUpdated = lanesUpdated
              i5Crossing.standardLanesIsClosed = isClosed
            case filteredCrossings[2]:
              sr539Crossing.hasData = hasData
              sr539Crossing.crossingName = crossingName
              sr539Crossing.stanadrdLanesDelay = lanesDelay
              sr539Crossing.standardLanesUpdated = lanesUpdated
              sr539Crossing.standardLanesIsClosed = isClosed
            case filteredCrossings[4]:
              sr543Crossing.hasData = hasData
              sr543Crossing.crossingName = crossingName
              sr543Crossing.stanadrdLanesDelay = lanesDelay
              sr543Crossing.standardLanesUpdated = lanesUpdated
              sr543Crossing.standardLanesIsClosed = isClosed
            case filteredCrossings[6]:
              sr9Crossing.hasData = hasData
              sr9Crossing.crossingName = crossingName
              sr9Crossing.stanadrdLanesDelay = lanesDelay
              sr9Crossing.standardLanesUpdated = lanesUpdated
              sr9Crossing.standardLanesIsClosed = isClosed
            default:
              break
            }
          }
        }
        
        crossings.append(i5Crossing)
        crossings.append(sr539Crossing)
        crossings.append(sr543Crossing)
        crossings.append(sr9Crossing)
      }      
    }
    task.resume()
    sem.wait()

    return crossings
  }
    
}

