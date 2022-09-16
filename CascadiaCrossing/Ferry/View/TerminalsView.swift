// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

import SwiftUI

struct TerminalsView: View {
  @ObservedObject private var viewModel = TerminalsViewModel()
  @Environment(\.dismiss) var dismiss
  
  let ferryPorts: [FerryPorts] = [.tsawwassen, .horseshoeBay, .swartzBay, .departureBay, .dukePoint, .langdale ]
  
  var body: some View {
    VStack {
      Button("Done") {
        dismiss()
      }
      .frame(maxWidth: .infinity, alignment: .topTrailing)
      .padding(EdgeInsets.init(top: 10, leading: 0, bottom: 0, trailing: 20))
      Text("Departure Terminal")
        .font(.system(size: 38))
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .bottomLeading)
        .padding(EdgeInsets.init(top: 10, leading: 20, bottom: 0, trailing: 0))
      List(selection: $viewModel.selection) {
        ForEach(ferryPorts, id: \.rawValue) { item in
          HStack {
            Text(item.rawValue.capitalized)
              .frame(maxWidth: .infinity, alignment: .leading)
            if item.rawValue == viewModel.selection {
              Image(systemName: "circle.fill")
                .foregroundColor(.accentColor)
                .frame(maxWidth: 20, alignment: .trailing)
            } else {
              Image(systemName: "circle")
                .foregroundColor(.accentColor)
                .frame(maxWidth: 20, alignment: .trailing)
            }
          }
        }
        .listRowBackground(Color(red: 0.17, green: 0.17, blue: 0.18))
        .font(.title)
        .foregroundColor(.white)
        .padding(EdgeInsets.init(top: 3, leading: 0, bottom: 3, trailing: 0))
      }
      .scrollContentBackground(.hidden)
      .background(Color(red: 0.11, green: 0.11, blue: 0.12))
    }
    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
  }
}

struct TerminalsView_Previews: PreviewProvider {
  static var previews: some View {
    TerminalsView()
  }
}

