//
//  Realm.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 11.03.2021.
//

import Foundation
import RealmSwift

let realm = try! Realm()
let products = realm.objects(ProductInCart.self)


class ProductInCart: Object {
    @objc dynamic var productImageURL: String = ""
    @objc dynamic var productName: String = ""
    @objc dynamic var productSize: String = ""
    @objc dynamic var productColor: String = ""
    @objc dynamic var productPrice: String = ""
    @objc dynamic var productQuantity: Int = 1
    
    convenience init(imageURL: String, name: String, size: String, color: String, price: String) {
        self.init()
        self.productImageURL = imageURL
        self.productName = name
        self.productSize = size
        self.productColor = color
        self.productPrice = price
        self.productQuantity = 1
    }
}

func addProductToCartRealm(imageURL: String, name: String, size: String, color: String, price: String) {
    if let existingProduct = products.filter("productName == %@ AND productColor == %@ AND productSize == %@", name, color, size).first {
        try! realm.write {
            existingProduct.productQuantity += 1
        }
    } else {
        try! realm.write {
            realm.add(ProductInCart(imageURL: imageURL, name: name, size: size, color: color, price: price))
        }
    }
}

func getProductToCartRealm() -> [ProductInCart] {
    var arr: [ProductInCart] = []
    for i in products {
        arr.append(i)
    }
    return arr
}

func deleteProductToCartRealm(product number: Int) {
    try! realm.write {
        realm.delete(products[number])
    }
}

func deleteALLProducts() {
    try! realm.write {
        realm.deleteAll()
        print("================== \n DATABASE DROPPED \n ==================")
    }
}
