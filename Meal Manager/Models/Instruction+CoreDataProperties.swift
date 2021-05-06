//
//  Instruction+CoreDataProperties.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-06.
//
//

import Foundation
import CoreData


extension Instruction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Instruction> {
        return NSFetchRequest<Instruction>(entityName: "Instruction")
    }

    @NSManaged public var stepNumber: Int64
    @NSManaged public var step: String?
    @NSManaged public var timeHour: Int64
    @NSManaged public var timeMinute: Int64
    @NSManaged public var timeSecond: Int64
    @NSManaged public var parentCookType: CookType?

}

extension Instruction : Identifiable {

}
