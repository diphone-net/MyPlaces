//
//  DetailController.swift
//  MyPlaces
//
//  Created by user143580 on 25/9/18.
//  Copyright © 2018 diphone. All rights reserved.
//

import UIKit

class DetailController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{
    
    // obligat per ViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //num de columnes
    }

    // obligat per ViewDataSource
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return placesTypes.count // num d'elements
    }
    
    // necessari per ViewDataSource
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return placesTypes[row]
    }
    
    // controla el canvi al pickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        showTuristicMode(isTuristic: row == 1)
    }

    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var txtNotes: UITextView!
    
    @IBOutlet weak var btnUndo: UIButton!
    @IBOutlet weak var btnRandom: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    
    @IBOutlet weak var pkrType: UIPickerView!
    
    let placesTypes = ["Generic place","Touristic place"]

    var m_provider = ManagerPlaces.share()
    
    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // necessari per ViewDataSource
        self.pkrType.delegate = self
        self.pkrType.dataSource = self
        
        self.constraintHeight.constant = 400
        
        enableEdition(enable: place == nil)
        if (place != nil){
            fillData()
        }else{
            showTuristicMode(isTuristic: false)
        }
    }
    
    private func fillData(){
        txtName.text = place!.name
        txtNotes.text = place!.description
        txtId.text = place!.id
        showTuristicMode(isTuristic: false)
        pkrType.selectRow(0, inComponent: 0, animated: true)
        if (place!.type != PlaceTourist.PlacesTypes.GenericPlace){
            let touristPlace = place as! PlaceTourist
            txtDiscount.text = touristPlace.discount_tourist
            showTuristicMode(isTuristic: true)
        }
        
        // TODO segur que aixo es pot fer en 1 linia")
        if (place!.image != nil){
            img.image = UIImage(data: place!.image!)
        }
    }
    
    private func showTuristicMode(isTuristic: Bool){
        lblDiscount.isHidden = !isTuristic
        txtDiscount.isHidden = !isTuristic
        pkrType.selectRow(isTuristic ? 1 : 0, inComponent:0, animated: true)
    }
    
    private func enableEdition(enable: Bool){
        txtName.isEnabled = enable
        txtNotes.isUserInteractionEnabled = enable
        pkrType.isUserInteractionEnabled = enable
        txtDiscount.isEnabled = enable
        btnUndo.isHidden = !enable
        btnRandom.isHidden = !enable
        btnSave.isHidden = !enable
        btnRemove.isHidden = enable
    }
    
    @IBAction func btnRemove(_ sender: Any) {
        // el boton solo es visible cuando place tiene valor
        m_provider.remove(place!)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if txtName.text!.count < 1 || txtNotes.text!.count < 1 {
            let alert = UIAlertController(title: "Alerta", message: "Cal omplir tots els camps del Place per guardar-lo", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "D'acord", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if pkrType.selectedRow(inComponent: 0) == 0 {
            let place = Place(name: txtName.text!, description: txtNotes.text!, image_in: img.image?.pngData())
            m_provider.append(place)
        }else{
            let tplace = PlaceTourist(name: txtName.text!, description: txtNotes.text!, discount_tourist: txtDiscount.text!, image_in: img.image?.pngData())
            m_provider.append(tplace)	
        }
        btnBack(sender)
    }
    
 
    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnRandomTemporal(_ sender: Any) {
        let texts = ["Plaça", "Museu", "Carrer", "Botiga", "Lloc indeterminat"]
        let descripcions = ["blava del cel blau", "de les arts", "angel suprem", "groc pàlid", "maravellós"]
        let imgs = ["ball.jpg", "ghost.png", "yoga.jpg"]
        
        var rand = Int(arc4random_uniform(UInt32(texts.count)))
        txtName.text = texts[rand]
        rand = Int(arc4random_uniform(UInt32(descripcions.count)))
        txtNotes.text = descripcions[rand]
        if (Int(arc4random_uniform(2)) == 1){
            rand = Int(arc4random_uniform(100))
            txtDiscount.text = String(rand)
            showTuristicMode(isTuristic: true)
        }else{
            showTuristicMode(isTuristic: false)
        }
        
        rand = Int(arc4random_uniform(UInt32(imgs.count)))
        img.image = UIImage(named:imgs[rand])
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
