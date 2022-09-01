// Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.

import Foundation
import SwiftyXMLParser
import Logging

class CPBDataParser {
  let logger = Logger(label: "CPBDataParser+")
  
  let url = NSURL(string: "https://bwt.cbp.gov/xml/bwt.xml")
  
  var lastUpdated: Date?
  var numberOfPorts: Int?
  
  func fetch() -> [Crossing] {
    let sem = DispatchSemaphore.init(value: 0)
    
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    var crossings = [Crossing]()
    
    let task = URLSession.shared.dataTask(with: url! as URL) { [self] (data, response, error) in
      defer { sem.signal() }
      
      if data != nil {
        let feed = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
        let xml = try! XML.parse(feed)
        
        for item in xml["border_wait_time"] {
          guard let dateString = item["last_updated_date"].text,
                let timeString = item["last_updated_time"].text else {
            self.logger.error("border_wait_time doesn't exist")
            return
          }
          
          let dateTimeString = "\(dateString) \(timeString)"
          
          guard let dateTime = dateFormatter.date(from: dateTimeString) else {
            self.logger.error("last_updated_time doesn't exist")
            return
          }
          
          /// Source data is US ET. Converting to UTC.
          self.lastUpdated = dateTime.addingTimeInterval(-3600 * 3)
          
          guard let numberOfPortsString = item["number_of_ports"].text,
                let numberOfPorts = Int(numberOfPortsString) else {
            self.logger.error("number_of_ports doesn't exist")
            return
          }
          
          self.numberOfPorts = numberOfPorts
          
          let filteredCrossings = ["Blaine", "Sumas", "Lynden"]
          
          for port in item["port"] {
            
            guard filteredCrossings.contains(port["port_name"].text ?? "") else {
              continue
            }
                        
            var crossingName = port["crossing_name"].text ?? ""
            if crossingName == "" {
              crossingName = port["port_name"].text ?? ""
            }
            
            let portName = port["port_name"].text ?? ""
            let maximumLanes = Int(port["maximum_lanes"].text ?? "0") ?? 0
            let standardLanesOpen = Int(port["passenger_vehicle_lanes"]["standard_lanes"]["lanes_open"].text ?? "0") ?? 0
            let standardLanesDelay = Int(port["passenger_vehicle_lanes"]["standard_lanes"]["delay_minutes"].text ?? "0") ?? 0
            var standardLanesUpdated = port["passenger_vehicle_lanes"]["standard_lanes"]["update_time"].text ?? ""
            let nexusSentriLanesOpen = Int(port["passenger_vehicle_lanes"]["NEXUS_SENTRI_lanes"]["lanes_open"].text ?? "0") ?? 0
            let nexusSentriLanesDelay = Int(port["passenger_vehicle_lanes"]["NEXUS_SENTRI_lanes"]["delay_minutes"].text ?? "0") ?? 0
            var nexusSentriLanesUpdated = port["passenger_vehicle_lanes"]["NEXUS_SENTRI_lanes"]["update_time"].text ?? ""

            let operationalStatusStandard = port["passenger_vehicle_lanes"]["standard_lanes"]["operational_status"].text ?? ""
            let operationalStatusNexusSentri = port["passenger_vehicle_lanes"]["NEXUS_SENTRI_lanes"]["operational_status"].text ?? ""

            if !standardLanesUpdated.isEmpty {
              standardLanesUpdated.removeFirst(3)
              standardLanesUpdated.removeLast(3)
              standardLanesUpdated = standardLanesUpdated.replacingOccurrences(of: "pm", with: "PM")
            }
            
            if !nexusSentriLanesUpdated.isEmpty {
              nexusSentriLanesUpdated.removeFirst(2)
              nexusSentriLanesUpdated.removeLast(3)
              nexusSentriLanesUpdated = nexusSentriLanesUpdated.replacingOccurrences(of: "pm", with: "PM")
            }
            
            var hasData = true
            if operationalStatusStandard == "Update Pending" ||
                operationalStatusNexusSentri == "Update Pending" {
              hasData = false
            }
            
            var standardLanesIsClosed = true
            if standardLanesOpen > 0 && hasData {
              standardLanesIsClosed = false
            }
            
            var nexusSentriLanesIsClosed = true
            if nexusSentriLanesOpen > 0 && hasData {
              nexusSentriLanesIsClosed = false
            }
            
            let crossing: Crossing = .init(hasData: hasData,
                                           crossingName: crossingName,
                                           portName: portName,
                                           maximumLanes: maximumLanes,
                                           standardLanesOpen: standardLanesOpen,
                                           stanadrdLanesDelay: standardLanesDelay,
                                           standardLanesIsClosed: standardLanesIsClosed,
                                           standardLanesUpdated: standardLanesUpdated,
                                           nexusSentriLanesOpen: nexusSentriLanesOpen,
                                           nexusSentriLanesDelay: nexusSentriLanesDelay,
                                           nexusSentriLanesIsClosed: nexusSentriLanesIsClosed,
                                           nexusSentriLanesUpdated: nexusSentriLanesUpdated)
            crossings.append(crossing)
          }
        }
      }
    }
    task.resume()
    sem.wait()
    
    return crossings
  }
  
}
