//
//  ScrollEdgeEffectView.swift
//  viewable
//
//  Created by Alexandru Turcanu on 6/15/25.
//

import SwiftUI

// MARK: - Scroll Edge Effect Example

struct ScrollEdgeEffectExample: View {
  let title: String
  let style: ScrollEdgeEffectStyle
  let edge: VerticalEdge

  private var styleName: String {
    style == .soft ? "soft" : "hard"
  }

  private var edgeName: String {
    edge == .top ? "top" : "bottom"
  }

  var body: some View {
    Section {
      sampleList
        .frame(height: 300)
        .contextMenu {
          Button("Copy Code") {
            generateCodeSnippet().copyToClipboard()
          }
        }
    } header: {
      Text(title)
    } footer: {
      Text(".scrollEdgeEffectStyle(.\(styleName), for: .\(edgeName))")
        .font(.system(.caption2, design: .monospaced))
        .foregroundStyle(.secondary)
    }
  }

  private var sampleList: some View {
    List {
      ForEach(0..<20, id: \.self) { index in
        Text("Item \(index)")
      }
    }
    .scrollEdgeEffectStyle(style, for: edge)
  }

  private func generateCodeSnippet() -> String {
    return """
      List {
        ForEach(0..<20, id: \\.self) { index in
          Text("Item \\(index)")
        }
      }
      .scrollEdgeEffectStyle(.\(styleName), for: .\(edgeName))
      """
  }
}

// MARK: - Main View

struct ScrollEdgeEffectView: View {
  var body: some View {
    #if os(iOS) || os(tvOS) || os(visionOS)
      scrollEdgeEffectForm
    #else
      unsupportedPlatformView
    #endif
  }

  #if os(iOS) || os(tvOS) || os(visionOS)
    private var scrollEdgeEffectForm: some View {
      Form {
        ScrollEdgeEffectExample(
          title: "Soft Top",
          style: .soft,
          edge: .top
        )

        ScrollEdgeEffectExample(
          title: "Hard Top",
          style: .hard,
          edge: .top
        )

        ScrollEdgeEffectExample(
          title: "Soft Bottom",
          style: .soft,
          edge: .bottom
        )

        ScrollEdgeEffectExample(
          title: "Hard Bottom",
          style: .hard,
          edge: .bottom
        )
      }
      .navigationTitle("Scroll Edge Effects")
      .formStyle(.grouped)
    }
  #endif

  private var unsupportedPlatformView: some View {
    ContentUnavailableView(
      "Not Available",
      systemImage: "scroll",
      description: Text("Scroll edge effects are not available on \(platformName)")
    )
    .navigationTitle("Scroll Edge Effects")
  }
}

// MARK: - Previews

#Preview("All Scroll Edge Effects") {
  NavigationStack {
    ScrollEdgeEffectView()
  }
}
