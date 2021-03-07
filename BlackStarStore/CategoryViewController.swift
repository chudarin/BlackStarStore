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
        cell.categoryNameLabel.text = categories[indexPath.row].name
        cell.categoryImageView.image = UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(categories[indexPath.row].image)")!))
        return cell
    }
}
