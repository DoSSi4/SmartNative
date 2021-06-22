//
//  CartCell.swift
//  smartnative
//
//  Created by DoSSi4 on 10.06.2021.
//

import UIKit

class CartCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var measureLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var measureTxtFld: UITextField!
    public static let identifier = "CartCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.autorepeat = true
    }
    @IBAction func stepperAction(_ sender: UIStepper) {
        measureTxtFld.text = sender.value.description
        let IntValue = Double(priceLbl.text!)
        totalLbl.text = "\(IntValue! * sender.value)"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
