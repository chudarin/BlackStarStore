//
//  ModalWindowViewController.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 10.03.2021.
//

import UIKit

class ModalWindowViewController: UIViewController {
    
    @IBOutlet weak var slideIndicator: UIView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBAction func addToCartButtonAction(_ sender: Any) {
        addProductToCartRealm(imageURL: productImage, name: productName, size: sizes[selectedSize], color: colors[selectedColor], price: productPrice)
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var sizeAndColorPickerView: UIPickerView!
    @IBOutlet weak var closeButton: UIButton!
    @IBAction func closeButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /* PASS THE DATA FOR REALM */
    var productImage: String = ""
    var productName: String = ""
    var productPrice: String = ""
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    var colors = ["Red", "Blue", "Green", "Black", "White", "Yellow", "Brown", "Orange", "Violet"]
    var sizes: [String] = []
    var selectedSize: Int = 0
    var selectedColor: Int = 0
    

    // MARK: - Setup Modal Frame
    func setupModalFrame() {
        sizeAndColorPickerView.delegate = self
        sizeAndColorPickerView.dataSource = self
        sizeAndColorPickerView.backgroundColor = .systemGray6
        addToCartButton.setTitle("Выбрать", for: .normal)
        closeButton.setTitle("Закрыть", for: .normal)
        sizeAndColorPickerView.layer.cornerRadius = 8
        addToCartButton.layer.cornerRadius = 8
        slideIndicator.layer.cornerRadius = 2
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupModalFrame()
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}

// MARK: - Extensions
extension ModalWindowViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return colors.count
        } else {
            return sizes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return colors[row]
        } else {
            return sizes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent  component: Int) {
        if component == 0 {
            selectedColor = row
        } else {
            selectedSize = row
        }
    }
}
