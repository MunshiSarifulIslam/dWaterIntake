//
//  WaterLog+CoreDataProperties.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 14/06/25.
//
//

import Foundation
import CoreData


extension WaterLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WaterLog> {
        return NSFetchRequest<WaterLog>(entityName: "WaterLog")
    }

    @NSManaged public var date: Date?
    @NSManaged public var intakeAmount: Int64

}

extension WaterLog : Identifiable {

}
