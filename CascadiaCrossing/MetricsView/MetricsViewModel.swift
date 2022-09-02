// Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.

import SwiftUI
import Combine
import Logging

extension MetricsView {
  class MetricsViewModel: ObservableObject {
    let logger = Logger(label: "MetricsView+")

    private var cancellables = Set<AnyCancellable>()
  
    private let cpbParser = CPBDataParser()
    private let wsdotParser = WSDotDataParser()

    private var crossings = [Crossing]()

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
      updateCpbData()
      updateWSDotData()
      let _ = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { timer in
        self.updateCpbData()
        self.updateWSDotData()
      }
    }

    private func updateCpbData() {
      crossings = cpbParser.fetch()

      for crossing in crossings {
        switch crossing.portName {
        case "Blaine":
          switch crossing.crossingName {
          case "Point Roberts":
            pointRoberts = crossing
            pointRoberts.standardLanesColor = setColor(pointRoberts.stanadrdLanesDelay, hasData: pointRoberts.hasData, isClosed: pointRoberts.standardLanesIsClosed)
            pointRoberts.standardLanesSuffix = setSuffixBy(hasData: pointRoberts.hasData, isClosed: pointRoberts.standardLanesIsClosed)
            pointRoberts.nexusSentriLanesColor = setColor(pointRoberts.nexusSentriLanesDelay, hasData: pointRoberts.hasData, isClosed: pointRoberts.nexusSentriLanesIsClosed)
            pointRoberts.nexusSentriLanesSuffix = setSuffixBy(hasData: pointRoberts.hasData, isClosed: pointRoberts.nexusSentriLanesIsClosed)
            print(pointRoberts)
          case "Peace Arch":
            peachArch = crossing
            peachArch.standardLanesColor = setColor(peachArch.stanadrdLanesDelay, hasData: peachArch.hasData, isClosed: peachArch.standardLanesIsClosed)
            peachArch.standardLanesSuffix = setSuffixBy(hasData: peachArch.hasData, isClosed: peachArch.standardLanesIsClosed)
            peachArch.nexusSentriLanesColor = setColor(peachArch.nexusSentriLanesDelay, hasData: peachArch.hasData, isClosed: peachArch.nexusSentriLanesIsClosed)
            peachArch.nexusSentriLanesSuffix = setSuffixBy(hasData: peachArch.hasData, isClosed: peachArch.nexusSentriLanesIsClosed)
          case "Pacific Highway":
            pacificHighwayBlaine = crossing
            pacificHighwayBlaine.standardLanesColor = setColor(pacificHighwayBlaine.stanadrdLanesDelay, hasData: pacificHighwayBlaine.hasData, isClosed: pacificHighwayBlaine.standardLanesIsClosed)
            pacificHighwayBlaine.standardLanesSuffix = setSuffixBy(hasData: pacificHighwayBlaine.hasData, isClosed: pacificHighwayBlaine.standardLanesIsClosed)
            pacificHighwayBlaine.nexusSentriLanesColor = setColor(pacificHighwayBlaine.nexusSentriLanesDelay, hasData: pacificHighwayBlaine.hasData, isClosed: pacificHighwayBlaine.nexusSentriLanesIsClosed)
            pacificHighwayBlaine.nexusSentriLanesSuffix = setSuffixBy(hasData: pacificHighwayBlaine.hasData, isClosed: pacificHighwayBlaine.nexusSentriLanesIsClosed)
            pacificHighwayBlaine.crossingName = "Pacific Hwy Blaine"
          default:
            break
          }
        case "Lynden":
          lynden = crossing
          lynden.standardLanesColor = setColor(lynden.stanadrdLanesDelay, hasData: lynden.hasData, isClosed: lynden.standardLanesIsClosed)
          lynden.standardLanesSuffix = setSuffixBy(hasData: lynden.hasData, isClosed: lynden.standardLanesIsClosed)
          lynden.nexusSentriLanesColor = setColor(lynden.nexusSentriLanesDelay, hasData: lynden.hasData, isClosed: lynden.nexusSentriLanesIsClosed)
          lynden.nexusSentriLanesSuffix = setSuffixBy(hasData: lynden.hasData, isClosed: lynden.nexusSentriLanesIsClosed)
          lynden.crossingName = "Lynden"
        case "Sumas":
          sumas = crossing
          sumas.standardLanesColor = setColor(sumas.stanadrdLanesDelay, isClosed: sumas.standardLanesIsClosed)
          sumas.standardLanesSuffix = setSuffixBy(hasData: sumas.hasData, isClosed: sumas.standardLanesIsClosed)
          sumas.nexusSentriLanesColor = setColor(sumas.nexusSentriLanesDelay, isClosed: sumas.nexusSentriLanesIsClosed)
          sumas.nexusSentriLanesSuffix = setSuffixBy(hasData: sumas.hasData, isClosed: sumas.nexusSentriLanesIsClosed)
          sumas.crossingName = "Sumas"
          print(sumas)
        default:
          break
        }
      }
    }
    
