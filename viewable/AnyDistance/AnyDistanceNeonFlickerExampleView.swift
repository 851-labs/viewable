import SwiftUI

struct AnyDistanceNeonFlickerExampleView: View {
  var body: some View {
    VStack(spacing: 32) {
      AnyDistanceFlickeringImage(imageName: "madewithsoul")
        .frame(width: 250, height: 250)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .preferredColorScheme(.dark)
    .navigationTitle("Neon Flicker")
  }
}

#Preview("Neon Flicker") {
  NavigationStack { AnyDistanceNeonFlickerExampleView() }
} 
