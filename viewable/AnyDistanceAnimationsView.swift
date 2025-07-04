import SwiftUI

// MARK: - Main List View

struct AnyDistanceAnimationsView: View {
  var body: some View {
    List {
      NavigationLink("3-2-1 Go") {
        AnyDistanceCountdownShowcaseView()
      }
      NavigationLink("Metal Gradient Animation") {
        AnyDistanceMetalGradientShowcaseView()
      }
      NavigationLink("Neon Flickering Image") {
        AnyDistanceFlickeringImageShowcaseView()
      }
    }
    .navigationTitle("Any Distance")
  }
}

// MARK: - Previews

#Preview("Animations List") {
  NavigationStack {
    AnyDistanceAnimationsView()
  }
} 
