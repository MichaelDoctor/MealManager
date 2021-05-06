//
//  CookType+CoreDataProperties.swift
//  Meal Manager
//
//  Created by Michael Doctor on 2021-05-06.
//
//

import Foundation
import CoreData


extension CookType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CookType> {
        return NSFetchRequest<CookType>(entityName: "CookType")
    }

    @NSManaged public var parentMeal: Meal?
    @NSManaged public var ingredients: NSSet?
    @NSManaged public var instructions: NSSet?

}

// MARK: Generated accessors for ingredients
extension CookType {

    @objc(addIngredientsObject:)
    @NSManaged public func addToIngredients(_ value: Ingredient)

    @objc(removeIngredientsObject:)
    @NSManaged public func removeFromIngredients(_ value: Ingredient)

    @objc(addIngredients:)
    @NSManaged public func addToIngredients(_ values: NSSet)

    @objc(removeIngredients:)
    @NSManaged public func removeFromIngredients(_ values: NSSet)

}

// MARK: Generated accessors for instructions
extension CookType {

    @objc(addInstructionsObject:)
    @NSManaged public func addToInstructions(_ value: Instruction)

    @objc(removeInstructionsObject:)
    @NSManaged public func removeFromInstructions(_ value: Instruction)

    @objc(addInstructions:)
    @NSManaged public func addToInstructions(_ values: NSSet)

    @objc(removeInstructions:)
    @NSManaged public func removeFromInstructions(_ values: NSSet)

}

extension CookType : Identifiable {

}
