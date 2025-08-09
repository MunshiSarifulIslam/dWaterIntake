//
//  CoreDataTestHelpers.swift
//  dWaterIntakeTests
//
//  Created by Munshi Sariful Islam on 09/08/25.
//

import CoreData
@testable import dWaterIntake

// MARK: - In-memory Core Data context for success-path tests
func makeInMemoryManagedObjectContext() -> NSManagedObjectContext {
    let modelURL = Bundle.main.url(forResource: "IntakeStoreModel", withExtension: "momd")!
    let model = NSManagedObjectModel(contentsOf: modelURL)!
    
    let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
    try! coordinator.addPersistentStore(
        ofType: NSInMemoryStoreType,
        configurationName: nil,
        at: nil,
        options: nil
    )
    
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.persistentStoreCoordinator = coordinator
    return context
}
