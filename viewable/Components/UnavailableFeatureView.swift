//
//  UnavailableFeatureView.swift
//  viewable
//
//  A reusable view for displaying when a feature is unavailable on a platform.
//

import SwiftUI

struct UnavailableFeatureView: View {
  let feature: String

  var body: some View {
    ContentUnavailableView(
      "Not Available",
      systemImage: "pc",
      description: Text("\(feature) is not available on \(platformName)")
    )
  }
}

// MARK: - Previews

#Preview("Submit Label Example") {
  NavigationStack {
    UnavailableFeatureView(feature: "submitLabel(_:)")
      .navigationTitle("submitLabel(_:)")
      .navigationSubtitle("Sets the submit label for this view.")
  }
}

#Preview("Keyboard Type Example") {
  NavigationStack {
    UnavailableFeatureView(feature: "keyboardType(_:)")
      .navigationTitle("keyboardType(_:)")
      .navigationSubtitle("Sets the keyboard type for this view.")
  }
}
