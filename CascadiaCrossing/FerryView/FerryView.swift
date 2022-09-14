// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

import SwiftUI

struct FerryView: View {
  @ObservedObject private var viewModel = FerryViewModel()
  @State private var selectedOrigin = FerryPorts.tsawwassen
  @State private var selectedDestination = FerryPorts.swartzBay
  @State private var showingSheet = false
        
  var body: some View {
    VStack() {
      Text(selectedOrigin.rawValue)
        .font(.title)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .bottomLeading)
        .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 0))
      Text(selectedDestination.rawValue)
        .font(.title2)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .bottomLeading)
        .padding(EdgeInsets.init(top: 0, leading: 25, bottom: 0, trailing: 0))
      if let schedule = viewModel.feed?.schedule {
        TabView(selection: $selectedDestination) {
          port(schedule.tsa.swb.sailings)
            .tag(FerryPorts.swartzBay)
          port(schedule.tsa.sgi.sailings)
            .tag(FerryPorts.longHarbour)
          port(schedule.tsa.duk.sailings)
            .tag(FerryPorts.dukePoint)
        }
        .tabViewStyle(.page)
      } else {
        Spacer()
      }
      HStack {
        Button {
          switch selectedOrigin {
          case .tsawwassen:
            openMap(coordinates: Coordinates.tsawwassen)
          case .longHarbour:
            openMap(coordinates: Coordinates.longHarbour)
          case .dukePoint:
            openMap(coordinates: Coordinates.dukePoint)
          default:
            break
          }
        } label: {
          Image(systemName: "map.fill")
        }
        .padding(EdgeInsets.init(top: 10, leading: 25, bottom: 1, trailing: 0))
        .frame(maxWidth: .infinity, alignment: .leading)
        Button {
          viewModel.changeMode()
        } label: {
          Image(systemName: "car")
        }
        .padding(EdgeInsets.init(top: 10, leading: 0, bottom: 1, trailing: 0))
        .frame(maxWidth: .infinity, alignment: .center)
        Button {
          showingSheet.toggle()
        } label: {
          Image(systemName: "info.circle")
        }
        .sheet(isPresented: $showingSheet) {
          AboutView()
        }
        .padding(EdgeInsets.init(top: 10, leading: 0, bottom: 1, trailing: 25))
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
          HStack {
            Image(systemName: "car")
              .foregroundColor(.white)
              .scaleEffect(0.5)
              .frame(maxWidth: 25, alignment: .trailing)
            Image(systemName: "box.truck")
              .foregroundColor(.white)
              .scaleEffect(0.5)
              .frame(maxWidth: 25, alignment: .trailing)
            Text("\(item.fill)%")
              .frame(maxWidth: .infinity, alignment: .trailing)
              .foregroundColor(setColor(item.fill))
          }
        }
        .padding(EdgeInsets.init(top: 10, leading: 5, bottom: 10, trailing: 8))
        .font(.title)
        .fontWeight(.bold)
        .opacity(item == sailings[0] ? 1.0 : 0.7)
        .listRowBackground(Color(red: 0.17, green: 0.17, blue: 0.18))
      }
    }
    .scrollContentBackground(.hidden)
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
  static var previews: some View {
    FerryView()
  }
}
