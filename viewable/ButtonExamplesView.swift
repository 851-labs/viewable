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
        .font(.system(.caption2, design: .monospaced))
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
  
}
\(code == ".buttonStyle(.automatic)" ? "" : code)
"""
  }
}

// MARK: - Main View

struct ButtonExamplesView: View {
  var body: some View {
    List {
      Section {
        ButtonExample(
          title: "Automatic Button",
          button: AnyView(Button("Button") { }),
          code: "automatic"
        )
        
        ButtonExample(
          title: "Borderless Button",
          button: AnyView(Button("Button") {  }.buttonStyle(.borderless)),
          code: "borderless"
        )
        
        ButtonExample(
          title: "Plain Button",
          button: AnyView(Button("Button") {  }.buttonStyle(.plain)),
          code: "plain"
        )
        
        ButtonExample(
          title: "Bordered Button",
          button: AnyView(Button("Button") {  }.buttonStyle(.bordered)),
          code: "bordered"
        )
        
        ButtonExample(
          title: "Bordered Prominent",
          button: AnyView(Button("Button") {  }.buttonStyle(.borderedProminent)),
          code: "borderedProminent"
        )
        
        ButtonExample(
          title: "Glass Button",
          button: AnyView(Button("Button") {  }.buttonStyle(.glass)),
          code: "glass"
        )
      } header: {
        HStack {
          Text("Button Styles")
          Spacer()
          Text(".buttonStyle()")
            .font(.system(.caption2, design: .monospaced))
        }
      }
      
      Section {
        ButtonExample(
          title: "Large Button",
          button: AnyView(Button("Button") {  }.buttonStyle(.borderedProminent).controlSize(.large)),
          code: "large",
          fullCode: """
Button("Large") {
  
}
.buttonStyle(.borderedProminent)
.controlSize(.large)
"""
        )
        
        ButtonExample(
          title: "Regular Button",
          button: AnyView(Button("Button") {  }.buttonStyle(.borderedProminent).controlSize(.regular)),
          code: "regular",
          fullCode: """
Button("Regular") {
  
}
.buttonStyle(.borderedProminent)
.controlSize(.regular)
"""
        )
        
        ButtonExample(
          title: "Small Button",
          button: AnyView(Button("Button") {  }.buttonStyle(.borderedProminent).controlSize(.small)),
          code: "small",
          fullCode: """
Button("Small") {
  
}
.buttonStyle(.borderedProminent)
.controlSize(.small)
"""
        )
        
        ButtonExample(
          title: "Mini Button",
          button: AnyView(Button("Button") {  }.buttonStyle(.borderedProminent).controlSize(.mini)),
          code: "mini",
          fullCode: """
Button("Mini") {
  
}
.buttonStyle(.borderedProminent)
.controlSize(.mini)
"""
        )
      } header: {
        HStack {
          Text("Button Sizes")
          Spacer()
          Text(".controlSize()")
            .font(.system(.caption2, design: .monospaced))
        }
      }
      
      Section {
        ButtonExample(
          title: "Label Button",
          button: AnyView(Button {  } label: { Label("Add Item", systemImage: "plus") }.buttonStyle(.borderedProminent)),
          code: "Label(\"Add Item\", systemImage: \"plus\")",
          fullCode: """
Button {
  
} label: {
  Label("Add Item", systemImage: "plus")
}
.buttonStyle(.borderedProminent)
"""
        )
        
        ButtonExample(
          title: "Image Button",
          button: AnyView(Button {  } label: { HStack { Image(systemName: "heart.fill"); Text("Favorite") } }.buttonStyle(.bordered)),
          code: "Image(systemName: \"heart.fill\")",
          fullCode: """
Button {
  
} label: {
  HStack {
    Image(systemName: "heart.fill")
    Text("Favorite")
  }
}
.buttonStyle(.bordered)
"""
        )
        
        ButtonExample(
          title: "Icon Only Button",
          button: AnyView(Button {  } label: { Image(systemName: "star.fill") }.buttonStyle(.borderedProminent)),
          code: "Image(systemName: \"star.fill\")",
          fullCode: """
Button {
  
} label: {
  Image(systemName: "star.fill")
}
.buttonStyle(.borderedProminent)
"""
        )
      } header: {
        HStack {
          Text("Button with Icons")
          Spacer()
        }
      }
      
      Section {
        ButtonExample(
          title: "Disabled Automatic",
          button: AnyView(Button("Button") {  }.disabled(true)),
          code: "automatic"
        )
        
        ButtonExample(
          title: "Disabled Borderless",
          button: AnyView(Button("Button") {  }.buttonStyle(.borderless).disabled(true)),
          code: "borderless",
          fullCode: """
