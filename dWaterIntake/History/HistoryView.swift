//
//  HistoryView.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 12/06/25.
//

import SwiftUI
import CoreData

struct HistoryView: View {
    @StateObject private var viewModel: HistoryViewModel
    
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: HistoryViewModel(context: context))
    }
    
    var body: some View {
        VStack {
            if viewModel.logs.isEmpty {
                Text("No logs yet")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                List(viewModel.logs, id: \.objectID) { log in
                    HStack {
                        Text(formattedDate(log.date))
                        Spacer()
                        Text("\(log.intakeAmount) mL")
                            .bold()
                    }
                }
            }
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
