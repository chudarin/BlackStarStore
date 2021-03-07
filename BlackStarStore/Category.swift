//
//  Category.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 04.03.2021.
//

import Foundation

struct DecodedJSON: Decodable {
    let array: [WelcomeValue]

     private struct DynamicCodingKeys: CodingKey {
        
         var stringValue: String
         init?(stringValue: String) {
             self.stringValue = stringValue
         }
        
         var intValue: Int?
         init?(intValue: Int) {
            self.intValue = intValue
         }
        
     }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempArray = [WelcomeValue]()
        for key in container.allKeys {
            let decodedObject = try container.decode(WelcomeValue.self, forKey: DynamicCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }
        array = tempArray
    }
}

struct WelcomeValue: Codable {
    let name: String
    let sortOrder: String
    let image, iconImage, iconImageActive: String
    let subcategories: [Subcategory]
}


// MARK: - Subcategory
struct Subcategory: Codable {
    let id: Int
    let iconImage: String
    let sortOrder: Int
    let name: String
    let type: TypeEnum
}

enum TypeEnum: String, Codable {
    case category = "Category"
    case collection = "Collection"
}
