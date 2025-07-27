//
//  StockItem+CoreDataProperties.swift
//  Recave
//
//  Created by Sirlian Cassar-Gaisne on 27/07/2025.
//
//

import Foundation
import CoreData


extension StockItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockItem> {
        return NSFetchRequest<StockItem>(entityName: "StockItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var quantity: Int16
    @NSManaged public var colorHex: String?

}

extension StockItem : Identifiable {

}
