//
//  OrderType+CoreDataProperties.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-06.
//
//

import Foundation
import CoreData


extension OrderType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderType> {
        return NSFetchRequest<OrderType>(entityName: "OrderType")
    }

    @NSManaged public var link: String?
    @NSManaged public var address: String?
    @NSManaged public var isLocal: Bool
    @NSManaged public var parentMeal: Meal?

}

extension OrderType : Identifiable {

}
