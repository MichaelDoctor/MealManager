//
//  Ingredient+CoreDataProperties.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-14.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: Double
    @NSManaged public var unit: String?
    @NSManaged public var parentCookType: CookType?

}

extension Ingredient : Identifiable {

}
