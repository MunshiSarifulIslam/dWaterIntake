//
//  Persistence.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 10/06/25.
//

import CoreData

class StoreManager: NSObject, ObservableObject {
    let container: NSPersistentContainer = NSPersistentContainer(name: "IntakeStoreModel")
    @Published var storeDetails: StoreDetails?
    override init() {
        super.init()
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading persistent stores: \(error)")
            }
        }
    }
    
    func fetchUserDetails() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<StoreDetails> = StoreDetails.fetchRequest()
        
        do {
            let stores = try context.fetch(fetchRequest)
            self.storeDetails = stores.first
        } catch {
            print("Error fetching user details: \(error)")
        }
    }
}
