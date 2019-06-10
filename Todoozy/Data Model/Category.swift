//
//  Category.swift
//  Todoozy
//
//  Created by Brendan Milton on 10/06/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    // Relationships
    // items point to list of items
    let items = List<Item>()
    
}
