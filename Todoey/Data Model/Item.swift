//
//  Item.swift
//  Todoey
//
//  Created by Jared Talbert on 4/25/19.
//  Copyright © 2019 Jared Talbert. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    
    // creates a "one-to-one" relationship from items to category
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
