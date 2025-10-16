//
//  GitHubContributionGraphView.swift
//  viewable
//
//  Created by Alexandru Turcanu on 10/16/25.
//

import Charts
import SwiftUI

// MARK: - Data Model

struct Contribution: Identifiable {
  let date: Date
  let count: Int
  
  var id: Date {
    date
  }
}

extension Contribution {
  static func generate() -> [Contribution] {
    var contributions: [Contribution] = []
    let toDate = Date.now
    let fromDate = Calendar.current.date(byAdding: .day, value: -60, to: toDate)!
    
    var currentDate = fromDate
    while currentDate <= toDate {
      let contribution = Contribution(date: currentDate, count: .random(in: 0...10))
      contributions.append(contribution)
      currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
    }
    
    return contributions
  }
}

// MARK: - Main View

struct GitHubContributionGraphView: View {
  @State private var contributions: [Contribution] = Contribution.generate()
  
  private var shortWeekdaySymbols: [String] {
    Calendar.current.shortWeekdaySymbols
  }
  
  private func weekday(for date: Date) -> Int {
    let weekday = Calendar.current.component(.weekday, from: date)
    let adjustedWeekday = (weekday == 1) ? 7 : (weekday - 1)
    return adjustedWeekday
  }
  
  private var aspectRatio: Double {
    if contributions.isEmpty {
      return 1
    }
    let firstDate = contributions.first!.date
    let lastDate = contributions.last!.date
    let firstWeek = Calendar.current.component(.weekOfYear, from: firstDate)
    let lastWeek = Calendar.current.component(.weekOfYear, from: lastDate)
    return Double(lastWeek - firstWeek + 1) / 7
  }
  
  private var colors: [Color] {
    (0...10).map { index in
      if index == 0 {
        return .gray.opacity(0.2)
      }
      return .green.opacity(Double(index) / 10)
    }
  }
  
  private var legendColors: [Color] {
    Array(stride(from: 0, to: colors.count, by: 2).map { colors[$0] })
  }
  
  var body: some View {
    Form {
      Section {
        HStack {
          Spacer()
          
          Chart(contributions) { contribution in
            RectangleMark(
              xStart: .value("Start week", contribution.date, unit: .weekOfYear),
              xEnd: .value("End week", contribution.date, unit: .weekOfYear),
              yStart: .value("Start weekday", weekday(for: contribution.date)),
              yEnd: .value("End weekday", weekday(for: contribution.date) + 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 4).inset(by: 2))
            .foregroundStyle(by: .value("Count", contribution.count))
          }
          .chartForegroundStyleScale(range: Gradient(colors: colors))
          .chartPlotStyle { content in
            content
              .aspectRatio(aspectRatio, contentMode: .fit)
          }
          .chartXAxis {
            AxisMarks(position: .top, values: .stride(by: .month)) {
              AxisValueLabel(format: .dateTime.month())
            }
          }
          .chartYAxis {
            AxisMarks(position: .leading, values: [1, 3, 5]) { value in
              if let value = value.as(Int.self) {
                AxisValueLabel {
                  Text(shortWeekdaySymbols[value - 1])
                }
              }
            }
          }
          .chartYScale(domain: .automatic(includesZero: false, reversed: true))
          .chartLegend {
            HStack(spacing: 4) {
              Text("Less")
              ForEach(legendColors, id: \.self) { color in
                color
                  .frame(width: 10, height: 10)
                  .cornerRadius(2)
              }
              Text("More")
            }
            .padding(4)
#if os(iOS)
              .foregroundStyle(Color(uiColor: .label))
#elseif os(macOS)
              .foregroundStyle(Color(nsColor: .secondaryLabelColor))
#endif
              .font(.caption2)
          }
          .frame(maxHeight: 300)
          
          Spacer()
        }
      }
       
      Section {
        // Actions
        VStack(alignment: .leading, spacing: 16) {
          Button {
            withAnimation {
              contributions = Contribution.generate()
            }
          } label: {
            Label("Regenerate Data", systemImage: "arrow.clockwise")
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.borderedProminent)
          .controlSize(.large)
          
          // Reference Link
          Link(destination: URL(string: "https://artemnovichkov.com/blog/github-contribution-graph-swift-charts")!) {
            HStack {
              Image(systemName: "link")
              Text("View Original Blog Post")
              Spacer()
              Image(systemName: "arrow.up.right")
            }
            .font(.subheadline)
            .foregroundStyle(.blue)
          }
          .buttonStyle(.plain)
        }
        .padding(.horizontal)
        .padding(.bottom)
      }
    }
    .formStyle(.grouped)
    .navigationTitle("GitHub Graph")
  }
}

// MARK: - Preview

#Preview {
  NavigationStack {
    GitHubContributionGraphView()
  }
}
