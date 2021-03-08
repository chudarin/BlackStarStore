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
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SubCategoryViewController, segue.identifier == "openSubCategory" {
            if let cell = sender as? UITableViewCell, let indexPath = categoryTable.indexPath(for: cell) {
                vc.subCategories = categories[indexPath.row].subcategories
                vc.subCategoryTitle = categories[indexPath.row].name
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories { (category) in
            self.categories = category
            self.categoryTable.reloadData()
        }
    }
}

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
