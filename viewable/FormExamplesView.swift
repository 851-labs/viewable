//  FormExamplesView.swift
//  viewable
//
//  Created by Alexandru Turcanu on 6/17/25.
//

import SwiftUI

// MARK: - Supported Styles

/// All form styles showcased in the example view.
private enum FormStyleKind: String, CaseIterable, Identifiable {
  case automatic
  case grouped
  case columns

  var id: String { rawValue }

  /// Human-readable title.
  var title: String {
    switch self {
    case .automatic: return "Automatic"
    case .grouped: return "Grouped"
    case .columns: return "Columns"
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

// MARK: - Sample Form View

/// A stand-alone form that applies the provided style.
private struct SampleFormView: View {
  let kind: FormStyleKind

  // Sample state values to make the form interactive in previews
  @State private var name: String = ""
  @State private var email: String = ""
  @State private var receiveNotifications: Bool = true
  @State private var selectedTheme: String = "System"
  @State private var quantity: Int = 1
  @State private var selectedPlan: String = "Basic"
  @State private var volume: Double = 0.5

  private let themes = ["Light", "Dark", "System"]
  private let plans = ["Basic", "Pro", "Enterprise"]

  private var form: some View {
    Form {
      Section("Personal") {
        TextField("Name", text: $name)
        TextField("Email", text: $email)
      }

      Section("Preferences") {
        Toggle("Notifications", isOn: $receiveNotifications)

        Stepper("Quantity: \(quantity)", value: $quantity, in: 1 ... 10)

        Picker("Theme", selection: $selectedTheme) {
          ForEach(themes, id: \.self) { theme in
            Text(theme).tag(theme)
          }
        }
        .pickerStyle(.automatic)

        Picker("Plan", selection: $selectedPlan) {
          ForEach(plans, id: \.self) { plan in
            Text(plan).tag(plan)
          }
        }
        .pickerStyle(.segmented)

        #if os(macOS)
        Picker("Plan", selection: $selectedPlan) {
          ForEach(plans, id: \.self) { plan in
            Text(plan).tag(plan)
          }
        }
        .pickerStyle(.radioGroup)
        #endif
      }

      // Section demonstrating controls that use `Label` with SF Symbol icons
      Section("With Icons") {
        Toggle(isOn: $receiveNotifications) {
          Label("Notifications", systemImage: "bell")
        }

        Stepper(value: $quantity, in: 1 ... 10) {
          Label("Quantity: \(quantity)", systemImage: "number")
        }

        Picker(selection: $selectedTheme) {
          ForEach(themes, id: \.self) { theme in
            Text(theme).tag(theme)
          }
        } label: {
          Label("Theme", systemImage: "paintpalette")
        }
        .pickerStyle(.automatic)

        Picker(selection: $selectedPlan) {
          ForEach(plans, id: \.self) { plan in
            Text(plan).tag(plan)
          }
        } label: {
          Label("Plan", systemImage: "creditcard")
        }
        .pickerStyle(.segmented)

        #if os(macOS)
        Picker(selection: $selectedPlan) {
          ForEach(plans, id: \.self) { plan in
            Text(plan).tag(plan)
          }
        } label: {
          Label("Plan", systemImage: "creditcard")
        }
        .pickerStyle(.radioGroup)
        #endif
      }
    }
  }

  var body: some View {
    // Apply the chosen style – the switch keeps the generic `some View` type intact.
    Group {
      switch kind {
      case .automatic: form
      case .grouped: form.formStyle(.grouped)
      case .columns: form.formStyle(.columns)
      }
    }
    .navigationTitle(kind.title)
  }
}

// MARK: - Row Helper

/// Row displayed in the overview page; tapping it navigates to the sample form.
private struct FormStyleRow: View {
  let kind: FormStyleKind

  var body: some View {
    NavigationLink {
      SampleFormView(kind: kind)
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
      Form {
        // …
      }
      """
    default:
      return """
      Form {
        // …
      }
      .formStyle(.\(kind.rawValue))
      """
    }
  }
}

// MARK: - Main View

struct FormExamplesView: View {
  var body: some View {
    List {
      Section {
        ForEach(FormStyleKind.allCases) { kind in
          FormStyleRow(kind: kind)
        }
      } header: {
        HStack {
          Text("Styles")
          Spacer()
          Text(".formStyle()")
            .font(.system(.caption2, design: .monospaced))
        }
      }
    }
    .navigationTitle("Forms")
  }
}

// MARK: - Preview

#Preview("All Form Styles") {
  NavigationStack {
    FormExamplesView()
  }
}
