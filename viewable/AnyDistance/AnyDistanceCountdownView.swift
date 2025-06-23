import SwiftUI

/// Provides the common navigation title, toolbar info button, and info sheet
/// used in both the UIKit-powered and fallback showcase views for the Any
/// Distance 3-2-1-Go countdown.
struct AnyDistanceCountdownInfoModifier: ViewModifier {
  @State private var isPresented: Bool = false

  func body(content: Content) -> some View {
    content
      .navigationTitle("3-2-1 Go")
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
              Text("This is our classic countdown timer written in SwiftUI. It's a good example of how stacking lots of different SwiftUI modifiers (scaleEffect, opacity, blur) can let you create more complex animations.")
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
  /// Applies the 3-2-1-Go countdown navigation title, info toolbar button, and info sheet.
  func anyDistanceCountdownInfo() -> some View {
    modifier(AnyDistanceCountdownInfoModifier())
  }
}

#if canImport(UIKit)

import UIKit

// MARK: - Utility Extensions

// MARK: - Dark Blur (UIKit-backed) View

struct AnyDistanceDarkBlurView: UIViewRepresentable {
  func makeUIView(context: Context) -> UIVisualEffectView {
    UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
  }

  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// MARK: - AnyDistanceCountdownView

/// Prefixed Any Distance-style 3-2-1-Go countdown.
struct AnyDistanceCountdownView: View {
  private let impactGenerator = UIImpactFeedbackGenerator(style: .heavy)
  private let startGenerator = UINotificationFeedbackGenerator()

  @State private var animationStep: CGFloat = 4 // 4→3→2→1→0 (GO)
  @State private var animationTimer: Timer?
  @State private var isFinished = false

  @Binding var skip: Bool
  var finishedAction: () -> Void

  private func xOffset() -> CGFloat {
    let c = max(min(animationStep, 3), 0)
    return c > 0 ? 60 * (c - 1) - 10 : -90
  }

  private func startTimer() {
    animationTimer = Timer.scheduledTimer(withTimeInterval: 0.9, repeats: true) { _ in
      Task { @MainActor in
        guard animationStep >= 0 else { return }

        if animationStep == 0 {
          withAnimation(.easeIn(duration: 0.15)) { isFinished = true }
          finishedAction()
          animationTimer?.invalidate()
        }

        withAnimation(.easeInOut(duration: animationStep == 4 ? 0.3 : 0.4)) {
          animationStep -= 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          if animationStep < 4 && animationStep > 0 {
            impactGenerator.impactOccurred()
          } else if animationStep == 0 {
            startGenerator.notificationOccurred(.success)
          }
        }
      }
    }
  }

  var body: some View {
    VStack {
      ZStack {
        AnyDistanceDarkBlurView()

        HStack(spacing: 0) {
          Text("3").font(.system(size: 89, weight: .semibold)).frame(width: 60)
            .opacity(animationStep >= 3 ? 1 : 0.6)
            .scaleEffect(animationStep >= 3 ? 1 : 0.6)
          Text("2").font(.system(size: 89, weight: .semibold)).frame(width: 60)
            .opacity(animationStep == 2 ? 1 : 0.6)
            .scaleEffect(animationStep == 2 ? 1 : 0.6)
          Text("1").font(.system(size: 89, weight: .semibold)).frame(width: 60)
            .opacity(animationStep == 1 ? 1 : 0.6)
            .scaleEffect(animationStep == 1 ? 1 : 0.6)
          Text("GO").font(.system(size: 65, weight: .bold)).frame(width: 100)
            .opacity(animationStep == 0 ? 1 : 0.6)
            .scaleEffect(animationStep == 0 ? 1 : 0.6)
        }
        .foregroundStyle(Color.white)
        .offset(x: xOffset())
      }
      .mask {
        RoundedRectangle(cornerRadius: 65).frame(width: 130, height: 200)
      }
      .opacity(isFinished ? 0 : 1)
      .scaleEffect(isFinished ? 1.2 : 1)
      .blur(radius: isFinished ? 6 : 0)
      .opacity(animationStep < 4 ? 1 : 0)
      .scaleEffect(animationStep < 4 ? 1 : 0.8)
    }
    .onChange(of: skip) { newVal in
      if newVal {
        animationTimer?.invalidate()
        withAnimation(.easeIn(duration: 0.15)) { isFinished = true }
        finishedAction()
      }
    }
    .onAppear {
      guard animationStep == 4 else { return }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { startTimer() }
    }
  }
}

// MARK: - Showcase container

struct AnyDistanceCountdownShowcaseView: View {
  @State private var skip = false
  @State private var done = false

  var body: some View {
    VStack(spacing: 24) {
      AnyDistanceCountdownView(skip: $skip) { done = true }

      if done {
        Label("Start!", systemImage: "checkmark.circle.fill")
          .font(.title.bold())
          .foregroundStyle(.green)
          .transition(.move(edge: .bottom).combined(with: .opacity))
      }

      Button("Skip") { skip = true }
        .buttonStyle(.bordered)
        .opacity(done ? 0 : 1)
    }
    .animation(.easeInOut, value: done)
    .anyDistanceCountdownInfo()
  }
}

#else

struct AnyDistanceCountdownShowcaseView: View {
  var body: some View {
    ContentUnavailableView("3-2-1 countdown is unavailable on this platform", systemImage: "pc")
      .anyDistanceCountdownInfo()
  }
}

#endif

#Preview("AnyDistance Countdown (macOS)") {
  NavigationStack { AnyDistanceCountdownShowcaseView() }
}
