//
//  Category.swift
//  Todoey
//
//  Created by Jared Talbert on 4/25/19.
//  Copyright © 2019 Jared Talbert. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    // creates a "one-to-many" relationship from category to items
    let items = List<Item>()
}
