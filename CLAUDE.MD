# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Viewable is a collection of copy/paste-able SwiftUI examples that run on iOS, watchOS, iPadOS, macOS and visionOS.

## Development Commands

### Building

```bash
# Open in Xcode
open viewable.xcodeproj

# Build from command line
xcodebuild -project viewable.xcodeproj -scheme viewable build
```

### Testing

```bash
# Run all tests
xcodebuild test -scheme viewableTests -destination 'platform=iOS Simulator,name=iPhone 16'
```

## Architecture

### State Management

- Uses `@Observable` classes with SwiftUI's Observation framework
- `AppState` enum manages authentication and app lifecycle states
- Environment-based dependency injection for shared services
- Tab-based navigation with sheet-based modal presentation

### Testing Approach

- Swift Testing framework (modern replacement for XCTest)
- ViewInspector for SwiftUI component testing
- Test targets organized by package modules
- `@MainActor` test classes for UI testing

## SwiftUI Philosophy: No ViewModels

This project follows a strict **no-ViewModel** approach, embracing SwiftUI's native design patterns:

### Core Principles

- **Views as Pure State Expressions**: SwiftUI views are structs designed to be lightweight and disposable
- **Environment-Based Dependency Injection**: Use `@Environment` for shared services instead of manual ViewModel injection
- **Local State Management**: Use `@State` and enum-based view states directly within views
- **Composition Over Abstraction**: Split complex views into smaller components rather than extracting logic to ViewModels

### Patterns to Follow

- Define view states using enums (`.loading`, `.error`, `.loaded`)
- Use `@Environment` to access shared services like `BSkyClient`, `Auth`, `CurrentUser`
- Leverage `.task(id:)` and `.onChange()` modifiers for side effects and state reactions
- Keep business logic in service classes, not in ViewModels
- Test services and models independently; use ViewInspector for view testing when needed

### Example Structure

```swift
struct ExampleView: View {
    @Environment(BSkyClient.self) private var client
    @State private var viewState: ViewState = .loading

    enum ViewState {
        case loading
        case error(String)
        case loaded([Item])
    }

    var body: some View {
        // Pure state expression
    }
}
```

This approach results in cleaner, more maintainable code that works with SwiftUI's design rather than against it.

## Build Verification Rule

**IMPORTANT**: After making code changes, you MUST use the XcodeBuildMCP commands to build and verify the project compiles without errors:

1. First, discover available schemes:

   ```
   mcp__XcodeBuildMCP__list_schems_proj({ projectPath: "/Users/alexandru/851/viewable/viewable.xcodeproj" })
   ```

2. Build the IcySky scheme for iOS Simulator:
   ```
   mcp__XcodeBuildMCP__build_ios_sim_name_proj({
     projectPath: "/Users/alexandru/851/viewable/viewable.xcodeproj",
     scheme: "viewable",
     simulatorName: "iPhone 16"
   })
   ```
3. If there are build errors, fix them before considering the task complete.

This ensures code changes are syntactically correct and don't break the build.

## iOS 26 SDK Requirements

**IMPORTANT**: This project now requires iOS 26 SDK and targets iOS 26+ exclusively. We fully embrace and utilize the latest SwiftUI APIs introduced in June 2025.

### Available iOS 26 SwiftUI APIs

Feel free to use any of these new APIs throughout the codebase:

#### Liquid Glass Effects

- `glassEffect(_:in:isEnabled:)` - Apply Liquid Glass effects to views
- `buttonStyle(.glass)` - Apply Liquid Glass styling to buttons
- `ToolbarSpacer` - Create visual breaks in toolbars with Liquid Glass

#### Enhanced Scrolling

- `scrollEdgeEffectStyle(_:for:)` - Configure scroll edge effects
- `backgroundExtensionEffect()` - Duplicate, mirror, and blur views around edges

#### Tab Bar Enhancements

- `tabBarMinimizeBehavior(_:)` - Control tab bar minimization behavior
- Search role for tabs with search field replacing tab bar
- `TabViewBottomAccessoryPlacement` - Adjust accessory view content based on placement

#### Web Integration

- `WebView` and `WebPage` - Full control over browsing experience

#### Drag and Drop

- `draggable(_:_:)` - Drag multiple items
- `dragContainer(for:id:in:selection:_:)` - Container for draggable views

#### Animation

- `@Animatable` macro - SwiftUI synthesizes custom animatable data properties

#### UI Components

- `Slider` with automatic tick marks when using step parameter
- `windowResizeAnchor(_:)` - Set window anchor point for resizing

#### Text Enhancements

- `TextEditor` now supports `AttributedString`
- `AttributedTextSelection` - Handle text selection with attributed text
- `AttributedTextFormattingDefinition` - Define text styling in specific contexts
- `FindContext` - Create find navigator in text editing views

#### Accessibility

- `AssistiveAccess` - Support Assistive Access in iOS scenes

#### HDR Support

- `Color.ResolvedHDR` - RGBA values with HDR headroom information

#### UIKit Integration

- `UIHostingSceneDelegate` - Host and present SwiftUI scenes in UIKit
- `NSGestureRecognizerRepresentable` - Incorporate gesture recognizers from AppKit

#### Immersive Spaces (if applicable)

- `manipulable(coordinateSpace:operations:inertia:isEnabled:onChanged:)` - Hand gesture manipulation
- `SurfaceSnappingInfo` - Snap volumes and windows to surfaces
- `RemoteImmersiveSpace` - Render stereo content from Mac to Apple Vision Pro
- `SpatialContainer` - 3D layout container
- Depth-based modifiers: `aspectRatio3D(_:contentMode:)`, `rotation3DLayout(_:)`, `depthAlignment(_:)`

### Usage Guidelines

- Leverage these new APIs to enhance the user experience
- Replace legacy implementations with iOS 26 APIs where appropriate
- Take advantage of Liquid Glass effects for modern UI aesthetics
- Use the enhanced text and drag-and-drop capabilities for better interactions
