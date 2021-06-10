//
//  CatalogCell.swift
//  smartnative
//
//  Created by DoSSi4 on 09.05.2021.
//

import UIKit

class CatalogCell: UITableViewCell {
    @IBOutlet weak var catalogImage: UIImageView!
    @IBOutlet weak var catalogLabel: UILabel!
    static let identifier = "CatalogCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func goToCategory(_ sender: Any) {
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
