//
//  ProductViewController.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 09.03.2021.
//

import UIKit

class ProductViewController: UIViewController {
    
    @IBOutlet weak var productGalleryImageView: UIImageView!
    @IBOutlet weak var productGalleryControl: UIPageControl!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    
    var productGallery: [String] = []
    var productName: String?
    var productPrice: String?
    var productDescription: String?
    
    func setupProductFrame() {
        
        addToCartButton.frame.size.height = 36
        addToCartButton.layer.cornerRadius = addToCartButton.frame.height / 4
        addToCartButton.setTitle("Добавить в корзину".uppercased(), for: .normal)
        
        productNameLabel.adjustsFontSizeToFitWidth = true
        productNameLabel.minimumScaleFactor = 0.2
        productNameLabel.text = productName ?? "Не указано"
        
        productPriceLabel.text = ProductsListViewController().convertToPrice(productPrice ?? "Не указано")
        
        productDescriptionTextView.sizeToFit()
        productDescriptionTextView.isScrollEnabled = false
        productDescriptionTextView.text = productDescription ?? "Не указано"
        
        productGalleryImageView.contentMode = .scaleAspectFill
        productGalleryImageView.image = !productGallery.isEmpty ? UIImage(data: try! Data(contentsOf: URL(string: "https://blackstarshop.ru/\(productGallery[0])")!)) : UIImage(named: "no_image")
    }
    
    override func viewDidLoad() {
        
        setupProductFrame()
        
        super.viewDidLoad()
    }
}
