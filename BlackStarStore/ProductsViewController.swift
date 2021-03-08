//
//  ProductsViewController.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 07.03.2021.
//

import UIKit

class ProductsViewController: UIViewController {

    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var productsID: OptionalTypes = .integer(2)
    var productsTitle: String = ""
    var products: [Product] = []
    
    func convertToPrice(_ price: String) -> String {
        let value = (price as NSString).doubleValue
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .none
        return formatter.string(from: NSNumber(value: value))!
    }
    
    override func viewDidLoad() {
        loadProducts(id: OptionalTypes.integer(productsID) ?? 330) { (parsedProducts) in
            self.products = parsedProducts
            self.productsCollectionView.reloadData()
        }
//        print((productsID as NSString).integerValue)
        print(productsID ?? 999)
        print(type(of: productsID))
        self.title = productsTitle
        super.viewDidLoad()
    }

}

extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Product", for: indexPath) as! ProductsCollectionViewCell
        
        cell.productImageView.contentMode = .scaleAspectFill
        
        
        
        cell.productNameLabel.text = products[indexPath.row].name
        cell.productDescriptionLabel.text = products[indexPath.row].description
        cell.productImageView.image = products[indexPath.row].mainImage != "" ? UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(products[indexPath.row].mainImage)")!)) : UIImage(named: "no_image")
        cell.productPriceLabel.text = convertToPrice(products[indexPath.row].price) + " ₽"
        
        return cell
    }
    
    
}
