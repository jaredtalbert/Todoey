//
//  Item.swift
//  Todoey
//
//  Created by Jared Talbert on 3/26/19.
//  Copyright © 2019 Jared Talbert. All rights reserved.
//

import Foundation

class Item: Codable { // inherits from Encodable to be able to be used with Encoder. Makes sense.
    var title: String = ""
    var isDone: Bool = false
}
