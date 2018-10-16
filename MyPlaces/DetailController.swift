//
//  DetailController.swift
//  MyPlaces
//
//  Created by user143580 on 25/9/18.
//  Copyright © 2018 diphone. All rights reserved.
//

import UIKit

class DetailController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate{
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var lblDiscount: UILabel!
    
    @IBOutlet weak var btnUndo: UIButton!
    @IBOutlet weak var btnRandom: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var viewPicker: UIPickerView!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var textDiscount: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var keyboardHeigh: CGFloat!
    var activeField: UIView!
    var lastOffset: CGPoint! // canviat de CGFloat
    let pickerElems1 = ["Generic place","Touristic place"]
    var m_provider = ManagerPlaces.share()
    var place: Place?
    
    // MARK Codi requerit pel picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //num de columnes
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerElems1.count // num d'elements
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerElems1[row]
    }
    
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        view.endEditing(true)
        //let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePicked.contentMode = .scaleAspectFit
        imagePicked.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateTuristicMode()
    }
    
    // MARK Requerit pels controls de posicionament i mostrar teclat
    @objc func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        activeField = textView
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    @objc func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if (activeField == textView){
            activeField?.resignFirstResponder() //??
            activeField = nil
        }
        return true
    }
    
    @objc func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        return true
    }
    
    @objc func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (activeField == textField){
            activeField?.resignFirstResponder()
            activeField = nil
        }
        return true
    }
    
    @objc func showKeyboard(notification: Notification){
        if (activeField != nil){
            let userInfo = notification.userInfo!
            let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
            keyboardHeigh = keyboardViewEndFrame.size.height
            moveScrollView()
        }
    }
    
    /*
     pinta(desde: #function)
    func pinta(desde functionname: String){
        print("Time: \(NSDate()), Function: \(functionname) ")
            //, line: \(#line) )
            //NameDelegate: \(textName.delegate!.hash) DescripcionDelegate: \(textDescription.delegate!.hash)")
        print("Alcada self: \(self.constraintHeight.constant) Alcada scroll: \(self.scrollView.frame.size.height)")
    }
    */
    
    func moveScrollView(){
        let distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
        let collapseSpace = keyboardHeigh - distanceToBottom
        if (collapseSpace > 0){
            self.scrollView.setContentOffset(CGPoint(x: self.lastOffset.x, y:collapseSpace + 10), animated: false)
            self.constraintHeight.constant += self.keyboardHeigh
        }else{
            keyboardHeigh = nil
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @objc func hideKeyboard(notification: Notification){
        if (keyboardHeigh != nil){
            self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y:self.lastOffset.y)
            self.constraintHeight.constant -= self.keyboardHeigh
        }
        keyboardHeigh = nil
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // necessari per ViewDataSource
        viewPicker.delegate = self
        viewPicker.dataSource = self
        textName.delegate = self
        textDescription.delegate = self
        textDiscount.delegate = self
        
        //self.constraintHeight.constant = 400
        
        // MARK Requerit pels events de teclat
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        if (place != nil){
            fillData()
        }else{
            btnUpdate.setTitle("New", for: .normal)
        }
        updateTuristicMode()
    }
    
    private func fillData(){
        assert(place != nil,"Realizando fillData sin place!")
        
        textName.text = place!.name
        textDescription.text = place!.description
        txtId.text = place!.id
        viewPicker.selectRow(place!.type.rawValue, inComponent: 0, animated: true)
        if (place!.type != PlaceTourist.PlacesTypes.GenericPlace){
            let touristPlace = place as! PlaceTourist
            textDiscount.text = touristPlace.discount_tourist
        }
        updateTuristicMode()
        
        // TODO segur que aixo es pot fer en 1 linia")
        if (place!.image != nil){
            imagePicked.image = UIImage(data: place!.image!)
        }
    }
    
    private func updateTuristicMode(){
        let isTuristic = viewPicker.selectedRow(inComponent: 0) == 1
        lblDiscount.isHidden = !isTuristic
        textDiscount.isHidden = !isTuristic
    }
    
    // MARK Actions dels buttons
    @IBAction func btnRemove(_ sender: Any) {
        // el boton solo es visible cuando place tiene valor
        m_provider.remove(place!)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        if textName.text!.count < 1 || textDescription.text!.count < 1 {
            let alert = UIAlertController(title: "Alerta", message: "Cal omplir tots els camps del Place per guardar-lo", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "D'acord", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let willBeTuristic = viewPicker.selectedRow(inComponent: 0) != 0
        if place != nil && ((place is PlaceTourist && !willBeTuristic) || (!(place is PlaceTourist) && willBeTuristic)){
            // si canvia el tipus, l'elimino i el crearem de nou
            m_provider.remove(place!)
            place = nil
        }
        if (place == nil){
            if !willBeTuristic {
                place = Place(name: textName.text!, description: textDescription.text!, image_in: imagePicked.image?.pngData())
            }else{
                place = PlaceTourist(name: textName.text!, description: textDescription.text!, discount_tourist: textDiscount.text!, image_in: imagePicked.image?.pngData())
            }
            m_provider.append(place!)
        }else{
            place!.name = textName.text!
            place!.description = textDescription.text!
            place!.image = imagePicked.image?.pngData()
            if (place is PlaceTourist){
                (place as! PlaceTourist).discount_tourist = textDiscount.text!
            }
        }
        btnBack(sender)
    }
    
    @IBAction func btnSelectImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
        viewPicker.selectRow(Int(arc4random_uniform(2)) , inComponent: 0, animated: true)
        if (Int(arc4random_uniform(2)) == 1){
            rand = Int(arc4random_uniform(100))
            textDiscount.text = String(rand)
        }
        updateTuristicMode()
        
        rand = Int(arc4random_uniform(UInt32(imgs.count)))
        imagePicked.image = UIImage(named:imgs[rand])
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
