//
//  DetailController.swift
//  MyPlaces
//
//  Created by user143580 on 25/9/18.
//  Copyright © 2018 diphone. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var segType: UISegmentedControl!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var btnUndo: UIButton!
    @IBOutlet weak var btnRandom: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    
    
    var m_provider = ManagerPlaces.share()
    
    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sempre arribem aqui amb place assignat pero pel que fos, crido aquesta funcio si fos que no
        self.constraintHeight.constant = 400
        
        enableEdition(enable: place == nil)
        if (place != nil){
            txtName.text = place!.name
            txtDescription.text = place!.description
            txtId.text = place!.id
            showTuristicMode(isTuristic: false)
            if (place!.type != PlaceTourist.PlacesTypes.GenericPlace){
                let touristPlace = place as! PlaceTourist
                txtDiscount.text = touristPlace.discount_tourist
                showTuristicMode(isTuristic: true)
            }
            // TODO: segur que aixo es pot fer en 1 linia
            if (place!.image != nil){
                img.image = UIImage(data: place!.image!)
            }
        }
    }
    
    private func showTuristicMode(isTuristic: Bool){
        lblDiscount.isHidden = !isTuristic
        txtDiscount.isHidden = !isTuristic
        segType.selectedSegmentIndex = isTuristic ? 1 : 0
    }
    
    private func enableEdition(enable: Bool){
        txtName.isEnabled = enable
        txtDescription.isEnabled = enable
        // txtId by desing
        segType.isEnabled = enable
        txtDiscount.isEnabled = enable
        btnUndo.isHidden = !enable
        btnRandom.isHidden = !enable
        btnSave.isHidden = !enable
        btnRemove.isHidden = enable
    }
    
   // MARK: Codi temporal PLA1

    @IBAction func removeTemporal(_ sender: Any) {
        // el boton solo es visible cuando place tiene valor
        m_provider.remove(place!)
        navigationController?.popViewController(animated: true)
        //undoTemporal(sender)
    }
    
    @IBAction func saveTemporal(_ sender: Any) {
        if segType.selectedSegmentIndex == 0 {
            let place = Place(name: txtName.text!, description: txtDescription.text!, image_in: img.image?.pngData())
            m_provider.append(place)
        }else{
            let tplace = PlaceTourist(name: txtName.text!, description: txtDescription.text!, discount_tourist: txtDiscount.text!, image_in: img.image?.pngData())
            m_provider.append(tplace)	
        }
        undoTemporal(sender)
    }
    
 
    @IBAction func undoTemporal(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func randomTemporal(_ sender: Any) {
        let texts = ["Plaça", "Museu", "Carrer", "Botiga", "Lloc indeterminat"]
        let descripcions = ["blava del cel blau", "de les arts", "angel suprem", "groc pàlid", "maravellós"]
        let imgs = ["ball.jpg", "ghost.png", "yoga.jpg"]
        
        var rand = Int(arc4random_uniform(UInt32(texts.count)))
        txtName.text = texts[rand]
        rand = Int(arc4random_uniform(UInt32(descripcions.count)))
        txtDescription.text = descripcions[rand]
        if (Int(arc4random_uniform(2)) == 1){
            rand = Int(arc4random_uniform(100))
            txtDiscount.text = String(rand)
            showTuristicMode(isTuristic: true)
        }else{
            showTuristicMode(isTuristic: false)
        }
        
        rand = Int(arc4random_uniform(UInt32(imgs.count)))
        img.image = UIImage(named:imgs[rand])
        //print(imgs[rand])
        //img = UIImageView(image:
        //let mida: CGFloat = 50
        //imageIcon.frame = CGRect(x:wt - mida - 10, y:40, width:mida, height:mida)
    }
    @IBAction func Close(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
