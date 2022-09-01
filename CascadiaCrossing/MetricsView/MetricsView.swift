// Copyright (c) 2022 ___ORGANIZATIONNAME___. All rights reserved.

import SwiftUI

struct MetricsView: View {
  @ObservedObject private var viewModel = MetricsViewModel()
  
  var body: some View {
    TabView {
      crossing(north: viewModel.pointRoberts, south: viewModel.boundryBay)
      crossing(north: viewModel.peachArch, south: viewModel.douglas)
      crossing(north: viewModel.pacificHighwayBlaine, south: viewModel.pacificHighwaySurrey)
      crossing(north: viewModel.lynden, south: viewModel.aldergrove)
      crossing(north: viewModel.sumas, south: viewModel.abbotsford)
    }
    .tabViewStyle(.page)
    .background(.black)
  }
  
  func crossing(north: Crossing, south: Crossing) -> some View {
    VStack() {
      HStack {
        panel(lane: NSLocalizedString("Standard", comment: ""),
              laneCount: NSLocalizedString("Lanes \(north.standardLanesOpen)", comment: ""),
              wait: north.standardLanesColor == .gray ? "--" : "\(north.stanadrdLanesDelay)",
              suffix: north.standardLanesSuffix,
              updated: north.standardLanesUpdated,
              opacity: north.standardLanesSuffix == "no data" ? 0.85 : 1.0,
              color: north.standardLanesColor)
        panel(lane: NSLocalizedString("Nexus", comment: ""),
              laneCount: NSLocalizedString("Lanes \(north.nexusSentriLanesOpen)", comment: ""),
              wait: north.nexusSentriLanesColor == .gray ? "--" : "\(north.nexusSentriLanesDelay)",
              suffix: north.nexusSentriLanesSuffix,
              updated: north.nexusSentriLanesUpdated == "" ? north.standardLanesUpdated : north.nexusSentriLanesUpdated,
              opacity: north.nexusSentriLanesSuffix == "no data" ? 0.85 : 1.0,
              color: north.nexusSentriLanesColor)
      }
      VStack {
        Text(south.crossingName)
          .font(.system(size: 35))
          .fontWeight(.regular)
          .foregroundColor(.white)
          .scaledToFit()
          .minimumScaleFactor(0.01)
          .lineLimit(1)
        Divider()
          .frame(height: 2)
          .background(.white)
        Text(north.crossingName)
          .font(.system(size: 35))
          .fontWeight(.regular)
          .foregroundColor(.white)
          .scaledToFit()
          .minimumScaleFactor(0.01)
          .lineLimit(1)
      }
      HStack {
        panel(lane: NSLocalizedString("Standard", comment: ""),
              wait: south.standardLanesColor == .gray ? "--" : "\(south.stanadrdLanesDelay)",
              suffix: south.standardLanesSuffix,
              updated: south.standardLanesUpdated,
              opacity: south.standardLanesSuffix == "no data" ? 0.85 : 1.0,
              color: south.standardLanesColor)
        panel(lane: NSLocalizedString("Nexus", comment: ""),
              wait: south.nexusSentriLanesColor == .gray ? "--" : "\(south.nexusSentriLanesDelay)",
              suffix: south.nexusSentriLanesSuffix,
              updated: south.nexusSentriLanesUpdated,
              opacity: south.nexusSentriLanesSuffix == "no data" ? 0.85 : 1.0,
              color: south.nexusSentriLanesColor)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .padding(EdgeInsets.init(top: 10, leading: 10, bottom: 10, trailing: 10))
  }
  
  func panel(lane: String = "",
             laneCount: String = "",
             wait: String = "",
             suffix: String = "",
             updated: String = "",
             opacity: Double = 1.0,
             color: Color = .green) -> some View {
    HStack {
      VStack(alignment: .leading) {
        Text(lane)
          .font(.system(size: 28))
          .fontWeight(.semibold)
          .foregroundColor(.black)
          .scaledToFit()
          .minimumScaleFactor(0.01)
          .lineLimit(1)
          .frame(maxWidth: .infinity, alignment: .center)
        HStack {
          Text(laneCount)
            .font(.system(size: 26))
            .fontWeight(.semibold)
            .foregroundColor(.black)
            .scaledToFit()
            .minimumScaleFactor(0.01)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        Spacer()
        Text(wait)
          .font(.system(size: 90))
          .fontWeight(.bold)
          .foregroundColor(.black)
          .scaledToFit()
          .minimumScaleFactor(0.01)
          .lineLimit(1)
          .frame(maxWidth: .infinity, alignment: .center)
        Text(suffix)
          .font(.system(size: 30))
          .fontWeight(.semibold)
          .foregroundColor(.black)
          .scaledToFit()
          .minimumScaleFactor(0.01)
          .lineLimit(1)
          .frame(maxWidth: .infinity, alignment: .center)
        Spacer()
        Text(updated)
          .font(.system(size: 20))
          .fontWeight(.semibold)
          .foregroundColor(.black)
          .scaledToFit()
          .minimumScaleFactor(0.01)
          .lineLimit(1)
          .frame(maxWidth: .infinity, alignment: .center)
        Spacer()
      }
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .padding(20)
    .background(color)
    .opacity(opacity)
    .cornerRadius(10)
    .padding(5)
  }
  
}

struct MetricsView_Previews: PreviewProvider {
  static var previews: some View {
    MetricsView()
  }
}
