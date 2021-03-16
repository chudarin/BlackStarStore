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
        
    var productsInCart: [ProductInCart] = []
    
    func calculateSumOfProducts() -> String {
        var sum: Double = 0
        for i in productsInCart {
            sum += calculateMultiQuantity(price: i.productPrice, quantity: i.productQuantity)
        }
        return String(sum)
    }
    
    // MARK: - Setup Yes/No Alert
    @objc func deleteAlert(sender: UIButton) {
        let alert = UIAlertController(title: "Внимание", message: "Удалить товар из корзины?", preferredStyle: .alert)
        let number = sender.tag
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            deleteProductToCartRealm(product: number)
            self.setupCartFrame()
            self.cartTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Setup Cart Frame
    func setupCartFrame() {
        productsInCart = getProductToCartRealm()
        sumPriceLabel.text = convertToPrice(calculateSumOfProducts())
        cartTableView.reloadData()
    }
    
    func calculateMultiQuantity(price: String, quantity: Int) -> Double {
        let value = (price as NSString).doubleValue
        return value * Double(quantity)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        checkoutButton.layer.cornerRadius = 8
        setupCartFrame()
    }
}

// MARK: - Extensions
extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsInCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartTableViewCell
        let product = productsInCart[indexPath.row]
        cell.productImageView.contentMode = .scaleAspectFill
        cell.productNameLabel.text = product.productName
        cell.productSizeLabel.text = "Размер: \(product.productSize)"
        cell.productColorLabel.text = "Цвет: \(product.productColor)"
        cell.productImageView.image = product.productImageURL != "" ? UIImage(data: try! Data(contentsOf: URL(string: product.productImageURL.cleanURL )!)) : UIImage(named: "no_image")
        if product.productQuantity > 1 {
            cell.productPriceLabel.text = "\(product.productQuantity) x \(convertToPrice(product.productPrice))"
        } else {
            cell.productPriceLabel.text = convertToPrice(product.productPrice)
        }        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteAlert), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
