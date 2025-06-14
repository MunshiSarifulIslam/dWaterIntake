//
//  Persistence.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 10/06/25.
//

import CoreData

class StoreManager: NSObject, ObservableObject {
    let container: NSPersistentContainer
    @Published var storeDetails: StoreDetails?

    override init() {
        container = NSPersistentContainer(name: "IntakeStoreModel")
        super.init()
        
        container.loadPersistentStores { [weak self] _, error in
            if let error = error {
                print("Error loading persistent stores: \(error)")
            } else {
                DispatchQueue.main.async {
                    self?.fetchUserDetails()
                }
            }
        }
    }

    func fetchUserDetails() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<StoreDetails> = StoreDetails.fetchRequest()

        do {
            let stores = try context.fetch(fetchRequest)
            DispatchQueue.main.async { [weak self] in
                self?.storeDetails = stores.first
            }
        } catch {
            print("Error fetching user details: \(error)")
        }
    }
}
