//
//  CategoryCell.swift
//  smartnative
//
//  Created by DoSSi4 on 09.05.2021.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    static let identifier = "CategoryCell"
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
