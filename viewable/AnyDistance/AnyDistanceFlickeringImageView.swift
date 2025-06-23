import SwiftUI

// MARK: - Shared view modifier (available on all platforms)

/// Provides the common navigation title, toolbar info button, and info sheet used in both
/// the UIKit-powered and fallback showcase views.
struct AnyDistanceNeonFlickerInfoModifier: ViewModifier {
  @State var isPresented: Bool = false

  func body(content: Content) -> some View {
    content
      .navigationTitle("Neon Flickering Image")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("Information", systemImage: "info.circle") {
            isPresented = true
          }
        }
      }
      .sheet(isPresented: $isPresented) {
        NavigationView {
          ScrollView {
            VStack(alignment: .leading, spacing: 16) {
              Text("I made this flickering image component to mimic the look of neon. The graphic is a copy of a real neon sign that hung outside Switchyards in downtown Atlanta, where we had an office.")
                .italic()
                .padding()
              Link("View full article", destination: URL(string: "https://www.spottedinprod.com/blog/any-distance-goes-open-source")!)
                .padding(.horizontal)
            }
          }
          .navigationTitle("Any Distance Goes Open Source")
          .navigationSubtitle("Spotted in Prod")
          .navigationBarTitleDisplayMode(.inline)
          .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
              Button("Close", systemImage: "xmark") {
                isPresented = false
              }
            }
          }
        }
        .presentationDetents([.medium])
      }
  }
}

extension View {
  /// Applies the Neon Flicker navigation title, info toolbar button and info sheet.
  func anyDistanceNeonFlickerInfo() -> some View {
    modifier(AnyDistanceNeonFlickerInfoModifier())
  }
}

#if canImport(UIKit)

import UIKit

final class AnyDistanceFlickeringUIImageView: UIImageView {
  // MARK: - Variables

  private var isLowered: Bool = false
  private var flickerCount: Int = 0

  // MARK: - Constants

  private let numFlickers: Int = 8

  // MARK: - Lifecycle

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
  }

  override convenience init(image: UIImage?) {
    self.init(frame: .zero)
    self.image = image
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    commonInit()
  }

  private func commonInit() {
    alpha = 0.0
  }

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    startAnimation()
  }

  // MARK: - Animation

  private func startAnimation() {
    startGlowing()
    continueFlickering()
  }

  private func startFloating() {
    let yTranslation: CGFloat = isLowered ? -7 : 7
    isLowered.toggle()
    UIView.animate(withDuration: 2.0, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState]) {
      self.transform = CGAffineTransform(translationX: 0, y: yTranslation)
    } completion: { [weak self] finished in
      if finished { self?.startFloating() }
    }
  }

  private func flicker() {
    alpha = alpha < 1.0 ? 1.0 : 0.2
    flickerCount += 1

    if alpha == 1.0 && flickerCount >= numFlickers {
      continueFlickering()
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
        self?.startGlowing()
      }
    } else {
      let delay = TimeInterval.random(in: 0.05...0.07) - (0.03 * Double(flickerCount) / Double(numFlickers))
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
        self?.flicker()
      }
    }
  }

  private func continueFlickering() {
    alpha = alpha < 1.0 ? 1.0 : 0.2

    let delay: TimeInterval = alpha < 1.0 ? .random(in: 0.01...0.03) : .random(in: 0.03...0.4)
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
      self?.continueFlickering()
    }
  }

  private func startGlowing(delay: TimeInterval = 0) {
    let duration = TimeInterval.random(in: 0.4...0.8)
    let newAlpha: CGFloat = alpha < 1.0 ? 1.0 : 0.8
    UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseInOut, .beginFromCurrentState]) {
      self.alpha = newAlpha
    } completion: { [weak self] finished in
      if finished { self?.startGlowing() }
    }
  }
}

// MARK: - SwiftUI Bridge

struct AnyDistanceFlickeringImage: UIViewRepresentable {
  public let imageName: String

  public init(imageName: String) {
    self.imageName = imageName
  }

  func makeUIView(context: Context) -> AnyDistanceFlickeringUIImageView {
    let uiImage = UIImage(named: imageName) ?? UIImage(systemName: "sparkles")
    let view = AnyDistanceFlickeringUIImageView(image: uiImage)
    view.contentMode = .scaleAspectFit
    return view
  }

  func updateUIView(_ uiView: AnyDistanceFlickeringUIImageView, context: Context) {
    // No dynamic updates needed.
  }
}

struct AnyDistanceFlickeringImageShowcaseView: View {
  var body: some View {
    VStack(spacing: 32) {
      AnyDistanceFlickeringImage(imageName: "madewithsoul")
        .frame(width: 250, height: 250)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .preferredColorScheme(.dark)
    .anyDistanceNeonFlickerInfo()
  }
}

#else

struct AnyDistanceFlickeringImageShowcaseView: View {
  var body: some View {
    ContentUnavailableView("Neon flicker effect is not supported on this platform", systemImage: "pc")
      .anyDistanceNeonFlickerInfo()
  }
}

#endif

#Preview("AnyDistance Flickering Image") {
  NavigationStack { AnyDistanceFlickeringImageShowcaseView() }
}
