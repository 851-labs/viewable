//
//  Clipboard+Extension.swift
//  viewable
//
//  Cross-platform clipboard functionality
//

import SwiftUI
#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - Clipboard Protocol

protocol ClipboardWritable {
  func copyToClipboard()
}

// MARK: - String Extension

extension String: ClipboardWritable {
  func copyToClipboard() {
    Clipboard.copy(self)
  }
}

// MARK: - Clipboard Manager

enum Clipboard {
  static func copy(_ text: String) {
    #if os(iOS)
    UIPasteboard.general.string = text
    #elseif os(macOS)
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(text, forType: .string)
    #endif
  }

  static var text: String? {
    #if os(iOS)
    return UIPasteboard.general.string
    #elseif os(macOS)
    return NSPasteboard.general.string(forType: .string)
    #endif
  }

  static func clear() {
    #if os(iOS)
    UIPasteboard.general.string = ""
    #elseif os(macOS)
    NSPasteboard.general.clearContents()
    #endif
  }
}
