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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
