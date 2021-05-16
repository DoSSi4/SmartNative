//
//  ProductCell.swift
//  smartnative
//
//  Created by DoSSi4 on 16.05.2021.
//

import UIKit

class ProductCell: UICollectionViewCell {
    @IBOutlet weak var prodImg: UIImageView!
    @IBOutlet weak var prodTitle: UILabel!
    @IBOutlet weak var prodPrice: UILabel!
    static let identifier = "ProductCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
