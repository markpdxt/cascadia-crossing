// Copyright (c) 2022 PDX Technologies, LLC. All rights reserved.

import SwiftUI
import Logging

extension TerminalsView {
  class TerminalsViewModel: ObservableObject {
    let logger = Logger(label: "TerminalsViewView+")
        
    @AppStorage(StorageName.selection.rawValue)
    var selection: String? {
      didSet {
        logger.info("StorageName.selection: \(String(describing: UserDefaults.standard.string(forKey: StorageName.selection.rawValue)))")
      }
    }
    
  }
}
