//
//  Meal+CoreDataProperties.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-14.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var cuisineType: String?
    @NSManaged public var didEat: Bool
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var numberOfTimesEaten: Int64
    @NSManaged public var type: String?
    @NSManaged public var lastAte: Date?
    @NSManaged public var cookType: CookType?
    @NSManaged public var orderType: OrderType?

}

extension Meal : Identifiable {

}
