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
        Section("Components") {
          NavigationLink("Buttons") {
            ButtonExamplesView()
          }
          NavigationLink("Sliders") {
            SliderExamplesView()
          }
          NavigationLink("Toggles") {
            ToggleExamplesView()
          }
          NavigationLink("Steppers") {
            StepperExamplesView()
          }
          NavigationLink("Color Pickers") {
            ColorPickerExamplesView()
          }
          NavigationLink("Lists") {
            ListExamplesView()
          }
          NavigationLink("Forms") {
            FormExamplesView()
          }
        }

        Section("Showcase") {
          NavigationLink("Any Distance") {
            AnyDistanceAnimationsView()
          }
        }
      }
      .navigationTitle("SwiftUI Examples")
    }
//    detail: {
//      ContentUnavailableView("Use sidebar navigation", systemImage: "sidebar.left")
//    }
  }
}

#Preview {
  ContentView()
}
