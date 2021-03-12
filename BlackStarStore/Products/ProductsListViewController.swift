//
//  ProductsViewController.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 07.03.2021.
//

import UIKit

class ProductsListViewController: UIViewController {
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    var productsID: OptionalTypes?
    var productsTitle: String = ""
    var products: [Product] = []
    
    func decodeProductsID(id: OptionalTypes) -> Int {
        switch id {
        case .integer(let i): return i
        case .string(let s): return Int(s)!
        }
    }    
    
    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ProductViewController, segue.identifier == "openProductPage" {
            if let cell = sender as? UICollectionViewCell, let indexPath = productsCollectionView.indexPath(for: cell) {
                vc.productName = products[indexPath.row].name
                vc.productPrice = products[indexPath.row].price
                vc.productDescription = products[indexPath.row].description
                for i in products[indexPath.row].productImages {
                    vc.productGallery.append(i.imageURL)
                }
                vc.productOffers = products[indexPath.row].offers
                vc.productImageURL = "https://blackstarshop.ru/\(products[indexPath.row].mainImage)"
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
        loadProducts(id: decodeProductsID(id: productsID!)) { (parsedProducts) in
            self.products = parsedProducts
            self.productsCollectionView.reloadData()
        }
        self.title = productsTitle
        cartButton()
    }
    
}

// MARK: - Extensions
extension ProductsListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Product", for: indexPath) as! ProductsListCollectionViewCell
        
        cell.productImageView.contentMode = .scaleAspectFill
        
        cell.productNameLabel.text = products[indexPath.row].name
        cell.productDescriptionLabel.text = products[indexPath.row].description
        cell.productImageView.image = products[indexPath.row].mainImage != "" ? UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(products[indexPath.row].mainImage)")!)) : UIImage(named: "no_image")
        cell.productPriceLabel.text = convertToPrice(products[indexPath.row].price)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  5
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
    }
    
}
