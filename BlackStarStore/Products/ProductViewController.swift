//
//  ProductViewController.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 09.03.2021.
//

import UIKit

class ProductViewController: UIViewController {
    
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
    
    @objc func openModal() {
        let modalVC = ModalWindowViewController()
        modalVC.modalPresentationStyle = .custom
        modalVC.transitioningDelegate = self
        
        for i in productOffers {
            modalVC.sizes.append(i.size)
        }
        
        self.present(modalVC, animated: true, completion: nil)
    }
    
    func setupProductFrame() {
        addToCartButton.frame.size.height = 48
        addToCartButton.layer.cornerRadius = addToCartButton.frame.height / 4
        addToCartButton.setTitle("Добавить в корзину".uppercased(), for: .normal)
        
        productNameLabel.adjustsFontSizeToFitWidth = true
        productNameLabel.minimumScaleFactor = 0.2
        productNameLabel.text = productName ?? "Не указано"
        
        productPriceLabel.text = ProductsListViewController().convertToPrice(productPrice ?? "Не указано")
        
        productDescriptionTextView.sizeToFit()
        productDescriptionTextView.isScrollEnabled = false
        productDescriptionTextView.text = productDescription ?? "Не указано"
                
        productGalleryControl.numberOfPages = productGallery.count
        productGalleryControl.isHidden = !(productGallery.count > 1)
        productGalleryControl.currentPage = 0
    }
    
    override func viewDidLoad() {
        
        setupProductFrame()
        self.productGalleryCollectionView.reloadData()
        super.viewDidLoad()
    }
}

extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productGallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
        cell.backgroundColor = .systemGray5
        cell.productImageView.contentMode = .scaleAspectFill
        cell.productImageView.frame.size.width = view.frame.size.width
        cell.productImageView.image = !productGallery.isEmpty ? UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(productGallery[indexPath.row])")!)) : UIImage(named: "no_image")
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
