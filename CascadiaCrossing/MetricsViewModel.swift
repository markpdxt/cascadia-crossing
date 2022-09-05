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
  
    @Published private(set) var pointRoberts = Crossing(crossingName: .pointRoberts)
    @Published private(set) var boundaryBay = Crossing(crossingName: .boundaryBay)

    @Published private(set) var peaceArch = Crossing(crossingName: .peaceArch)
    @Published private(set) var douglas = Crossing(crossingName: .douglas)

    @Published private(set) var pacificHwyBlaine = Crossing(crossingName: .pacificHwyBlaine)
    @Published private(set) var pacificHwySurrey = Crossing(crossingName: .pacificHwySurrey)

    @Published private(set) var lynden = Crossing(crossingName: .lynden)
    @Published private(set) var aldergrove = Crossing(crossingName: .aldergrove)

    @Published private(set) var sumas = Crossing(crossingName: .sumas)
    @Published private(set) var abbotsford = Crossing(crossingName: .abbotsford)
    
    internal init() {
      updateCbpSource()
      updateWSDotData()      
      let _ = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { timer in
        self.updateCbpSource()
        self.updateWSDotData()
      }
    }
        
    func openMap(coordinates: CoordinatesTuple) {
      let url = URL(string: "maps://?q=\("Crossing")&ll=\(coordinates.lat),\(coordinates.lng)")!
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
      }
    }
    
    private func updateCbpSource() {
      NetworkService(baseURLString: SourceURLs.cbp.rawValue).getPublisherForResponseXML().sink { _ in
      } receiveValue: { data in
        let crossings = self.transformCBPData(data: data)
        for crossing in crossings {
          switch crossing.portName {
          case .blaine:
            switch crossing.crossingName {
            case .pointRoberts:
              self.pointRoberts = crossing
              self.pointRoberts.standardLanesColor = self.setColor(self.pointRoberts.stanadrdLanesDelay,
                                                                   hasData: self.pointRoberts.hasData,
                                                                   isClosed: self.pointRoberts.standardLanesIsClosed)
              self.pointRoberts.standardLanesSuffix = self.setSuffixBy(hasData: self.pointRoberts.hasData,
                                                                       isClosed: self.pointRoberts.standardLanesIsClosed)
              self.pointRoberts.nexusSentriLanesColor = self.setColor(self.pointRoberts.nexusSentriLanesDelay,
                                                                      hasData: self.pointRoberts.hasData,
                                                                      isClosed: self.pointRoberts.nexusSentriLanesIsClosed)
              self.pointRoberts.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.pointRoberts.hasData,
                                                                          isClosed: self.pointRoberts.nexusSentriLanesIsClosed)
            case .peaceArch:
              self.peaceArch = crossing
              self.peaceArch.standardLanesColor = self.setColor(self.peaceArch.stanadrdLanesDelay,
                                                                hasData: self.peaceArch.hasData,
                                                                isClosed: self.peaceArch.standardLanesIsClosed)
              self.peaceArch.standardLanesSuffix = self.setSuffixBy(hasData: self.peaceArch.hasData,
                                                                    isClosed: self.peaceArch.standardLanesIsClosed)
              self.peaceArch.nexusSentriLanesColor = self.setColor(self.peaceArch.nexusSentriLanesDelay,
                                                                   hasData: self.peaceArch.hasData,
                                                                   isClosed: self.peaceArch.nexusSentriLanesIsClosed)
              self.peaceArch.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.peaceArch.hasData,
                                                                       isClosed: self.peaceArch.nexusSentriLanesIsClosed)
              self.peaceArch.crossingName = .peaceArch
            case .pacificHwyBlaine:
              self.pacificHwyBlaine = crossing
              self.pacificHwyBlaine.standardLanesColor = self.setColor(self.pacificHwyBlaine.stanadrdLanesDelay,
                                                                           hasData: self.pacificHwyBlaine.hasData,
                                                                           isClosed: self.pacificHwyBlaine.standardLanesIsClosed)
              self.pacificHwyBlaine.standardLanesSuffix = self.setSuffixBy(hasData: self.pacificHwyBlaine.hasData,
                                                                               isClosed: self.pacificHwyBlaine.standardLanesIsClosed)
              self.pacificHwyBlaine.nexusSentriLanesColor = self.setColor(self.pacificHwyBlaine.nexusSentriLanesDelay,
                                                                              hasData: self.pacificHwyBlaine.hasData,
                                                                              isClosed: self.pacificHwyBlaine.nexusSentriLanesIsClosed)
              self.pacificHwyBlaine.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.pacificHwyBlaine.hasData,
                                                                                  isClosed: self.pacificHwyBlaine.nexusSentriLanesIsClosed)
              self.pacificHwyBlaine.crossingName = .pacificHwyBlaineDisplay
            default:
              break
            }
          case .lynden:
            self.lynden = crossing
            self.lynden.standardLanesColor = self.setColor(self.lynden.stanadrdLanesDelay, hasData: self.lynden.hasData, isClosed: self.lynden.standardLanesIsClosed)
            self.lynden.standardLanesSuffix = self.setSuffixBy(hasData: self.lynden.hasData, isClosed: self.lynden.standardLanesIsClosed)
            self.lynden.nexusSentriLanesColor = self.setColor(self.lynden.nexusSentriLanesDelay, hasData: self.lynden.hasData, isClosed: self.lynden.nexusSentriLanesIsClosed)
            self.lynden.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.lynden.hasData, isClosed: self.lynden.nexusSentriLanesIsClosed)
            self.lynden.crossingName = .lynden
          case .sumas:
            self.sumas = crossing
            self.sumas.standardLanesColor = self.setColor(self.sumas.stanadrdLanesDelay, isClosed: self.sumas.standardLanesIsClosed)
            self.sumas.standardLanesSuffix = self.setSuffixBy(hasData: self.sumas.hasData, isClosed: self.sumas.standardLanesIsClosed)
            self.sumas.nexusSentriLanesColor = self.setColor(self.sumas.nexusSentriLanesDelay, isClosed: self.sumas.nexusSentriLanesIsClosed)
            self.sumas.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.sumas.hasData, isClosed: self.sumas.nexusSentriLanesIsClosed)
            self.sumas.crossingName = .sumas
          default:
            break
          }
        }
      }.store(in: &anyCancellables)
    }
    
    private func updateWSDotData() {
      NetworkService(baseURLString: SourceURLs.wsdot.rawValue).getPublisherForResponseXML().sink { _ in
      } receiveValue: { data in
        let crossings = self.transformWSDotData(data: data)
        for crossing in crossings {
          switch crossing.crossingName {
          case .i5:
            self.douglas = crossing
            self.douglas.standardLanesColor = self.setColor(self.douglas.stanadrdLanesDelay, isClosed: self.douglas.standardLanesIsClosed)
            self.douglas.standardLanesSuffix = self.setSuffixBy(hasData: self.douglas.hasData, isClosed: self.douglas.standardLanesIsClosed)
            self.douglas.nexusSentriLanesColor = self.setColor(self.douglas.nexusSentriLanesDelay, isClosed: self.douglas.nexusSentriLanesIsClosed)
            self.douglas.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.douglas.hasData, isClosed: self.douglas.nexusSentriLanesIsClosed)
            self.douglas.crossingName = .douglas
          case .sr539:
            self.pacificHwySurrey = crossing
            self.pacificHwySurrey.standardLanesColor = self.setColor(self.pacificHwySurrey.stanadrdLanesDelay, isClosed: self.pacificHwySurrey.standardLanesIsClosed)
            self.pacificHwySurrey.standardLanesSuffix = self.setSuffixBy(hasData: self.pacificHwySurrey.hasData, isClosed: self.pacificHwySurrey.standardLanesIsClosed)
            self.pacificHwySurrey.nexusSentriLanesColor = self.setColor(self.pacificHwySurrey.nexusSentriLanesDelay, isClosed: self.pacificHwySurrey.nexusSentriLanesIsClosed)
            self.pacificHwySurrey.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.pacificHwySurrey.hasData, isClosed: self.pacificHwySurrey.nexusSentriLanesIsClosed)
            self.pacificHwySurrey.crossingName = .pacificHwySurrey
          case .sr543:
            self.aldergrove = crossing
            self.aldergrove.standardLanesColor = self.setColor(self.aldergrove.stanadrdLanesDelay, isClosed: self.aldergrove.standardLanesIsClosed)
            self.aldergrove.standardLanesSuffix = self.setSuffixBy(hasData: self.aldergrove.hasData, isClosed: self.aldergrove.standardLanesIsClosed)
            self.aldergrove.nexusSentriLanesColor = self.setColor(self.aldergrove.nexusSentriLanesDelay, isClosed: self.aldergrove.nexusSentriLanesIsClosed)
            self.aldergrove.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.aldergrove.hasData, isClosed: self.aldergrove.nexusSentriLanesIsClosed)
            self.aldergrove.crossingName = .aldergrove
          case .sr9:
            self.abbotsford = crossing
            self.abbotsford.standardLanesColor = self.setColor(self.abbotsford.stanadrdLanesDelay, isClosed: self.abbotsford.standardLanesIsClosed)
            self.abbotsford.standardLanesSuffix = self.setSuffixBy(hasData: self.abbotsford.hasData, isClosed: self.abbotsford.standardLanesIsClosed)
            self.abbotsford.nexusSentriLanesColor = self.setColor(self.abbotsford.nexusSentriLanesDelay, isClosed: self.abbotsford.nexusSentriLanesIsClosed)
            self.abbotsford.nexusSentriLanesSuffix = self.setSuffixBy(hasData: self.abbotsford.hasData, isClosed: self.abbotsford.nexusSentriLanesIsClosed)
            self.abbotsford.crossingName = .abbotsford
          default:
            break
          }
        }
        /// No data for this crossing yet
        self.boundaryBay.hasData = false
        self.boundaryBay.standardLanesSuffix = NSLocalizedString("no data", comment: "")
        self.boundaryBay.nexusSentriLanesSuffix = NSLocalizedString("no data", comment: "")
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
                      
          var crossingNameString = port["crossing_name"].text ?? ""
          if crossingNameString == "" {
            crossingNameString = port["port_name"].text ?? ""
          }
          
          let crossingName: Crossings = crossingNameEnum(crossingNameString)
          
          let portNameString = port["port_name"].text ?? ""
          
          let portName: Ports = portNameEnum(portNameString)
          
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
                                         portName: portName,
                                         crossingName: crossingName,
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
            i5Crossing.crossingName = crossingNameEnum(crossingName)
            i5Crossing.stanadrdLanesDelay = lanesDelay
            i5Crossing.standardLanesUpdated = lanesUpdated
            i5Crossing.standardLanesIsClosed = isClosed
            crossings.append(i5Crossing)
          case filteredCrossings[2]:
            sr539Crossing.hasData = hasData
            sr539Crossing.crossingName = crossingNameEnum(crossingName)
            sr539Crossing.stanadrdLanesDelay = lanesDelay
            sr539Crossing.standardLanesUpdated = lanesUpdated
            sr539Crossing.standardLanesIsClosed = isClosed
            crossings.append(sr539Crossing)
          case filteredCrossings[4]:
            sr543Crossing.hasData = hasData
            sr543Crossing.crossingName = crossingNameEnum(crossingName)
            sr543Crossing.stanadrdLanesDelay = lanesDelay
            sr543Crossing.standardLanesUpdated = lanesUpdated
            sr543Crossing.standardLanesIsClosed = isClosed
            crossings.append(sr543Crossing)
          case filteredCrossings[6]:
            sr9Crossing.hasData = hasData
            sr9Crossing.crossingName = crossingNameEnum(crossingName)
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
    
    // TODO: Need to move this back to the enum after investigating best practice to convert
    private func crossingNameEnum(_ crossingName: String) -> Crossings {
      switch crossingName {
      case Crossings.pointRoberts.rawValue:
        return .pointRoberts
      case Crossings.boundaryBay.rawValue:
        return .boundaryBay
      case Crossings.peaceArch.rawValue:
        return .peaceArch
      case Crossings.douglas.rawValue:
        return .douglas
      case Crossings.pacificHwyBlaine.rawValue:
        return .pacificHwyBlaine
      case Crossings.pacificHwySurrey.rawValue:
        return .pacificHwySurrey
      case Crossings.lynden.rawValue:
        return .lynden
      case Crossings.aldergrove.rawValue:
        return .aldergrove
      case Crossings.sumas.rawValue:
        return .sumas
      case Crossings.abbotsford.rawValue:
        return .abbotsford
      case Crossings.i5.rawValue:
        return .i5
      case Crossings.sr539.rawValue:
        return .sr539
      case Crossings.sr543.rawValue:
        return .sr543
      case Crossings.sr9.rawValue:
        return .sr9
      case Crossings.none.rawValue:
        return .none
      default:
        return .none
      }
    }
    
    // TODO: Need to move this back to the enum after investigating best practice to convert
    private func portNameEnum(_ portName: String) -> Ports {
      switch portName {
      case Ports.blaine.rawValue:
        return .blaine
      case Ports.lynden.rawValue:
        return .lynden
      case Ports.sumas.rawValue:
        return .sumas
      default:
        return .none
      }
    }
    
  }
  
}
