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
