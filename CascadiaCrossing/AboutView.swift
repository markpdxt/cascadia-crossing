// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

import SwiftUI

struct AboutView: View {
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    VStack {
      Button("Dismiss") {
        dismiss()
      }
      .frame(maxWidth: .infinity, alignment: .topTrailing)
      .padding(EdgeInsets.init(top: 20, leading: 0, bottom: 0, trailing: 20))
      Text("About CascadiaXing")
        .foregroundColor(.orange)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .font(.title)
        .padding(EdgeInsets.init(top: 5, leading: 20, bottom: 20, trailing: 0))
      Text("CascadiaXing was developed for folks who cross the British Columbia / Washington border frequently and includes most all ports of entry. \n\nData sources used include the US Customs and Border Protection border wait time feed as well as the WSDot border wait time feed. \n\nSouthbound lanes are updated every 1 hour, while northbound lanes are updated every 10 minutes. \n\nPoint Roberts northbound to Boundray Bay does not currently have a data source available, but we hope to add this crossing in the future.")
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 20))
      Spacer()
      VStack {
        Text("©2022 PDX Technologies, LLC")
        Text("Made in Point Roberts, WA")
      }
      .foregroundColor(.gray)
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(EdgeInsets.init(top: 20, leading: 20, bottom: 20, trailing: 20))
    }
    .background(.black)
  }
}

struct ContentView: View {
  @State private var showingSheet = false
  
  var body: some View {
    Button("Show Sheet") {
      showingSheet.toggle()
    }
    .sheet(isPresented: $showingSheet) {
      AboutView()
    }
  }
}
