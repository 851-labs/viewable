//  ListExamplesView.swift
//  viewable
//
//  Created by Alexandru Turcanu on 6/17/25.
//

import SwiftUI

// MARK: - Supported Styles

/// All list styles showcased in the example view.
private enum ListStyleKind: String, CaseIterable, Identifiable {
  case automatic
  case plain
#if !os(macOS)
  case grouped
#endif
  case inset
#if !os(macOS)
  case insetGrouped
#endif
  case sidebar
  
  var id: String { rawValue }
  
  /// Human-readable title.
  var title: String {
    switch self {
    case .automatic:      return "Automatic"
    case .plain:          return "Plain"
#if !os(macOS)
    case .grouped:        return "Grouped"
#endif
    case .inset:          return "Inset"
#if !os(macOS)
    case .insetGrouped:   return "Inset Grouped"
#endif
    case .sidebar:        return "Sidebar"
    }
  }
  
  /// Code snippet for the style modifier.
  var codeSnippet: String {
    switch self {
    default:
      return "\(rawValue)"
    }
  }
}

// MARK: - Sample List View

/// A stand-alone list that applies the provided style.
private struct SampleListView: View {
  let kind: ListStyleKind
  
  private var list: some View {
    List {
      Section("Fruits") {
        Text("Apple")
        Text("Banana")
        Text("Orange")
        Text("Grapes")
        Text("Strawberry")
      }
      
      Section("Vegetables") {
        Label("Carrot", systemImage: "carrot")
        Label("Broccoli", systemImage: "tree")
        Label("Spinach", systemImage: "leaf")
        Label("Tomato", systemImage: "t.circle")
        Label("Cucumber", systemImage: "c.circle")
      }
      
      // Section with a label header (text + icon)
      Section {
        Label("Milk", systemImage: "drop")
        Label("Cheese", systemImage: "birthday.cake")
        Label("Yogurt", systemImage: "cup.and.saucer")
      } header: {
        Text("Dairy")
      } footer: {
        Text("Calcium-rich dairy products.")
      }
      
      // Another label-based section to increase length
      Section {
        Label("Water", systemImage: "drop")
        Label("Tea", systemImage: "mug")
        Label("Coffee", systemImage: "cup.and.saucer.fill")
        Label("Juice", systemImage: "takeoutbag.and.cup.and.straw")
        Label("Soda", systemImage: "s.circle")
      } header: {
        Label("Drinks", systemImage: "cup.and.saucer")
      } footer: {
        Text("Stay hydrated with your favorite drinks.")
      }
    }
  }
  
  var body: some View {
    // Apply the chosen style – the switch keeps the generic `some View` type intact.
    Group {
      switch kind {
      case .automatic:      list
      case .plain:          list.listStyle(.plain)
#if !os(macOS)
      case .grouped:        list.listStyle(.grouped)
#endif
      case .inset:          list.listStyle(.inset)
#if !os(macOS)
      case .insetGrouped:   list.listStyle(.insetGrouped)
#endif
      case .sidebar:        list.listStyle(.sidebar)
      }
    }
    .navigationTitle(kind.title)
  }
}

// MARK: - Row Helper

/// Row displayed in the overview page; tapping it navigates to the sample list.
private struct ListStyleRow: View {
  let kind: ListStyleKind
  
  var body: some View {
    NavigationLink {
      SampleListView(kind: kind)
    } label: {
      HStack {
        Text(kind.title)
        Spacer()
        Text(kind.codeSnippet)
          .font(.system(.caption2, design: .monospaced))
          .foregroundStyle(.secondary)
      }
    }
    .contextMenu {
      Button("Copy Code") {
        generateCodeSnippet().copyToClipboard()
      }
    }
  }
  
  private func generateCodeSnippet() -> String {
    switch kind {
    case .automatic:
      return """
List {
  // …
}
"""
#if !os(macOS)
    case .grouped, .insetGrouped:
      fallthrough
#endif
    default:
      return """
List {
  // …
}
.listStyle(.\(kind.rawValue))
"""
    }
  }
}

// MARK: - Main View

struct ListExamplesView: View {
  var body: some View {
    List {
      Section {
        ForEach(ListStyleKind.allCases) { kind in
          ListStyleRow(kind: kind)
        }
      } header: {
        HStack {
          Text("Styles")
          Spacer()
          Text(".listStyle()")
            .font(.system(.caption2, design: .monospaced))
        }
      }
    }
    .navigationTitle("Lists")
  }
}

// MARK: - Preview

#Preview("All List Styles") {
  NavigationStack {
    ListExamplesView()
  }
} 
