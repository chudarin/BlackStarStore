//
//  CategoryViewController.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 04.03.2021.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryTable: UITableView!
    
//    let categories: [WelcomeValue]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoadCategories { (category) in
//            for (n, i) in category. {
//                categories.append(category[i])
//            }
            print(category)
        }
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        return cell
    }
}
