//
//  Product.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 07.03.2021.
//

import Foundation

struct ParsedProducts: Codable {
    
    public var innerArray: [String: Product]
    
    private struct CustomCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            return nil
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        
        self.innerArray = [String: Product]()
        for key in container.allKeys {
            let value = try container.decode(Product.self, forKey: CustomCodingKeys(stringValue: key.stringValue)!)
            self.innerArray[key.stringValue] = value
        }
    }
    
}

// MARK: - WelcomeValue
struct Product: Codable {
    let name, englishName, sortOrder, article: String
    let description, colorName, colorImageURL, mainImage: String
    let productImages: [ProductImage]
    let price: String
    let offers: [Offers]
}


// MARK: - ProductImage
struct ProductImage: Codable {
    let imageURL, sortOrder: String
}

struct Offers: Codable {
    let size: String
    let quantity: String
}
