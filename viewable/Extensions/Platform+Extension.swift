//
//  Platform+Extension.swift
//  viewable
//
//  Platform detection utilities
//

import SwiftUI

// MARK: - View Extension

extension View {
  /// Returns the current platform name as a string.
  var platformName: String {
    #if os(macOS)
      return "macOS"
    #elseif os(iOS)
      return "iOS"
    #elseif os(watchOS)
      return "watchOS"
    #elseif os(tvOS)
      return "tvOS"
    #elseif os(visionOS)
      return "visionOS"
    #else
      return "this platform"
    #endif
  }
}
