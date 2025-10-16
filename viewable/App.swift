//
//  viewableApp.swift
//  viewable
//
//  Created by Alexandru Turcanu on 6/15/25.
//

import SwiftData
import SwiftUI

@main
struct viewableApp: App {
  var body: some Scene {
    WindowGroup {
      AppRouter()
    }
    .commands {
      InspectorCommands()
      SidebarCommands()
    }
  }
}
