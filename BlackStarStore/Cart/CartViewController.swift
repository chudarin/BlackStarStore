//
//  CartViewController.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 11.03.2021.
//

import UIKit
import RealmSwift

class CartViewController: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet weak var closeCartButton: UIButton!
    @IBAction func closeCartButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var sumPriceLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBAction func checkoutButtonAction(_ sender: Any) {
    }
    
    
    var productsInCart: [ProductInCart] = []
    
    func calculateSumOfProducts() -> String {
        var sum: Double = 0
        for i in productsInCart {
            sum += Double(i.productPrice) ?? 0
        }
        return String(sum)
    }
    
    
    
    @objc func deleteAlert(sender: UIButton) {
        let alert = UIAlertController(title: "Внимание", message: "Удалить товар из корзины?", preferredStyle: .alert)
        let number = sender.tag
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            deleteProductToCartRealm(product: number)
            self.prepareView()
            self.cartTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    fileprivate func prepareView() {
        productsInCart = getProductToCartRealm()
        sumPriceLabel.text = ProductsListViewController().convertToPrice(calculateSumOfProducts())
        cartTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkoutButton.layer.cornerRadius = 8
        
        prepareView()
    }
}


extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsInCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        cell.productImageView.contentMode = .scaleAspectFill
        cell.productNameLabel.text = productsInCart[indexPath.row].productName
        cell.productSizeLabel.text = "Размер: \(productsInCart[indexPath.row].productSize)"
        cell.productColorLabel.text = "Цвет: \(productsInCart[indexPath.row].productColor)"
        cell.productImageView.image = productsInCart[indexPath.row].productImageURL != "" ? UIImage(data: try! Data(contentsOf: URL(string: productsInCart[indexPath.row].productImageURL )!)) : UIImage(named: "no_image")
        cell.productPriceLabel.text = ProductsListViewController().convertToPrice(productsInCart[indexPath.row].productPrice)
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteAlert), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
