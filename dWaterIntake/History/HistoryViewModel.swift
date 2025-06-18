//
//  HistoryViewModel.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 16/06/25.
//

import Foundation
import CoreData

class HistoryViewModel: ObservableObject {
    @Published var logs: [WaterLog] = []
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        fetchLogs()
    }
    func fetchLogs() {
        let request: NSFetchRequest<WaterLog> = WaterLog.fetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            logs = try context.fetch(request)
        } catch {
            print("Eror fetching logs: \(error)")
        }
    }
}
