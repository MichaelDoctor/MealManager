//
//  Cuisine+CoreDataProperties.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-16.
//
//

import Foundation
import CoreData


extension Cuisine {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cuisine> {
        return NSFetchRequest<Cuisine>(entityName: "Cuisine")
    }

    @NSManaged public var isActive: Bool
    @NSManaged public var name: String?
    @NSManaged public var numberOfTimesEaten: Int64
    @NSManaged public var lastAte: Date?

}

extension Cuisine : Identifiable {

}
