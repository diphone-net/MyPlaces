//
//  Sytler.swift
//  MyPlaces
//
//  Created by Albert Rovira on 19/11/2018.
//  Copyright © 2018 diphone. All rights reserved.
//

import Foundation
import UIKit

class Styler{
    
    func recursiveSetStyle(v:UIView)
    {
        //v.backgroundColor = UIColor(patternImage: UIImage(named: "background-1080x1920.jpg")!)
        // els backgrounds de moment els he establert a mà
        
        let colorCacaOca = UIColor(rgb: 0xF9C938, alpha: 1)
        
        if let b = v as? UIButton {
            b.backgroundColor = UIColor.black
            b.tintColor = colorCacaOca
            b.layer.cornerRadius = 10
            //b.layer.borderWidth = 1
            //b.layer.borderColor = colorCacaOca.cgColor
        }
        if let t = v as? UITextField {
            t.backgroundColor = UIColor.clear
        }
        if let t2 = v as? UITextView {
            t2.backgroundColor = UIColor.clear
            t2.layer.borderWidth = 1
            t2.layer.borderColor = UIColor.black.cgColor
            t2.layer.cornerRadius = 10
        }
        if let i = v as? UIImageView{
            i.layer.borderWidth = 1
            i.layer.borderColor = UIColor.black.cgColor
            i.layer.cornerRadius = 10
            // imatges rodones
            //cell.imatge.layer.cornerRadius = cell.imatge.frame.size.width / 2
            i.clipsToBounds = true
        }
        for subview in v.subviews {
            self.recursiveSetStyle(v: subview)
        }
    }
    
    //MARK: Singleton
    private static var sharedStyler: Styler = {
        // El creem i el retornem
        return Styler()
    }()
    
    class func shared() -> Styler{
        return sharedStyler
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(rgb: Int, alpha: CGFloat) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            alpha: alpha
        )
    }
}