    private func updateWSDotData() {
      crossings = wsdotParser.fetch()
      
      for crossing in crossings {
        switch crossing.crossingName {
        case "I5":
          douglas = crossing
          douglas.standardLanesColor = setColor(douglas.stanadrdLanesDelay, isClosed: douglas.standardLanesIsClosed)
          douglas.standardLanesSuffix = setSuffixBy(hasData: douglas.hasData, isClosed: douglas.standardLanesIsClosed)
          douglas.nexusSentriLanesColor = setColor(douglas.nexusSentriLanesDelay, isClosed: douglas.nexusSentriLanesIsClosed)
          douglas.nexusSentriLanesSuffix = setSuffixBy(hasData: douglas.hasData, isClosed: douglas.nexusSentriLanesIsClosed)
          douglas.crossingName = "Douglas"
        case "SR539":
          pacificHighwaySurrey = crossing
          pacificHighwaySurrey.standardLanesColor = setColor(pacificHighwaySurrey.stanadrdLanesDelay, isClosed: pacificHighwaySurrey.standardLanesIsClosed)
          pacificHighwaySurrey.standardLanesSuffix = setSuffixBy(hasData: pacificHighwaySurrey.hasData, isClosed: pacificHighwaySurrey.standardLanesIsClosed)
          pacificHighwaySurrey.nexusSentriLanesColor = setColor(pacificHighwaySurrey.nexusSentriLanesDelay, isClosed: pacificHighwaySurrey.nexusSentriLanesIsClosed)
          pacificHighwaySurrey.nexusSentriLanesSuffix = setSuffixBy(hasData: pacificHighwaySurrey.hasData, isClosed: pacificHighwaySurrey.nexusSentriLanesIsClosed)
          pacificHighwaySurrey.crossingName = "Pacific Hwy Surrey"
        case "SR543":
          aldergrove = crossing
          aldergrove.standardLanesColor = setColor(aldergrove.stanadrdLanesDelay, isClosed: aldergrove.standardLanesIsClosed)
          aldergrove.standardLanesSuffix = setSuffixBy(hasData: aldergrove.hasData, isClosed: aldergrove.standardLanesIsClosed)
          aldergrove.nexusSentriLanesColor = setColor(aldergrove.nexusSentriLanesDelay, isClosed: aldergrove.nexusSentriLanesIsClosed)
          aldergrove.nexusSentriLanesSuffix = setSuffixBy(hasData: aldergrove.hasData, isClosed: aldergrove.nexusSentriLanesIsClosed)
          aldergrove.crossingName = "Aldergrove"
        case "SR9":
          abbotsford = crossing
          abbotsford.standardLanesColor = setColor(abbotsford.stanadrdLanesDelay, isClosed: abbotsford.standardLanesIsClosed)
          abbotsford.standardLanesSuffix = setSuffixBy(hasData: abbotsford.hasData, isClosed: abbotsford.standardLanesIsClosed)
          abbotsford.nexusSentriLanesColor = setColor(abbotsford.nexusSentriLanesDelay, isClosed: abbotsford.nexusSentriLanesIsClosed)
          abbotsford.nexusSentriLanesSuffix = setSuffixBy(hasData: abbotsford.hasData, isClosed: abbotsford.nexusSentriLanesIsClosed)
          abbotsford.crossingName = "Abbotsford"
        default:
          break
        }
      }
      
      /// No data for this crossing yet
      boundryBay.hasData = false
      boundryBay.standardLanesSuffix = NSLocalizedString("no data", comment: "")
      boundryBay.nexusSentriLanesSuffix = NSLocalizedString("no data", comment: "")
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
    
  }
}

enum Lanes {
  case open
  case delay
}
