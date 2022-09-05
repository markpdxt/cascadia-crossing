// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

import SwiftUI

struct AboutView: View {
  @Environment(\.dismiss) var dismiss
  
  var body: some View {
    VStack {
      Image("")
      Button("Dismiss") {
        dismiss()
      }
      .frame(maxWidth: .infinity, alignment: .topTrailing)
      .padding(EdgeInsets.init(top: 20, leading: 0, bottom: 0, trailing: 20))
      Text("CascadiaXing")
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .font(.title)
        .padding(EdgeInsets.init(top: 5, leading: 20, bottom: 0, trailing: 0))
      Text("Version \(UIApplication.appVersion ?? "_._._")")
        .font(.subheadline)
        .foregroundColor(Color(uiColor: .lightGray))
        .padding(EdgeInsets.init(top: 0, leading: 22, bottom: 20, trailing: 0))
        .frame(maxWidth: .infinity, alignment: .topLeading)
      Text("CascadiaXing was developed over a long weekend and meant for use by non-commerical users who cross British Columbia / Washington border. \n\nThe southbound data source is the US Customs and Border Protection border wait time feed the northbound data source is the WSDot border wait time feed. \n\nSouthbound lanes are updated about every 1 hour, while northbound lanes are updated about every 10 minutes. \n\nPoint Roberts northbound to Boundray Bay does not currently have a data source available, but we hope to add this crossing in the future.")
        .foregroundColor(Color(uiColor: .lightGray))
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(EdgeInsets.init(top: 0, leading: 20, bottom: 0, trailing: 20))
      Spacer()
      VStack {
        Text("©2022 PDX Technologies, LLC")
        Text("Made in Point Roberts, WA")
      }
      .foregroundColor(Color(uiColor: .lightGray))
      .frame(maxWidth: .infinity, alignment: .center)
    }
    .padding(EdgeInsets.init(top: 0, leading: 0, bottom: 10, trailing: 0))
    .background(Color(red: 0.17, green: 0.17, blue: 0.18))
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
