//
//  ButtonExamplesView.swift
//  viewable
//
//  Created by Alexandru Turcanu on 6/15/25.
//

import SwiftUI

// MARK: - Button Example Components

struct ButtonExample: View {
  let title: String
  let button: AnyView
  let code: String
  let fullCode: String?
  
  init(title: String, button: AnyView, code: String, fullCode: String? = nil) {
    self.title = title
    self.button = button
    self.code = code
    self.fullCode = fullCode
  }
  
  var body: some View {
    HStack {
      button
      Spacer()
      Text(code)
        .font(.system(.caption, design: .monospaced))
        .foregroundStyle(.secondary)
    }
    .contextMenu {
      Button("Copy Code") {
        UIPasteboard.general.string = fullCode ?? generateDefaultCode()
      }
    }
  }
  
  private func generateDefaultCode() -> String {
    return """
Button("Button") {
  // Action here
}
\(code == ".buttonStyle(.automatic)" ? "" : code)
"""
  }
}

// MARK: - Main View

struct ButtonExamplesView: View {
  var body: some View {
    List {
      Section("Basic Button Styles") {
        ButtonExample(
          title: "Default Button",
          button: AnyView(Button("Button") { /* Action here */ }),
          code: ".buttonStyle(.automatic)"
        )
        
        ButtonExample(
          title: "Bordered Button",
          button: AnyView(Button("Button") { /* Action here */ }.buttonStyle(.bordered)),
          code: ".buttonStyle(.bordered)"
        )
        
        ButtonExample(
          title: "Bordered Prominent",
          button: AnyView(Button("Button") { /* Action here */ }.buttonStyle(.borderedProminent)),
          code: ".buttonStyle(.borderedProminent)"
        )
        
        ButtonExample(
          title: "Plain Button",
          button: AnyView(Button("Button") { /* Action here */ }.buttonStyle(.plain)),
          code: ".buttonStyle(.plain)"
        )
      }
      
      Section("iOS 26 Liquid Glass Style") {
        ButtonExample(
          title: "Glass Button",
          button: AnyView(Button("Button") { /* Action here */ }.buttonStyle(.glass)),
          code: ".buttonStyle(.glass)"
        )
        
        ButtonExample(
          title: "Glass Destructive",
          button: AnyView(Button("Button") { /* Action here */ }.buttonStyle(.glass).foregroundStyle(.red)),
          code: ".buttonStyle(.glass)"
        )
      }
      
      Section("Button Sizes") {
        ButtonExample(
          title: "Large Button",
          button: AnyView(Button("Button") { /* Action here */ }.buttonStyle(.borderedProminent).controlSize(.large)),
          code: ".controlSize(.large)",
          fullCode: """
Button("Button") {
  // Action here
}
.buttonStyle(.borderedProminent)
.controlSize(.large)
"""
        )
        
        ButtonExample(
          title: "Regular Button",
          button: AnyView(Button("Button") { /* Action here */ }.buttonStyle(.borderedProminent).controlSize(.regular)),
          code: ".controlSize(.regular)",
          fullCode: """
Button("Button") {
  // Action here
}
.buttonStyle(.borderedProminent)
.controlSize(.regular)
"""
        )
        
        ButtonExample(
          title: "Small Button",
          button: AnyView(Button("Button") { /* Action here */ }.buttonStyle(.borderedProminent).controlSize(.small)),
          code: ".controlSize(.small)",
          fullCode: """
Button("Button") {
  // Action here
}
.buttonStyle(.borderedProminent)
.controlSize(.small)
"""
        )
        
        ButtonExample(
          title: "Mini Button",
          button: AnyView(Button("Button") { /* Action here */ }.buttonStyle(.borderedProminent).controlSize(.mini)),
          code: ".controlSize(.mini)",
          fullCode: """
Button("Button") {
  // Action here
}
.buttonStyle(.borderedProminent)
.controlSize(.mini)
"""
        )
      }
      
      Section("Button with Icons") {
        ButtonExample(
          title: "Label Button",
          button: AnyView(Button { /* Action here */ } label: { Label("Button", systemImage: "plus") }.buttonStyle(.borderedProminent)),
          code: "Label(\"Button\", systemImage: \"plus\")",
          fullCode: """
Button {
  // Action here
} label: {
  Label("Button", systemImage: "plus")
}
.buttonStyle(.borderedProminent)
"""
        )
        
        ButtonExample(
          title: "Image Button",
          button: AnyView(Button { /* Action here */ } label: { HStack { Image(systemName: "heart.fill"); Text("Button") } }.buttonStyle(.bordered)),
          code: "Image(systemName: \"heart.fill\")",
          fullCode: """
Button {
  // Action here
} label: {
  HStack {
    Image(systemName: "heart.fill")
    Text("Button")
  }
}
.buttonStyle(.bordered)
"""
        )
        
        ButtonExample(
          title: "Icon Only Button",
          button: AnyView(Button { /* Action here */ } label: { Image(systemName: "star.fill") }.buttonStyle(.borderedProminent)),
          code: "Image(systemName: \"star.fill\")",
          fullCode: """
Button {
  // Action here
} label: {
  Image(systemName: "star.fill")
}
.buttonStyle(.borderedProminent)
"""
        )
      }
      
      Section("Disabled States") {
        ButtonExample(
          title: "Disabled Default",
          button: AnyView(Button("Button") { /* Action here */ }.disabled(true)),
          code: ".disabled(true)"
        )
        
        ButtonExample(
          title: "Disabled Bordered",
          button: AnyView(Button("Button") { /* Action here */ }.buttonStyle(.bordered).disabled(true)),
          code: ".disabled(true)",
          fullCode: """
Button("Button") {
  // Action here
}
.buttonStyle(.bordered)
.disabled(true)
"""
        )
        
        ButtonExample(
          title: "Disabled Prominent",
          button: AnyView(Button("Button") { /* Action here */ }.buttonStyle(.borderedProminent).disabled(true)),
          code: ".disabled(true)",
          fullCode: """
Button("Button") {
  // Action here
}
.buttonStyle(.borderedProminent)
.disabled(true)
"""
        )
      }
      
      Section("Destructive Buttons") {
        ButtonExample(
          title: "Destructive Default",
          button: AnyView(Button("Button", role: .destructive) { /* Action here */ }),
          code: "role: .destructive",
          fullCode: """
Button("Button", role: .destructive) {
  // Action here
}
"""
        )
        
        ButtonExample(
          title: "Destructive Bordered",
          button: AnyView(Button("Button", role: .destructive) { /* Action here */ }.buttonStyle(.bordered)),
          code: "role: .destructive",
          fullCode: """
Button("Button", role: .destructive) {
  // Action here
}
.buttonStyle(.bordered)
"""
        )
        
        ButtonExample(
          title: "Destructive Prominent",
          button: AnyView(Button("Button", role: .destructive) { /* Action here */ }.buttonStyle(.borderedProminent)),
          code: "role: .destructive",
          fullCode: """
Button("Button", role: .destructive) {
  // Action here
}
.buttonStyle(.borderedProminent)
"""
        )
      }
      
      Section("Custom Styled Buttons") {
        ButtonExample(
          title: "Gradient Button",
          button: AnyView(
            Button("Button") { /* Action here */ }
              .foregroundStyle(.white)
              .padding()
              .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
              .clipShape(RoundedRectangle(cornerRadius: 12))
          ),
          code: ".background(LinearGradient(...))",
          fullCode: """
Button("Button") {
  // Action here
}
.foregroundStyle(.white)
.padding()
.background(
  LinearGradient(
    colors: [.blue, .purple],
    startPoint: .leading,
    endPoint: .trailing
  )
)
.clipShape(RoundedRectangle(cornerRadius: 12))
"""
        )
        
        ButtonExample(
          title: "Material Button",
          button: AnyView(
            Button("Button") { /* Action here */ }
              .foregroundStyle(.primary)
              .padding()
              .background(.ultraThinMaterial)
              .clipShape(RoundedRectangle(cornerRadius: 12))
              .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
          ),
          code: ".background(.ultraThinMaterial)",
          fullCode: """
Button("Button") {
  // Action here
}
.foregroundStyle(.primary)
.padding()
.background(.ultraThinMaterial)
.clipShape(RoundedRectangle(cornerRadius: 12))
.shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
"""
        )
        
        ButtonExample(
          title: "Capsule Button",
          button: AnyView(
            Button("Button") { /* Action here */ }
              .foregroundStyle(.white)
              .padding(.horizontal, 24)
              .padding(.vertical, 12)
              .background(.mint)
              .clipShape(Capsule())
          ),
          code: ".clipShape(Capsule())",
          fullCode: """
Button("Button") {
  // Action here
}
.foregroundStyle(.white)
.padding(.horizontal, 24)
.padding(.vertical, 12)
.background(.mint)
.clipShape(Capsule())
"""
        )
      }
    }
    .navigationTitle("Button Examples")
    .navigationBarTitleDisplayMode(.large)
  }
}

// MARK: - Previews

#Preview("All Examples") {
  NavigationStack {
    ButtonExamplesView()
  }
}