//
//  SideMenuCell.swift
//  smartnative
//
//  Created by DoSSi4 on 10.06.2021.
//

import UIKit

class SideMenuCell: UITableViewCell {
    public static let identifier = "SideMenuCell"
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
