//
//  ProductViewController.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 09.03.2021.
//

import UIKit
import RealmSwift

class ProductViewController: UIViewController {
    
    var notificationToken: NotificationToken? = nil
    
    @IBOutlet weak var productGalleryCollectionView: UICollectionView!
    @IBOutlet weak var productGalleryControl: UIPageControl!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBAction func addToCartButton(_ sender: Any) {
        openModal()
    }
    @IBOutlet weak var productDescriptionTextView: UITextView!
    
    var productGallery: [String] = []
    var productName: String?
    var productPrice: String?
    var productDescription: String?
    var productOffers: [Offers] = []
    var productImageURL: String = ""
    
    // MARK: - Open Modal Func
    @objc func openModal() {
        let modalVC = ModalWindowViewController()
        
        modalVC.modalPresentationStyle = .custom
        modalVC.transitioningDelegate = self
        
        /* TRANSIT DATA FOR REALM */
        modalVC.productName = productName!
        modalVC.productPrice = productPrice!
        modalVC.productImage = productImageURL
        
        for i in productOffers {
            modalVC.sizes.append(i.size)
        }
        
        self.present(modalVC, animated: true, completion: nil)
    }
    
    // MARK: - Setup Product Frame
    func setupProductFrame() {
        addToCartButton.frame.size.height = 48
        addToCartButton.layer.cornerRadius = addToCartButton.frame.height / 4
        addToCartButton.setTitle("Добавить в корзину".uppercased(), for: .normal)
        
        productNameLabel.adjustsFontSizeToFitWidth = true
        productNameLabel.minimumScaleFactor = 0.2
        productNameLabel.text = productName?.withoutHtml ?? "Не указано"
        
        productPriceLabel.text = convertToPrice(productPrice ?? "Не указано")
        
        productDescriptionTextView.sizeToFit()
        productDescriptionTextView.isScrollEnabled = false
        productDescriptionTextView.text = productDescription?.withoutHtml ?? "Не указано"
                
        productGalleryControl.numberOfPages = productGallery.count
        productGalleryControl.isHidden = !(productGallery.count > 1)
        productGalleryControl.currentPage = 0
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
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationItem.backBarButtonItem?.menu = nil
        setupProductFrame()
        addCartButton()
        self.productGalleryCollectionView.reloadData()
        print(productImageURL)
        
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
extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if productGallery.count != 0 {
            return productGallery.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
                
        cell.backgroundColor = .systemGray5
        cell.productImageView.contentMode = .scaleAspectFill
        cell.productImageView.frame.size.width = view.frame.size.width
        if productGallery.count != 0 {
            cell.productImageView.downloadImageFrom(link: "https://blackstarshop.ru/\(productGallery[indexPath.row])", contentMode: .scaleAspectFill)
        } else {
            cell.productImageView.downloadImageFrom(link: "\(productImageURL)", contentMode: .scaleAspectFill)
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productGalleryCollectionView.frame.width, height: productGalleryCollectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        productGalleryControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        productGalleryControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}
