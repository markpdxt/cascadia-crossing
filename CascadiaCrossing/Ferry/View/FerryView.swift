// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

import SwiftUI

struct FerryView: View {
  @ObservedObject private var viewModel = FerryViewModel()
  
  @AppStorage(StorageName.selection.rawValue)
  var selectedOrigin: String = FerryPorts.tsawwassen.rawValue

  @State private var selectedDestination: String = ""

  @State private var showingAboutSheet = false
  @State private var showingTerminalsSheet = false
  
  var body: some View {
    VStack() {
      HStack {
        Text(selectedOrigin.capitalized)
          .font(.system(size: 38))
          .foregroundColor(.white)
        Button {
          selectedDestination = ""
          showingTerminalsSheet.toggle()
        } label: {
          Image(systemName: "chevron.down")
            .fontWeight(.bold)
            .font(.system(size: 25))
        }
        .sheet(isPresented: $showingTerminalsSheet) {
          TerminalsView()
        }
        Spacer()
      }
      .padding(EdgeInsets.init(top: 10, leading: 20, bottom: 0, trailing: 0))

      HStack {
        Image(systemName: "arrow.right")
          .foregroundColor(.gray)
          .padding(EdgeInsets.init(top: 0, leading: 25, bottom: 0, trailing: 0))
        Text(selectedDestination.isEmpty ? destination(for: selectedOrigin).capitalized : selectedDestination.capitalized)
          .font(.title)
          .foregroundColor(.white)
          .frame(maxWidth: .infinity, alignment: .bottomLeading)
          .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0))
      }
      if let sailings = viewModel.sailings(for: selectedOrigin), sailings.count > 0 {
        TabView(selection: $selectedDestination) {
          ForEach(sailings, id: \.self) { sailing in
            port(sailing)
              .tag(sailing[0].vesselStatus)
          }
        }
        .tabViewStyle(.page)
      } else {
        Spacer()
      }
      HStack {
        Button {
          switch selectedOrigin {
          case FerryPorts.tsawwassen.rawValue:
            openMap(coordinates: Coordinates.tsawwassen)
          case FerryPorts.fulfordHarbour.rawValue:
            openMap(coordinates: Coordinates.longHarbour)
          case FerryPorts.dukePoint.rawValue:
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
          showingAboutSheet.toggle()
        } label: {
          Image(systemName: "info.circle")
        }
        .sheet(isPresented: $showingAboutSheet) {
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
  
  private func destination(for originPort: String) -> String {
    switch originPort {
    case FerryPorts.tsawwassen.rawValue:
      return FerryPorts.swartzBay.rawValue
    case FerryPorts.horseshoeBay.rawValue:
      return FerryPorts.departureBay.rawValue
    case FerryPorts.swartzBay.rawValue:
      return FerryPorts.tsawwassen.rawValue
    case FerryPorts.departureBay.rawValue:
      return FerryPorts.horseshoeBay.rawValue
    case FerryPorts.dukePoint.rawValue:
      return FerryPorts.tsawwassen.rawValue
    case FerryPorts.langdale.rawValue:
      return FerryPorts.horseshoeBay.rawValue
    default:
      return FerryPorts.swartzBay.rawValue
    }
  }
}

struct FerryView_Previews: PreviewProvider {
  static var previews: some View {
    FerryView()
  }
}
