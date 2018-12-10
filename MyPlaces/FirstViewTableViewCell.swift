//
//  FirstViewTableViewCell.swift
//  MyPlaces
//
//  Created by Albert Rovira on 17/11/2018.
//  Copyright © 2018 diphone. All rights reserved.
//

import UIKit

class FirstViewTableViewCell: UITableViewCell {

    @IBOutlet weak var nom: UILabel!
    @IBOutlet weak var imatge: UIImageView!
    @IBOutlet weak var descripcio: UILabel!
    @IBOutlet  var discount: UILabel!
    @IBOutlet weak var sale: UIImageView!
    @IBOutlet var title_trailing: NSLayoutConstraint!
    @IBOutlet var title_icon: NSLayoutConstraint!
    @IBOutlet var title_discount: NSLayoutConstraint!
    @IBOutlet var description_trailing: NSLayoutConstraint!
    @IBOutlet var description_icon: NSLayoutConstraint!
    @IBOutlet var description_discount: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
