//
//  StepperExample+Builder.swift
//  viewable
//
//  Builder pattern for StepperExample
//

import SwiftUI

// MARK: - StepperExampleBuilder

struct StepperExampleBuilder {
  private var title: String
  private var stepperView: AnyView
  private var code: String
  private var fullCode: String?
  
  init(title: String) {
    self.title = title
    self.stepperView = AnyView(EmptyView())
    self.code = ""
  }
  
  func stepper<Content: View>(@ViewBuilder _ content: () -> Content) -> Self {
    var copy = self
    copy.stepperView = AnyView(content())
    return copy
  }
  
  func codeSnippet(_ code: String) -> Self {
    var copy = self
    copy.code = code
    return copy
  }
  
  func fullCodeExample(_ fullCode: String) -> Self {
    var copy = self
    copy.fullCode = fullCode
    return copy
  }
  
  func build() -> StepperExample {
    StepperExample(
      title: title,
      stepper: stepperView,
      code: code,
      fullCode: fullCode
    )
  }
}

// MARK: - Convenience Extension

extension StepperExample {
  static func builder(title: String) -> StepperExampleBuilder {
    StepperExampleBuilder(title: title)
  }
  
  // Convenience initializer for simple steppers
  init<Content: View>(
    title: String,
    @ViewBuilder stepper: () -> Content,
    code: String,
    fullCode: String? = nil
  ) {
    self.init(
      title: title,
      stepper: AnyView(stepper()),
      code: code,
      fullCode: fullCode
    )
  }
} 