import SwiftUI

// MARK: - Shared view modifier (available on all platforms)

/// Provides the common navigation title and toolbar buttons for the neon flicker showcase.
struct AnyDistanceNeonFlickerInfoModifier: ViewModifier {
  @Environment(\.openURL) private var openURL
  
  private let articleURL = URL(string: "https://www.spottedinprod.com/blog/any-distance-goes-open-source")!
  private let sourceCodeURL = URL(string: "https://github.com/851-labs/viewable/blob/main/viewable/AnyDistance/AnyDistanceFlickeringImageView.swift")!

  func body(content: Content) -> some View {
    content
      .navigationTitle("Neon Flickering")
      .navigationSubtitle("AnyDistance")
      .toolbar {
        ToolbarItemGroup {
          Button {
            openURL(articleURL)
          } label: {
            Label("View article", systemImage: "book.pages")
          }
          Button {
            openURL(sourceCodeURL)
          } label: {
            Label("View source code", systemImage: "curlybraces")
          }
        }
      }
  }
}

extension View {
  /// Applies the Neon Flicker navigation title and toolbar buttons.
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
