//
//  Realm.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 11.03.2021.
//

import Foundation
import RealmSwift


@objc dynamic var productImageView: UIImageView!
productNameLabel: UILabel!
productSizeLabel: UILabel!
productColorLabel: UILabel!
productPriceLabel: UILabel!

// Define your models like regular Swift classes
class Dog: Object {
    @objc dynamic var name = ""
    @objc dynamic var age = 0
}
class Person: Object {
    @objc dynamic var _id = ""
    @objc dynamic var name = ""
    @objc dynamic var age = 0
    // Create relationships by pointing an Object field to another Class
    let dogs = List<Dog>()
    
    override static func primaryKey() -> String? {
        return "_id"
    }
}
// Use them like regular Swift objects
let dog = Dog()
dog.name = "Rex"
dog.age = 1
print("name of dog: \(dog.name)")

// Get the default Realm
let realm = try! Realm()
// Persist your data easily with a write transaction
try! realm.write {
    realm.add(dog)
}
