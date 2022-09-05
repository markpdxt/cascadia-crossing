// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

import SwiftUI

struct MetricsView: View {
  @ObservedObject private var viewModel = MetricsViewModel()
  @State private var selectedTab = Crossings.pointRoberts
  @State private var showingSheet = false

  var body: some View {
    VStack() {
      TabView(selection: $selectedTab) {
        crossing(north: viewModel.pointRoberts, south: viewModel.boundaryBay)
          .tag(Crossings.pointRoberts)
        crossing(north: viewModel.peaceArch, south: viewModel.douglas)
          .tag(Crossings.peaceArch)
        crossing(north: viewModel.pacificHwyBlaine, south: viewModel.pacificHwySurrey)
          .tag(Crossings.pacificHwyBlaine)
        crossing(north: viewModel.lynden, south: viewModel.aldergrove)
          .tag(Crossings.lynden)
        crossing(north: viewModel.sumas, south: viewModel.abbotsford)
          .tag(Crossings.sumas)
      }
      .tabViewStyle(.page)
      .padding(EdgeInsets.init(top: 0, leading: 0, bottom: -25, trailing: 0))
      HStack {
        Button {
          switch selectedTab {
          case .pointRoberts:
            viewModel.openMap(coordinates: Coordinates.pointRoberts)
          case .peaceArch:
            viewModel.openMap(coordinates: Coordinates.peaceArch)
          case .pacificHwyBlaine:
            viewModel.openMap(coordinates: Coordinates.pacificHwy)
          case .lynden:
            viewModel.openMap(coordinates: Coordinates.Lynden)
          case .sumas:
            viewModel.openMap(coordinates: Coordinates.sumas)
          default:
            break
          }
        } label: {
          Image(systemName: "map.fill")
        }
        .padding(EdgeInsets.init(top: -18, leading: 25, bottom: 0, trailing: 0))
        .frame(maxWidth: .infinity, alignment: .leading)
        Button {
          showingSheet.toggle()
        } label: {
          Image(systemName: "info.circle")
        }
        .sheet(isPresented: $showingSheet) {
          AboutView()
        }
        .padding(EdgeInsets.init(top: -18, leading: 0, bottom: 0, trailing: 25))
        .frame(maxWidth: .infinity, alignment: .trailing)
      }
    }
    .background(.black)
  }

  private func crossing(north: Crossing, south: Crossing) -> some View {
    VStack() {
      HStack {
        panel(lane: NSLocalizedString("Standard", comment: ""),
              laneCount: NSLocalizedString("Lanes \(north.standardLanesOpen)", comment: ""),
              wait: north.standardLanesColor == .gray ? "--" : "\(north.stanadrdLanesDelay)",
              suffix: north.standardLanesSuffix,
              updated: north.standardLanesUpdated,
              opacity: north.standardLanesSuffix == "no data" ? 0.85 : 1.0,
              direction: "to WA",
              color: north.standardLanesColor)
        panel(lane: NSLocalizedString("Nexus", comment: ""),
              laneCount: NSLocalizedString("Lanes \(north.nexusSentriLanesOpen)", comment: ""),
              wait: north.nexusSentriLanesColor == .gray ? "--" : "\(north.nexusSentriLanesDelay)",
              suffix: north.nexusSentriLanesSuffix,
              updated: north.nexusSentriLanesUpdated == "" ? north.standardLanesUpdated : north.nexusSentriLanesUpdated,
              opacity: north.nexusSentriLanesSuffix == "no data" ? 0.85 : 1.0,
              direction: "to WA",
              color: north.nexusSentriLanesColor)
      }
      VStack {
        Text(south.crossingName.rawValue)
          .font(.system(size: 30))
          .fontWeight(.regular)
          .foregroundColor(.white)
          .scaledToFit()
          .minimumScaleFactor(0.01)
          .lineLimit(1)
        Divider()
          .frame(height: 2)
          .background(.white)
        Text(north.crossingName.rawValue)
          .font(.system(size: 30))
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
              direction: " to BC",
              color: south.standardLanesColor)
        panel(lane: NSLocalizedString("Nexus", comment: ""),
              wait: south.nexusSentriLanesColor == .gray ? "--" : "\(south.nexusSentriLanesDelay)",
              suffix: south.nexusSentriLanesSuffix,
              updated: south.nexusSentriLanesUpdated,
              opacity: south.nexusSentriLanesSuffix == "no data" ? 0.85 : 1.0,
              direction: " to BC",
              color: south.nexusSentriLanesColor)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .padding(EdgeInsets.init(top: 10, leading: 10, bottom: 35, trailing: 10))
  }
  
  private func panel(lane: String = "",
             laneCount: String = "",
             wait: String = "",
             suffix: String = "",
             updated: String = "",
             opacity: Double = 1.0,
             direction: String = "",
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
        Text("\(suffix)")
          .font(.system(size: 30))
          .fontWeight(.semibold)
          .foregroundColor(.black)
          .scaledToFit()
          .minimumScaleFactor(0.01)
          .lineLimit(1)
          .frame(maxWidth: .infinity, alignment: .center)
        Spacer()
        Text("\(updated)\(direction)")
          .font(.system(size: 20))
          .fontWeight(.semibold)
          .foregroundColor(.black)
          .scaledToFit()
          .minimumScaleFactor(0.01)
          .lineLimit(1)
          .frame(maxWidth: .infinity, alignment: .center)
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
