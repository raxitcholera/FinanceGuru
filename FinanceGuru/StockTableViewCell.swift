//
//  StockTableViewCell.swift
//  FinanceGuru
//
//  Created by Raxit Cholera on 7/5/17.
//  Copyright © 2017 Raxit Cholera. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {

    @IBOutlet weak var companyNameLbl: UILabel!
    @IBOutlet weak var UnitsLbl: UILabel!
    @IBOutlet weak var costbasisLbl: UILabel!
    @IBOutlet weak var gainLbl: UILabel!
    
    @IBOutlet weak var gainPercentLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
