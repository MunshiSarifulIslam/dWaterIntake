//
//  HistoryView.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 12/06/25.
//

import SwiftUI
import CoreData
import Charts

struct HistoryView: View {
    @StateObject private var viewModel: HistoryViewModel

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HistoryViewModel(context: context))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.logs.isEmpty {
                    Text("No logs yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(viewModel.logs, id: \.id) { chart in
                        VStack(alignment: .leading) {
                            Text(formattedDate(chart.date))
                                .font(.headline)
                                .padding([.horizontal, .top])

                            Chart {
                                BarMark(
                                    x: .value("Date", formattedDate(chart.date)),
                                    y: .value("Water Intake", chart.intakeAmount)
                                )
                                .foregroundStyle(.blue.opacity(0.6))
                                .annotation(position: .top) {
                                    Text("\(chart.intakeAmount) ml")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .chartXAxis(.hidden)
                            .chartYAxis {
                                AxisMarks(position: .leading)
                            }
                            .frame(height: 150)
                            .padding()
                        }
                        .background(LinearGradient(colors: [Color(hex: "#00FFFF").opacity(0.1), Color(hex: "#00FFFF").opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
    }

    private func formattedDate(_ date: Date?) -> String {
        guard let date = date else { return "Unknown Date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


#Preview {
    let container = NSPersistentContainer(name: "IntakeStoreModel")
    container.loadPersistentStores(completionHandler: { _, _ in })
    return HistoryView(context: container.viewContext)
}
