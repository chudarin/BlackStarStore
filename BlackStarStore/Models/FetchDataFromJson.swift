//
//  FetchDataFromJson.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 04.03.2021.
//

import Foundation

func loadCategories(completion: @escaping ([ShopCategory]) -> Void) {
    let apiURL = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/categories")
    let session = URLSession.shared.dataTask(with: apiURL!) { (data, _, _) in
        let decodedData = try! JSONDecoder().decode(ParsedJSON.self, from: data!)
        var values: [ShopCategory] = []
        DispatchQueue.main.async {
            for (_, el) in decodedData.innerArray.enumerated() {
                values.append(el.value)
            }
            completion(values)
        }
    }
    session.resume()
}

func loadProducts(id: Int, completion: @escaping ([Product]) -> Void) {
    let url = "https://blackstarshop.ru/index.php?route=api/v1/products&cat_id=\(id)"
    let apiURL = URL(string: url)
    let session = URLSession.shared.dataTask(with: apiURL!) { (data, _, _) in
        let decodedData = try! JSONDecoder().decode(ParsedProducts.self, from: data!)
        var products: [Product] = []
        DispatchQueue.main.async {
            for (_, el) in decodedData.innerArray.enumerated() {
                products.append(el.value)
//                print(el.value)
            }
            completion(products)
//            print(products)
        }
    }
    session.resume()
}
