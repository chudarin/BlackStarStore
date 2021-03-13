//
//  SubCategoryViewController.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 07.03.2021.
//

import UIKit

class SubCategoryViewController: UIViewController {
    
//    var subCategories: [ShopSubcategory] = []
//    var subCategoryTitle: String = ""
    
    // MARK: - Prepare for Seque
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? ProductsListViewController, segue.identifier == "openProducts" {
//            if let cell = sender as? UITableViewCell, let indexPath = categoryTable.indexPath(for: cell) {
//                vc.productsID = subCategories[indexPath.row].id
//                vc.productsTitle = subCategories[indexPath.row].name
//            }
//        }
//    }
//
//    // MARK: - Cart Button
//    @objc func openCart() {
//        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let secondVc = storyboard.instantiateViewController(withIdentifier: "Cart") as! CartViewController
//        present(secondVc, animated: true, completion: nil)
//    }
//
//    public func cartButton() {
//        let cartButton = UIButton(type: .custom)
//        cartButton.setImage(UIImage(systemName: "cart.fill"), for: .normal)
//        cartButton.addTarget(self, action: #selector(openCart), for: .touchUpInside)
//        cartButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
//        let barButton = UIBarButtonItem(customView: cartButton)
//        self.navigationItem.rightBarButtonItem = barButton
//        barButton.setup()
//        barButton.setBadge(with: getProductToCartRealm().count)
//    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
        view.backgroundColor = .white
//        self.title = subCategoryTitle
//        cartButton()
    }

}
//
//// MARK: - Extensions
//extension SubCategoryViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return subCategories.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "subCategoryCell", for: indexPath) as! SubCategoryTableViewCell
//        cell.subCategoryNameLabel.text = subCategories[indexPath.row].name
//        cell.subCategoryImageView.image = subCategories[indexPath.row].iconImage != "" ? UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(subCategories[indexPath.row].iconImage)")!)) : UIImage(named: "no_image")
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
//
