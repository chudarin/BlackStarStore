//
//  SubCategoryViewController.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 07.03.2021.
//

import UIKit

class SubCategoryViewController: UIViewController {

    @IBOutlet weak var subCategoryTable: UITableView!
    
    var subCategories: [ShopSubcategory] = []
    var subCategoryTitle: String = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProductsViewController, segue.identifier == "openProducts" {
            if let cell = sender as? UITableViewCell, let indexPath = subCategoryTable.indexPath(for: cell) {
                vc.productsID = subCategories[indexPath.row].id
                vc.productsTitle = subCategories[indexPath.row].name
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = subCategoryTitle
    }

}

extension SubCategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCategoryCell", for: indexPath) as! SubCategoryTableViewCell
        cell.subCategoryNameLabel.text = subCategories[indexPath.row].name
        cell.subCategoryImageView.image = subCategories[indexPath.row].iconImage != "" ? UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(subCategories[indexPath.row].iconImage)")!)) : UIImage(named: "no_image")
        return cell
    }
}
