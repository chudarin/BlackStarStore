//
//  CategoryViewController.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 04.03.2021.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryTable: UITableView!
    
    var categories: [ShopCategory] = []
    
    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SubCategoryViewController, segue.identifier == "openSubCategory" {
            if let cell = sender as? UITableViewCell, let indexPath = categoryTable.indexPath(for: cell) {
                vc.subCategories = categories[indexPath.row].subcategories
                vc.subCategoryTitle = categories[indexPath.row].name
            }
        }
    }
    
    // MARK: - Cart Button
    @objc func openCart() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "Cart") as! CartViewController
        present(secondVc, animated: true, completion: nil)
    }
    
    public func cartButton() {
        let cartButton = UIButton(type: .custom)
        cartButton.setImage(UIImage(systemName: "cart.fill"), for: .normal)
        cartButton.addTarget(self, action: #selector(openCart), for: .touchUpInside)
        cartButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let barButton = UIBarButtonItem(customView: cartButton)
        self.navigationItem.rightBarButtonItem = barButton
        barButton.setup()
        barButton.setBadge(with: getProductToCartRealm().count)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories { (category) in
            self.categories = category
            self.categoryTable.reloadData()
        }
        cartButton()
    }
}

// MARK: - Extensions
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        cell.categoryImageView.layer.cornerRadius = 52
        cell.categoryNameLabel.text = categories[indexPath.row].name
        cell.categoryImageView.image = categories[indexPath.row].image != "" ? UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(categories[indexPath.row].image)")!)) : UIImage(named: "no_image")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UIBarButtonItem {
    func setBadge(with value: Int) {
        guard let productsCounter = customView?.viewWithTag(100) as? UILabel else { return }
        if value > 0 {
            productsCounter.isHidden = false
            productsCounter.text = "\(value)"
        } else {
            productsCounter.isHidden = true
        }
    }
    
    func setup() {
        customView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let productCounter = UILabel()
        productCounter.frame = CGRect(x: 20, y: 0, width: 15, height: 15)
        productCounter.backgroundColor = .red
        productCounter.tag = 100
        productCounter.clipsToBounds = true
        productCounter.layer.cornerRadius = 7
        productCounter.textColor = UIColor.white
        productCounter.font = UIFont.systemFont(ofSize: 10)
        productCounter.textAlignment = .center
        productCounter.isHidden = true
        productCounter.minimumScaleFactor = 0.1
        productCounter.adjustsFontSizeToFitWidth = true
        customView?.addSubview(productCounter)
    }
}
