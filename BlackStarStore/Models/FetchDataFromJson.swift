//
//  FetchDataFromJson.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 04.03.2021.
//

import Foundation
import SVProgressHUD

func setupPreloader() {
    SVProgressHUD.setBackgroundColor(.systemGray5)
}

func parsingJSON(completion: @escaping (ParsedJSON) -> Void) {
    setupPreloader()
    SVProgressHUD.show(withStatus: "Загружаем категории")
    let apiURL = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/categories")
    let _ = URLSession.shared.dataTask(with: apiURL!) { (data, _, _) in
        let decodedData = try! JSONDecoder().decode(ParsedJSON.self, from: data!)
//        var values: [ParsedJSON] = []
        DispatchQueue.main.async {
//            for (_, el) in decodedData.innerArray.enumerated() {
//                values.append(el.value)
//            }
            completion(decodedData)
            SVProgressHUD.dismiss()
        }
    }.resume()
}

func loadProducts(id: Int, completion: @escaping ([Product]) -> Void) {
    setupPreloader()
    SVProgressHUD.show(withStatus: "Загружаем товары")
    let url = "https://blackstarshop.ru/index.php?route=api/v1/products&cat_id=\(id)"
    let apiURL = URL(string: url)
    let _ = URLSession.shared.dataTask(with: apiURL!) { (data, _, _) in
        let decodedData = try! JSONDecoder().decode(ParsedProducts.self, from: data!)
        var products: [Product] = []
        DispatchQueue.main.async {
            for (_, el) in decodedData.innerArray.enumerated() {
                products.append(el.value)
            }
            completion(products)
            SVProgressHUD.dismiss()
        }
    }.resume()
}
