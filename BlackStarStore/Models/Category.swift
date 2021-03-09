//
//  Category.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 04.03.2021.
//

import Foundation

struct ParsedJSON: Codable {
    
    public var innerArray: [String: ShopCategory]
    
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
        
        self.innerArray = [String: ShopCategory]()
        for key in container.allKeys {
            let value = try container.decode(ShopCategory.self, forKey: CustomCodingKeys(stringValue: key.stringValue)!)
            self.innerArray[key.stringValue] = value
        }
    }
    
}

struct ShopCategory: Codable {
    let name: String
    let sortOrder: OptionalTypes
    let image, iconImage, iconImageActive: String
    let subcategories: [ShopSubcategory]
}

// MARK: - Subcategory
struct ShopSubcategory: Codable {
    let id: OptionalTypes
    let iconImage: String
    let sortOrder: OptionalTypes
    let name: String
    let type: String
}

enum OptionalTypes: Codable, Hashable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(OptionalTypes.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for SortOrder"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}


