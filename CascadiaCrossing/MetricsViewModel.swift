// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

import SwiftUI
import Combine
import Logging
import SwiftyXMLParser

extension MetricsView {
  class MetricsViewModel: ObservableObject {
    let logger = Logger(label: "MetricsView+")

    var crossings = [Crossing]()
    
    var anyCancellables = Set<AnyCancellable>()
  
    @Published private(set) var pointRoberts = Crossing(crossingName: "Point Roberts")
    @Published private(set) var boundryBay = Crossing(crossingName: "Boundary Bay")

    @Published private(set) var peachArch = Crossing(crossingName: "Peace Arch")
    @Published private(set) var douglas = Crossing(crossingName: "Douglas")

    @Published private(set) var pacificHighwayBlaine = Crossing(crossingName: "Pacific Hwy Blaine")
    @Published private(set) var pacificHighwaySurrey = Crossing(crossingName: "Pacific Hwy Surrey")

    @Published private(set) var lynden = Crossing(crossingName: "Lynden")
    @Published private(set) var aldergrove = Crossing(crossingName: "Aldergrove")

    @Published private(set) var sumas = Crossing(crossingName: "Sumas")
    @Published private(set) var abbotsford = Crossing(crossingName: "Abbotsford")
    
    internal init() {
      updateCbpSource()
      updateWSDotData()
      let _ = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { timer in
        self.updateCbpSource()
        self.updateWSDotData()
      }
    }
        
