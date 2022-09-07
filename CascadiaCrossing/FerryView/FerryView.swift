// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

import SwiftUI

struct FerryView: View {
  @ObservedObject private var viewModel = FerryViewModel()
  @State private var selectedTab = FerryPorts.swartzBay
  @State private var showingSheet = false
  
  init() {
    UITableView.appearance().backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
    UITableViewCell.appearance().backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
  }

  var body: some View {
    VStack() {
      Text("Tsawwassen")
        .font(.title)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .bottomLeading)
        .padding(EdgeInsets.init(top: 20, leading: 20, bottom: 0, trailing: 0))
      Text(selectedTab.rawValue)
        .font(.title2)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .bottomLeading)
        .padding(EdgeInsets.init(top: 0, leading: 22, bottom: 0, trailing: 0))
      TabView(selection: $selectedTab) {
        port(viewModel.feed!.schedule.tsa.swb.sailings)
          .tag(FerryPorts.swartzBay)
        port(viewModel.feed!.schedule.tsa.sgi.sailings)
          .tag(FerryPorts.southernGulfIslands)
        port(viewModel.feed!.schedule.tsa.duk.sailings)
          .tag(FerryPorts.dukePoint)
      }
      .tabViewStyle(.page)
      .padding(EdgeInsets.init(top: -15, leading: 0, bottom: -25, trailing: 0))
      HStack {
        Button {
          switch selectedTab {
          case .tsawwassen:
            openMap(coordinates: Coordinates.tsawwassen)
          case .swartzBay:
            openMap(coordinates: Coordinates.tsawwassen)
          case .longHarbour:
            openMap(coordinates: Coordinates.tsawwassen)
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
      .background(Color(red: 0.11, green: 0.11, blue: 0.12))
    }
    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
  }

  private func port(_ sailings: [Sailing]) -> some View {
    List {
      ForEach(sailings, id: \.self) { item in
        HStack {
          Text("\(item.time)")
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.white)
          Text("\(item.carFill)%")
            .frame(maxWidth: .infinity, alignment: .trailing)
            .foregroundColor(setColor(item.carFill))
        }
        .padding(EdgeInsets.init(top: 10, leading: 5, bottom: 10, trailing: 8))
        .listRowBackground(Color(red: 0.17, green: 0.17, blue: 0.18))
        .font(.title)
        .opacity(1.0)
      }
    }
    .listStyle(.insetGrouped)
    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
  }
  
  private func setColor(_ percentage: Int) -> Color {
    switch percentage {
    case let x where x < 0:
      return .gray
    case let x where x <= 50:
      return .green
    case let x where x < 99:
      return.yellow
    case let x where x >= 100:
      return .red
    default:
      return .gray
    }
  }
  
}

struct FerryView_Previews: PreviewProvider {
  
  init() {
    UITableView.appearance().backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
    UITableViewCell.appearance().backgroundColor = UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
  }
  
  static var previews: some View {
    FerryView()
  }
}
