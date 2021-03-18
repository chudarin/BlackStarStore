//
//  ProductsViewController.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 07.03.2021.
//

import UIKit
import RealmSwift

class ProductsListViewController: UIViewController {
    
    var notificationToken: NotificationToken? = nil
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var productsID: Int?
    var categoryID: Int?
    var productsTitle: String = ""
    var products: [Product] = []
    
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
    
    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProductViewController, segue.identifier == "openProductPage" {
            if let cell = sender as? UICollectionViewCell, let indexPath = productsCollectionView.indexPath(for: cell) {
                vc.productName = products[indexPath.row].name
                vc.productPrice = products[indexPath.row].price
                vc.productDescription = products[indexPath.row].description
                for i in products[indexPath.row].productImages {
                    vc.productGallery.append(i.imageURL.cleanURL)
                }
                vc.productOffers = products[indexPath.row].offers
                vc.productImageURL = "https://blackstarshop.ru/\(products[indexPath.row].mainImage.cleanURL)"
            }
        }
    }
    
    // Check for empty pages
    private func showEmptyCategoryMessage() {
        let labelSize = CGSize(width: 150, height: 30)
        let emptyCategoryLabel = UILabel(frame: CGRect(x: 0, y: 0, width: labelSize.width, height: labelSize.height))
        emptyCategoryLabel.text = "Категория пуста"
        productsCollectionView.isHidden = true
        view.backgroundColor = .systemGray5
        view.addSubview(emptyCategoryLabel)
        emptyCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyCategoryLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        emptyCategoryLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if productsID != 0 && productsID != 123  {
            loadProducts(id: productsID!) { (parsedProducts) in
                self.products = parsedProducts
                self.productsCollectionView.reloadData()
            }
        } else {
            showEmptyCategoryMessage()
        }
        
        self.title = productsTitle
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
extension ProductsListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Product", for: indexPath) as! ProductsListCollectionViewCell
        
        let product = products[indexPath.row]
        cell.productImageView.contentMode = .scaleAspectFill
        cell.productNameLabel.text = product.name.withoutHtml
        cell.productDescriptionLabel.text = product.description.withoutHtml
        cell.productImageView.downloadImageFrom(link: "https://blackstarshop.ru/\(product.mainImage.cleanURL)", contentMode: .scaleAspectFill)
        cell.productPriceLabel.text = convertToPrice(product.price)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  5
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
}
