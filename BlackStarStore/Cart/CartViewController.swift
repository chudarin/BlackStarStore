//
//  CartViewController.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 11.03.2021.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var closeCartButton: UIButton!
    @IBAction func closeCartButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var sumPriceLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBAction func checkoutButtonAction(_ sender: Any) {
    }
    @IBAction func deleteProductButton(_ sender: Any) {
    }
    
    var productsInCart: [Product] = []
    var productsInCartSizes: [String] = []
    var productsInCartColors: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsInCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        cell.productImageView.contentMode = .scaleAspectFill
        
        cell.productNameLabel.text = productsInCart[indexPath.row].name
        cell.productImageView.image = productsInCart[indexPath.row].mainImage != "" ? UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(productsInCart[indexPath.row].mainImage)")!)) : UIImage(named: "no_image")
        cell.productPriceLabel.text = ProductsListViewController().convertToPrice(productsInCart[indexPath.row].price)
        
        return cell
    }
    
    
}
