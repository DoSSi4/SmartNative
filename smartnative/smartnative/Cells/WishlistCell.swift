//
//  WishlistCell.swift
//  smartnative
//
//  Created by DoSSi4 on 02.06.2021.
//

import UIKit

class WishlistCell: UITableViewCell {
    static let identifier = "WishlistCell"
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        productImg.layer.cornerRadius = 20
        productImg.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
    
}
