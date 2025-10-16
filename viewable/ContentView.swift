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
  let destination: AnyView?
  let children: [Page]
  
  init(id: String, title: String, @ViewBuilder destination: () -> some View) {
    self.id = id
    self.title = title
    self.destination = AnyView(destination())
    self.children = []
  }
  
  init(id: String, title: String, @PageBuilder pages children: () -> [Page]) {
    self.id = id
    self.title = title
    self.destination = nil
    self.children = children()
  }
  
  static func == (lhs: Page, rhs: Page) -> Bool {
    lhs.id == rhs.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  func matches(searchText: String) -> Bool {
    title.localizedCaseInsensitiveContains(searchText) || 
    children.contains(where: { $0.matches(searchText: searchText) })
  }
  
  func flattenedPages() -> [Page] {
    if children.isEmpty {
      return [self]
    }
    return [self] + children.flatMap { $0.flattenedPages() }
  }
  
  fileprivate init(id: String, title: String, children: [Page]) {
    self.id = id
    self.title = title
    self.destination = nil
    self.children = children
  }
}

@resultBuilder
struct PageBuilder {
  static func buildBlock(_ pages: Page...) -> [Page] {
    Array(pages)
  }
  
  static func buildExpression(_ page: Page) -> Page {
    page
  }
  
  static func buildArray(_ pages: [Page]) -> [Page] {
    pages
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
    return pages.compactMap { page in
      if page.matches(searchText: searchText) {
        return page
      }
      let matchingChildren = page.children.filter { $0.matches(searchText: searchText) }
      if !matchingChildren.isEmpty {
        return Page(id: page.id, title: page.title, children: matchingChildren)
      }
      return nil
    }
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
      Page(id: "anyDistance", title: "Any Distance", pages: {
        Page(id: "countdown", title: "3-2-1 Go") {
          AnyDistanceCountdownShowcaseView()
        }
        Page(id: "metalGradient", title: "Metal Gradient") {
          AnyDistanceMetalGradientShowcaseView()
        }
        Page(id: "flickeringImage", title: "Neon Flickering") {
          AnyDistanceFlickeringImageShowcaseView()
        }
      })
      Page(id: "githubGraph", title: "GitHub Graph") {
        GitHubContributionGraphView()
      }
    }
  }
}

// MARK: - Content View

struct ContentView: View {
  @State private var selectedPage: Page? = {
    Self.sidebarSections
      .first?.pages
      .first(where: { $0.destination != nil })
  }()
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
                if page.children.isEmpty {
                  NavigationLink(value: page) {
                    Text(page.title)
                  }
                } else {
                  DisclosureGroup {
                    ForEach(page.children) { child in
                      NavigationLink(value: child) {
                        Text(child.title)
                      }
                    }
                  } label: {
                    Text(page.title)
                  }
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
      if let selectedPage, let destination = selectedPage.destination {
        NavigationStack {
          destination
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
