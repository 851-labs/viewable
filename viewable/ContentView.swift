//
//  ContentView.swift
//  viewable
//
//  Created by Alexandru Turcanu on 6/15/25.
//

import SwiftUI

// MARK: - Sidebar DSL

struct Page: Identifiable, Hashable {
  let id: String
  let title: String
  let destination: AnyView
  
  init(id: String, title: String, @ViewBuilder destination: () -> some View) {
    self.id = id
    self.title = title
    self.destination = AnyView(destination())
  }
  
  static func == (lhs: Page, rhs: Page) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  func matches(searchText: String) -> Bool {
    title.localizedCaseInsensitiveContains(searchText)
  }
}

struct SidebarSection: Identifiable {
  let id: String
  let title: String
  let pages: [Page]
  
  init(title: String, @SidebarSectionBuilder pages: () -> [Page]) {
    self.id = title
    self.title = title
    self.pages = pages()
  }
  
  init(title: String, pages: [Page]) {
    self.id = title
    self.title = title
    self.pages = pages
  }
  
  func filtered(by searchText: String) -> [Page] {
    guard !searchText.isEmpty else { return pages }
    return pages.filter { $0.matches(searchText: searchText) }
  }
}

@resultBuilder
struct SidebarSectionBuilder {
  static func buildBlock(_ pages: Page...) -> [Page] {
    pages
  }
}

@resultBuilder
struct SidebarConfigurationBuilder {
  static func buildBlock(_ sections: SidebarSection...) -> [SidebarSection] {
    sections
  }
}

// MARK: - Sidebar Configuration

extension ContentView {
  @SidebarConfigurationBuilder
  static var sidebarSections: [SidebarSection] {
    SidebarSection(title: "Components") {
      Page(id: "buttons", title: "Button") {
        ButtonExamplesView()
      }
      Page(id: "sliders", title: "Slider") {
        SliderExamplesView()
      }
      Page(id: "toggles", title: "Toggle") {
        ToggleExamplesView()
      }
      Page(id: "steppers", title: "Stepper") {
        StepperExamplesView()
      }
      Page(id: "colorPickers", title: "Color Picker") {
        ColorPickerExamplesView()
      }
      Page(id: "lists", title: "List") {
        ListExamplesView()
      }
      Page(id: "forms", title: "Form") {
        FormExamplesView()
      }
    }
    
    SidebarSection(title: "Showcase") {
      Page(id: "anyDistance", title: "Any Distance") {
        AnyDistanceAnimationsView()
      }
    }
  }
}

// MARK: - Content View

struct ContentView: View {
  @State private var selectedPage: Page? = Self.sidebarSections.first?.pages.first
  @State private var searchText: String = ""
  
  private var filteredSections: [SidebarSection] {
    Self.sidebarSections.compactMap { section in
      let filtered = section.filtered(by: searchText)
      return filtered.isEmpty ? nil : SidebarSection(title: section.title, pages: filtered)
    }
  }
  
  private var hasResults: Bool {
    !filteredSections.isEmpty
  }
  
  var body: some View {
    NavigationSplitView {
      if hasResults {
        List(selection: $selectedPage) {
          ForEach(filteredSections) { section in
            Section(section.title) {
              ForEach(section.pages) { page in
                NavigationLink(value: page) {
                  Text(page.title)
                }
              }
            }
          }
        }
        .navigationTitle("Viewable")
      } else {
        ContentUnavailableView(
          "No Results",
          systemImage: "magnifyingglass",
          description: Text("Try a different search term")
        )
        .navigationTitle("SwiftUI Examples")
      }
    } detail: {
      if let selectedPage {
        NavigationStack {
          selectedPage.destination
        }
      } else {
        ContentUnavailableView(
          "Select an item",
          systemImage: "sidebar.left",
          description: Text("Choose a component from the sidebar")
        )
      }
    }
    .searchable(text: $searchText, placement: .sidebar, prompt: "Search examples")
  }
}

#Preview {
  ContentView()
}
