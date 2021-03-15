//
//  CategoryTableViewCell.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 04.03.2021.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImageView.layer.cornerRadius = categoryImageView.frame.size.height / 2
        categoryImageView.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
