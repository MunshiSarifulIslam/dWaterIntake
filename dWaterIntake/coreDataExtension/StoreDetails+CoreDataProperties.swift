//
//  StoreDetails+CoreDataProperties.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 11/06/25.
//
//

import Foundation
import CoreData


extension StoreDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoreDetails> {
        return NSFetchRequest<StoreDetails>(entityName: "StoreDetails")
    }

    @NSManaged public var gender: String?
    @NSManaged public var height: String?
    @NSManaged public var name: String?
    @NSManaged public var waterConsumttion: String?
    @NSManaged public var weight: String?

}

extension StoreDetails : Identifiable {

}
