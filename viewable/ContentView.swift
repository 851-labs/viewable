//
//  ContentView.swift
//  viewable
//
//  Created by Alexandru Turcanu on 6/15/25.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      List {
        NavigationLink("Button Examples") {
          ButtonExamplesView()
        }
      }
      .navigationTitle("SwiftUI Examples")
    }
  }
}

#Preview {
  ContentView()
}
