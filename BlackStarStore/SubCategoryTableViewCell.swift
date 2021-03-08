//
//  SubCategoryTableViewCell.swift
//  BlackStarStore
//
//  Created by Sergey Chudarin on 07.03.2021.
//

import UIKit

class SubCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var subCategoryImageView: UIImageView!
    @IBOutlet weak var subCategoryNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
