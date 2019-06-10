//
//  Item.swift
//  Todoozy
//
//  Created by Brendan Milton on 10/06/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    
    // Inverse relationship (Parent category)
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