    private func updateCbpSource() {
      NetworkService(baseURLString: "https://bwt.cbp.gov/xml/bwt.xml").getPublisherForResponseXML().sink { _ in
      } receiveValue: { data in
        let crossings = self.transformCBPData(data: data)
        for crossing in crossings {
          switch crossing.portName {
          case "Blaine":
            switch crossing.crossingName {
            case "Point Roberts":
              self.pointRoberts = crossing
              self.pointRoberts.standardLanesColor = self.setColor(self.pointRoberts.stanadrdLanesDelay, hasData: self.pointRoberts.hasData, isClosed: self.pointRoberts.standardLanesIsClosed)
              self.pointRoberts.standardLanesSuffix = self.setSuffixBy(hasData: self.pointRoberts.hasData, isClosed: self.pointRoberts.standardLanesIsClosed)
              self.pointRoberts.nexusSentriLanesColor = self.setColor(self.pointRoberts.nexusSentriLanesDelay, hasData: self.pointRoberts.hasData, isClosed: self.pointRoberts.nexusSentriLanesIsClosed)
              self.pointRoberts.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.pointRoberts.hasData, isClosed: self.pointRoberts.nexusSentriLanesIsClosed)
            case "Peace Arch":
              self.peachArch = crossing
              self.peachArch.standardLanesColor = self.setColor(self.peachArch.stanadrdLanesDelay, hasData: self.peachArch.hasData, isClosed: self.peachArch.standardLanesIsClosed)
              self.peachArch.standardLanesSuffix = self.setSuffixBy(hasData: self.peachArch.hasData, isClosed: self.peachArch.standardLanesIsClosed)
              self.peachArch.nexusSentriLanesColor = self.setColor(self.peachArch.nexusSentriLanesDelay, hasData: self.peachArch.hasData, isClosed: self.peachArch.nexusSentriLanesIsClosed)
              self.peachArch.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.peachArch.hasData, isClosed: self.peachArch.nexusSentriLanesIsClosed)
            case "Pacific Highway":
              self.pacificHighwayBlaine = crossing
              self.pacificHighwayBlaine.standardLanesColor = self.setColor(self.pacificHighwayBlaine.stanadrdLanesDelay, hasData: self.pacificHighwayBlaine.hasData, isClosed: self.pacificHighwayBlaine.standardLanesIsClosed)
              self.pacificHighwayBlaine.standardLanesSuffix = self.setSuffixBy(hasData: self.pacificHighwayBlaine.hasData, isClosed: self.pacificHighwayBlaine.standardLanesIsClosed)
              self.pacificHighwayBlaine.nexusSentriLanesColor = self.setColor(self.pacificHighwayBlaine.nexusSentriLanesDelay, hasData: self.pacificHighwayBlaine.hasData, isClosed: self.pacificHighwayBlaine.nexusSentriLanesIsClosed)
              self.pacificHighwayBlaine.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.pacificHighwayBlaine.hasData, isClosed: self.pacificHighwayBlaine.nexusSentriLanesIsClosed)
              self.pacificHighwayBlaine.crossingName = "Pacific Hwy Blaine"
            default:
              break
            }
          case "Lynden":
            self.lynden = crossing
            self.lynden.standardLanesColor = self.setColor(self.lynden.stanadrdLanesDelay, hasData: self.lynden.hasData, isClosed: self.lynden.standardLanesIsClosed)
            self.lynden.standardLanesSuffix = self.setSuffixBy(hasData: self.lynden.hasData, isClosed: self.lynden.standardLanesIsClosed)
            self.lynden.nexusSentriLanesColor = self.setColor(self.lynden.nexusSentriLanesDelay, hasData: self.lynden.hasData, isClosed: self.lynden.nexusSentriLanesIsClosed)
            self.lynden.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.lynden.hasData, isClosed: self.lynden.nexusSentriLanesIsClosed)
            self.lynden.crossingName = "Lynden"
          case "Sumas":
            self.sumas = crossing
            self.sumas.standardLanesColor = self.setColor(self.sumas.stanadrdLanesDelay, isClosed: self.sumas.standardLanesIsClosed)
            self.sumas.standardLanesSuffix = self.setSuffixBy(hasData: self.sumas.hasData, isClosed: self.sumas.standardLanesIsClosed)
            self.sumas.nexusSentriLanesColor = self.setColor(self.sumas.nexusSentriLanesDelay, isClosed: self.sumas.nexusSentriLanesIsClosed)
            self.sumas.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.sumas.hasData, isClosed: self.sumas.nexusSentriLanesIsClosed)
            self.sumas.crossingName = "Sumas"
          default:
            break
          }
        }
      }.store(in: &anyCancellables)
    }
    
    private func updateWSDotData() {
      NetworkService(baseURLString: "https://wsdot.wa.gov/Traffic/api/BorderCrossings/BorderCrossingsREST.svc/GetBorderCrossingsAsXml?AccessCode=4d681f27-a992-416c-8d02-410903ab6311").getPublisherForResponseXML().sink { _ in
      } receiveValue: { data in
        let crossings = self.transformWSDotData(data: data)
        for crossing in crossings {
          switch crossing.crossingName {
          case "I5":
            self.douglas = crossing
            self.douglas.standardLanesColor = self.setColor(self.douglas.stanadrdLanesDelay, isClosed: self.douglas.standardLanesIsClosed)
            self.douglas.standardLanesSuffix = self.setSuffixBy(hasData: self.douglas.hasData, isClosed: self.douglas.standardLanesIsClosed)
            self.douglas.nexusSentriLanesColor = self.setColor(self.douglas.nexusSentriLanesDelay, isClosed: self.douglas.nexusSentriLanesIsClosed)
            self.douglas.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.douglas.hasData, isClosed: self.douglas.nexusSentriLanesIsClosed)
            self.douglas.crossingName = "Douglas"
          case "SR539":
            self.pacificHighwaySurrey = crossing
            self.pacificHighwaySurrey.standardLanesColor = self.setColor(self.pacificHighwaySurrey.stanadrdLanesDelay, isClosed: self.pacificHighwaySurrey.standardLanesIsClosed)
            self.pacificHighwaySurrey.standardLanesSuffix = self.setSuffixBy(hasData: self.pacificHighwaySurrey.hasData, isClosed: self.pacificHighwaySurrey.standardLanesIsClosed)
            self.pacificHighwaySurrey.nexusSentriLanesColor = self.setColor(self.pacificHighwaySurrey.nexusSentriLanesDelay, isClosed: self.pacificHighwaySurrey.nexusSentriLanesIsClosed)
            self.pacificHighwaySurrey.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.pacificHighwaySurrey.hasData, isClosed: self.pacificHighwaySurrey.nexusSentriLanesIsClosed)
            self.pacificHighwaySurrey.crossingName = "Pacific Hwy Surrey"
          case "SR543":
            self.aldergrove = crossing
            self.aldergrove.standardLanesColor = self.setColor(self.aldergrove.stanadrdLanesDelay, isClosed: self.aldergrove.standardLanesIsClosed)
            self.aldergrove.standardLanesSuffix = self.setSuffixBy(hasData: self.aldergrove.hasData, isClosed: self.aldergrove.standardLanesIsClosed)
            self.aldergrove.nexusSentriLanesColor = self.setColor(self.aldergrove.nexusSentriLanesDelay, isClosed: self.aldergrove.nexusSentriLanesIsClosed)
            self.aldergrove.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.aldergrove.hasData, isClosed: self.aldergrove.nexusSentriLanesIsClosed)
            self.aldergrove.crossingName = "Aldergrove"
          case "SR9":
            self.abbotsford = crossing
            self.abbotsford.standardLanesColor = self.setColor(self.abbotsford.stanadrdLanesDelay, isClosed: self.abbotsford.standardLanesIsClosed)
            self.abbotsford.standardLanesSuffix = self.setSuffixBy(hasData: self.abbotsford.hasData, isClosed: self.abbotsford.standardLanesIsClosed)
            self.abbotsford.nexusSentriLanesColor = self.setColor(self.abbotsford.nexusSentriLanesDelay, isClosed: self.abbotsford.nexusSentriLanesIsClosed)
            self.abbotsford.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.abbotsford.hasData, isClosed: self.abbotsford.nexusSentriLanesIsClosed)
            self.abbotsford.crossingName = "Abbotsford"
          default:
            break
          }
        }
        /// No data for this crossing yet
        self.boundryBay.hasData = false
        self.boundryBay.standardLanesSuffix = NSLocalizedString("no data", comment: "")
        self.boundryBay.nexusSentriLanesSuffix = NSLocalizedString("no data", comment: "")
      }.store(in: &anyCancellables)
    }

    private func setSuffixBy(hasData: Bool, isClosed: Bool) -> String {
      if !hasData {
        return NSLocalizedString("no data", comment: "")
      } else if isClosed {
        return NSLocalizedString("closed", comment: "")
      } else {
        return NSLocalizedString("minutes", comment: "")
      }
    }
    
    private func setColor(_ delayTime: Int, hasData: Bool = true, isClosed: Bool = false) -> Color {
      guard hasData && !isClosed else {
        return .gray
      }
      
      switch delayTime {
      case let x where x < 0:
        return .gray
      case let x where x <= 10:
        return .green
      case let x where x < 60:
        return.yellow
      case let x where x >= 60:
        return .red
      default:
        return .gray
      }
    }
    
    private func transformCBPData(data: Data) -> [Crossing] {
      var crossings = [Crossing]()
            
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

      let feed = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
      let xml = try! XML.parse(feed)
      
      for item in xml["border_wait_time"] {
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
      return crossings
    }
    
    private func transformWSDotData(data: Data) -> [Crossing] {
      var crossings = [Crossing]()

      var i5Crossing = Crossing()
      var sr539Crossing = Crossing()
      var sr543Crossing = Crossing()
      var sr9Crossing = Crossing()
      
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
      
      let feed = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
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
            crossings.append(i5Crossing)
          case filteredCrossings[3]:
            sr539Crossing.nexusSentriLanesDelay = lanesDelay
            sr539Crossing.nexusSentriLanesUpdated = lanesUpdated
            sr539Crossing.nexusSentriLanesIsClosed = isClosed
            crossings.append(sr539Crossing)
          case filteredCrossings[5]:
            sr543Crossing.nexusSentriLanesDelay = lanesDelay
            sr543Crossing.nexusSentriLanesUpdated = lanesUpdated
            sr543Crossing.nexusSentriLanesIsClosed = isClosed
            crossings.append(sr543Crossing)
          case filteredCrossings[7]:
            sr9Crossing.nexusSentriLanesDelay = lanesDelay
            sr9Crossing.nexusSentriLanesUpdated = lanesUpdated
            sr9Crossing.nexusSentriLanesIsClosed = isClosed
            crossings.append(sr9Crossing)
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
            crossings.append(i5Crossing)
          case filteredCrossings[2]:
            sr539Crossing.hasData = hasData
            sr539Crossing.crossingName = crossingName
            sr539Crossing.stanadrdLanesDelay = lanesDelay
            sr539Crossing.standardLanesUpdated = lanesUpdated
            sr539Crossing.standardLanesIsClosed = isClosed
            crossings.append(sr539Crossing)
          case filteredCrossings[4]:
            sr543Crossing.hasData = hasData
            sr543Crossing.crossingName = crossingName
            sr543Crossing.stanadrdLanesDelay = lanesDelay
            sr543Crossing.standardLanesUpdated = lanesUpdated
            sr543Crossing.standardLanesIsClosed = isClosed
            crossings.append(sr543Crossing)
          case filteredCrossings[6]:
            sr9Crossing.hasData = hasData
            sr9Crossing.crossingName = crossingName
            sr9Crossing.stanadrdLanesDelay = lanesDelay
            sr9Crossing.standardLanesUpdated = lanesUpdated
            sr9Crossing.standardLanesIsClosed = isClosed
            crossings.append(sr9Crossing)
          default:
            break
          }
        }
      }
      return crossings
    }
  }
  
}