Button("Button") {
  
}
.buttonStyle(.borderless)
.disabled(true)
"""
        )
        
        ButtonExample(
          title: "Disabled Plain",
          button: AnyView(Button("Button") {  }.buttonStyle(.plain).disabled(true)),
          code: "plain",
          fullCode: """
Button("Button") {
  
}
.buttonStyle(.plain)
.disabled(true)
"""
        )
        
        ButtonExample(
          title: "Disabled Bordered",
          button: AnyView(Button("Button") {  }.buttonStyle(.bordered).disabled(true)),
          code: "bordered",
          fullCode: """
Button("Button") {
  
}
.buttonStyle(.bordered)
.disabled(true)
"""
        )
        
        ButtonExample(
          title: "Disabled Prominent",
          button: AnyView(Button("Button") {  }.buttonStyle(.borderedProminent).disabled(true)),
          code: "borderedProminent",
          fullCode: """
Button("Button") {
  
}
.buttonStyle(.borderedProminent)
.disabled(true)
"""
        )
        
        ButtonExample(
          title: "Disabled Glass",
          button: AnyView(Button("Button") {  }.buttonStyle(.glass).disabled(true)),
          code: "glass",
          fullCode: """
Button("Button") {
  
}
.buttonStyle(.glass)
.disabled(true)
"""
        )
      } header: {
        HStack {
          Text("Disabled States")
          Spacer()
          Text(".disabled(true)")
            .font(.system(.caption2, design: .monospaced))
        }
      }
      
      Section {
        ButtonExample(
          title: "Destructive Automatic",
          button: AnyView(Button("Button", role: .destructive) {  }),
          code: "automatic",
          fullCode: """
Button("Button", role: .destructive) {
  
}
"""
        )
        
        ButtonExample(
          title: "Destructive Borderless",
          button: AnyView(Button("Button", role: .destructive) {  }.buttonStyle(.borderless)),
          code: "borderless",
          fullCode: """
Button("Button", role: .destructive) {
  
}
.buttonStyle(.borderless)
"""
        )
        
        ButtonExample(
          title: "Destructive Plain",
          button: AnyView(Button("Button", role: .destructive) {  }.buttonStyle(.plain)),
          code: "plain",
          fullCode: """
Button("Button", role: .destructive) {
  
}
.buttonStyle(.plain)
"""
        )
        
        ButtonExample(
          title: "Destructive Bordered",
          button: AnyView(Button("Button", role: .destructive) {  }.buttonStyle(.bordered)),
          code: "bordered",
          fullCode: """
Button("Button", role: .destructive) {
  
}
.buttonStyle(.bordered)
"""
        )
        
        ButtonExample(
          title: "Destructive Prominent",
          button: AnyView(Button("Button", role: .destructive) {  }.buttonStyle(.borderedProminent)),
          code: "borderedProminent",
          fullCode: """
Button("Button", role: .destructive) {
  
}
.buttonStyle(.borderedProminent)
"""
        )
        
        ButtonExample(
          title: "Destructive Glass",
          button: AnyView(Button("Button", role: .destructive) {  }.buttonStyle(.glass)),
          code: "glass",
          fullCode: """
Button("Button", role: .destructive) {
  
}
.buttonStyle(.glass)
"""
        )
      } header: {
        HStack {
          Text("Destructive Buttons")
          Spacer()
        }
      }
      
      Section {
        ButtonExample(
          title: "Gradient Button",
          button: AnyView(
            Button("Gradient") {  }
              .foregroundStyle(.white)
              .padding()
              .background(LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing))
              .clipShape(RoundedRectangle(cornerRadius: 12))
          ),
          code: ".background(LinearGradient(...))",
          fullCode: """
Button("Gradient") {
  
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
            Button("Material") {  }
              .foregroundStyle(.primary)
              .padding()
              .background(.ultraThinMaterial)
              .clipShape(RoundedRectangle(cornerRadius: 12))
              .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
          ),
          code: ".background(.ultraThinMaterial)",
          fullCode: """
Button("Material") {
  
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
            Button("Capsule") {  }
              .foregroundStyle(.white)
              .padding(.horizontal, 24)
              .padding(.vertical, 12)
              .background(.mint)
              .clipShape(Capsule())
          ),
          code: ".clipShape(Capsule())",
          fullCode: """
Button("Capsule") {
  
}
.foregroundStyle(.white)
.padding(.horizontal, 24)
.padding(.vertical, 12)
.background(.mint)
.clipShape(Capsule())
"""
        )
      } header: {
        HStack {
          Text("Custom Styled Buttons")
          Spacer()
          Text("custom modifiers")
            .font(.system(.caption2, design: .monospaced))
        }
      }
    }
    .navigationTitle("Buttons")
  }
}

// MARK: - Previews

#Preview("All Examples") {
  NavigationStack {
    ButtonExamplesView()
  }
}
