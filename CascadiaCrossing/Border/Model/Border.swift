// Copyright (c) 2024 PDX Technologies, LLC. All rights reserved.

import SwiftUI

struct Border {
  internal init(hasData: Bool = false,
                portName: LandPorts = .none,
                crossingName: LandCrossings = .none,
                maximumLanes: Int = 0,
                standardLanesOpen: Int = 0,
                stanadrdLanesDelay: Int = 0,
                standardLanesColor: Color = .gray,
                standardLanesSuffix: String = "",
                standardLanesIsClosed: Bool = false,
                standardLanesUpdated: String = "",
                nexusSentriLanesOpen: Int = 0,
                nexusSentriLanesDelay: Int = 0,
                nexusSentriLanesColor: Color = .gray,
                nexusSentriLanesSuffix: String = "",
                nexusSentriLanesIsClosed: Bool = false,
                nexusSentriLanesUpdated: String = "") {
    self.hasData = hasData
    self.portName = portName
    self.crossingName = crossingName
    self.maximumLanes = maximumLanes
    self.standardLanesOpen = standardLanesOpen
    self.stanadrdLanesDelay = stanadrdLanesDelay
    self.standardLanesColor = standardLanesColor
    self.standardLanesSuffix = standardLanesSuffix
    self.standardLanesIsClosed = standardLanesIsClosed
    self.standardLanesUpdated = standardLanesUpdated
    self.nexusSentriLanesOpen = nexusSentriLanesOpen
    self.nexusSentriLanesDelay = nexusSentriLanesDelay
    self.nexusSentriLanesColor = nexusSentriLanesColor
    self.nexusSentriLanesSuffix = nexusSentriLanesSuffix
    self.nexusSentriLanesIsClosed = nexusSentriLanesIsClosed
    self.nexusSentriLanesUpdated = nexusSentriLanesUpdated
  }
  
  var hasData: Bool
  var portName: LandPorts
  var crossingName: LandCrossings
  var maximumLanes: Int
  var standardLanesOpen: Int
  var stanadrdLanesDelay: Int
  var standardLanesColor: Color
  var standardLanesSuffix: String
  var standardLanesIsClosed: Bool
  var standardLanesUpdated: String
  var nexusSentriLanesOpen: Int
  var nexusSentriLanesDelay: Int
  var nexusSentriLanesColor: Color
  var nexusSentriLanesSuffix: String
  var nexusSentriLanesIsClosed: Bool
  var nexusSentriLanesUpdated: String
}

