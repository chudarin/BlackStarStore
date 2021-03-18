//
//  CategoryViewController.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 04.03.2021.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {
    
    var notificationToken: NotificationToken? = nil

    @IBOutlet weak var categoryTable: UITableView!

    var parsedJSON: ParsedJSON?
    var categoryID: [Int] = []
    var categories: [ShopCategory] = []
    var subCategories: [ShopSubcategory] = []
    var currentTitle = "Категории"
    var isRootCategory = true
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProductsListViewController, segue.identifier == "openProducts" {
            if let cell = sender as? UITableViewCell, let indexPath = categoryTable.indexPath(for: cell) {
                vc.productsID = decodeProductsID(id: subCategories[indexPath.row].id)
                vc.productsTitle = subCategories[indexPath.row].name
            }
        }
    }
    
    // MARK: - Cart Button
    @objc func openCart() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "Cart") as! CartViewController
        present(secondVc, animated: true, completion: nil)
    }
    
    func addCartButton() {
        let cartButton = UIButton(type: .custom)
        cartButton.setImage(UIImage(systemName: "cart.fill"), for: .normal)
        cartButton.addTarget(self, action: #selector(openCart), for: .touchUpInside)
        cartButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let barButton = UIBarButtonItem(customView: cartButton)
        self.navigationItem.rightBarButtonItem = barButton
        barButton.setup()
        barButton.setBadge(with: getCountOfProducts())
    }
    
    func decodeProductsID(id: OptionalTypes) -> Int {
        switch id {
        case .integer(let i): return i
        case .string(let s): return (s as NSString).integerValue
        }
    }
    
    // MARK: - Preparing Categories
    private func prepareCategories() {
        parsingJSON { (json) in
            self.parsedJSON = json
            if let json = self.parsedJSON {
                for (_, el) in json.innerArray.enumerated() {
                    self.categories.append(el.value)
                    self.categoryID.append((el.key as NSString).integerValue)
                }
            }
            self.categoryTable.reloadData()
        }
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCategories()
        self.title = currentTitle
        addCartButton()
        
        let realm = try! Realm()
        let results = realm.objects(ProductInCart.self)
        
        // Observe Results Notifications
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                self?.navigationItem.rightBarButtonItem?.setBadge(with: getCountOfProducts())
            case .update(_,  _, _, _):
                // Query results have changed, so apply them to the UITableView
                self?.navigationItem.rightBarButtonItem?.setBadge(with: getCountOfProducts())
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}

// MARK: - Extensions
extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRootCategory {
            return categories.count
        } else {
            return subCategories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryTableViewCell
        if isRootCategory {
            let category = categories[indexPath.row]
            cell.categoryNameLabel.text = category.name.withoutHtml
            if category.image != "" {
                cell.categoryImageView.downloadImageFrom(link: "https://blackstarshop.ru/\(category.image.cleanURL)", contentMode: .scaleAspectFit)
            } else {
                cell.categoryImageView.image = UIImage(named: "no_image")
            }
        } else {
            let category = subCategories[indexPath.row]
            cell.categoryImageView.layer.cornerRadius = 5
            cell.categoryNameLabel.text = category.name.withoutHtml
            if category.iconImage != "" {
                cell.categoryImageView.downloadImageFrom(link: "https://blackstarshop.ru/\(category.iconImage.cleanURL)", contentMode: .scaleAspectFit)
            } else {
                cell.categoryImageView.image = UIImage(named: "no_image")
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Если корневая и есть сабкатегории
        if isRootCategory && !categories[indexPath.row].subcategories.isEmpty {
            let vc = storyboard?.instantiateViewController(identifier: "CategoryVC") as! CategoryViewController
            vc.currentTitle = categories[indexPath.row].name.withoutHtml
            vc.subCategories = categories[indexPath.row].subcategories
            vc.isRootCategory = false
            self.navigationController?.pushViewController(vc, animated: true)
            
        // Если корневая и нет сабкатегорий
        } else if isRootCategory && categories[indexPath.row].subcategories.isEmpty {
            let vc = storyboard?.instantiateViewController(identifier: "ProductsListVC") as! ProductsListViewController
            vc.productsID = categoryID[indexPath.row]
            vc.productsTitle = categories[indexPath.row].name.withoutHtml
            self.navigationController?.pushViewController(vc, animated: true)
            
        // Все остальные
        } else {
            let vc = storyboard?.instantiateViewController(identifier: "ProductsListVC") as! ProductsListViewController
            vc.productsID = decodeProductsID(id: subCategories[indexPath.row].id)
            vc.productsTitle = subCategories[indexPath.row].name.withoutHtml
            self.navigationController?.pushViewController(vc, animated: true)
        }
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

extension UIImageView {
    func downloadImageFrom(link: String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask(with: URL(string: link)!) { (data, _, _) in
            DispatchQueue.main.async {
                self.contentMode = contentMode
                if let data = data { self.image = UIImage(data: data)?.withRenderingMode(.alwaysOriginal) }
            }
        }.resume()
    }
}

extension String {
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
    public var cleanURL: String {
        return self.replacingOccurrences(of: ".-h", with: "-h",
            options: NSString.CompareOptions.literal, range:nil)
    }
}
