//
//  FetchDataFromJson.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 04.03.2021.
//

import Foundation

func LoadCategories(completion: @escaping (DecodedJSON) -> Void) {
    let apiURL = URL(string: "https://blackstarshop.ru/index.php?route=api/v1/categories")
    let session = URLSession.shared.dataTask(with: apiURL!) { (data, response, error) in
        let decoder = JSONDecoder()
        let jsonData = Data(data.utf8)
        let decodedData = try! decoder.decode(DecodedJSON.self, from: data!)
        DispatchQueue.main.async {
            completion(decodedData)
            print(decodedData)
        }
    }
    session.resume()
}
