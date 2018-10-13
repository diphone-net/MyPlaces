//
//  DetailController.swift
//  MyPlaces
//
//  Created by user143580 on 25/9/18.
//  Copyright © 2018 diphone. All rights reserved.
//

import UIKit

class DetailController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{
    


    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var txtDiscount: UITextField!
    @IBOutlet weak var lblDiscount: UILabel!
    
    @IBOutlet weak var btnUndo: UIButton!
    @IBOutlet weak var btnRandom: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var viewPicker: UIPickerView!
    @IBOutlet weak var imagePicker: UIImageView!

    let pickerElems1 = ["Generic place","Touristic place"]

    var m_provider = ManagerPlaces.share()
    
    var place: Place?
    
    // MARK Codi requerit pel picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //num de columnes
    }
    
    // obligat per ViewDataSource
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerElems1.count // num d'elements
    }
    
    // necessari per ViewDataSource
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerElems1[row]
    }
    
    // controla el canvi al pickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        showTuristicMode(isTuristic: row == 1)
    }
    
    @IBAction func btnSelectImage(_ sender: Any) {
        #warning("pendent")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // necessari per ViewDataSource
        viewPicker.delegate = self
        viewPicker.dataSource = self
        
        self.constraintHeight.constant = 400
        
        enableEdition(enable: place == nil)
        if (place != nil){
            fillData()
        }else{
            showTuristicMode(isTuristic: false)
        }
    }
    
    private func fillData(){
        assert(place != nil,"Realizando fillData sin place!")
        
        textName.text = place!.name
        textDescription.text = place!.description
        txtId.text = place!.id
        showTuristicMode(isTuristic: false)
        viewPicker.selectRow(0, inComponent: 0, animated: true)
        if (place!.type != PlaceTourist.PlacesTypes.GenericPlace){
            let touristPlace = place as! PlaceTourist
            txtDiscount.text = touristPlace.discount_tourist
            showTuristicMode(isTuristic: true)
        }
        
        // TODO segur que aixo es pot fer en 1 linia")
        if (place!.image != nil){
            imagePicker.image = UIImage(data: place!.image!)
        }
    }
    
    private func showTuristicMode(isTuristic: Bool){
        lblDiscount.isHidden = !isTuristic
        txtDiscount.isHidden = !isTuristic
        viewPicker.selectRow(isTuristic ? 1 : 0, inComponent:0, animated: true)
    }
    
    private func enableEdition(enable: Bool){
        textName.isEnabled = enable
        textDescription.isUserInteractionEnabled = enable
        viewPicker.isUserInteractionEnabled = enable
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
        if textName.text!.count < 1 || textDescription.text!.count < 1 {
            let alert = UIAlertController(title: "Alerta", message: "Cal omplir tots els camps del Place per guardar-lo", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "D'acord", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if viewPicker.selectedRow(inComponent: 0) == 0 {
            let place = Place(name: textName.text!, description: textDescription.text!, image_in: imagePicker.image?.pngData())
            m_provider.append(place)
        }else{
            let tplace = PlaceTourist(name: textName.text!, description: textDescription.text!, discount_tourist: txtDiscount.text!, image_in: imagePicker.image?.pngData())
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
        textName.text = texts[rand]
        rand = Int(arc4random_uniform(UInt32(descripcions.count)))
        textDescription.text = descripcions[rand]
        if (Int(arc4random_uniform(2)) == 1){
            rand = Int(arc4random_uniform(100))
            txtDiscount.text = String(rand)
            showTuristicMode(isTuristic: true)
        }else{
            showTuristicMode(isTuristic: false)
        }
        
        rand = Int(arc4random_uniform(UInt32(imgs.count)))
        imagePicker.image = UIImage(named:imgs[rand])
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
