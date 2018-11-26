//
//  DetailController.swift
//  MyPlaces
//
//  Created by user143580 on 25/9/18.
//  Copyright © 2018 diphone. All rights reserved.
//

import UIKit
import Foundation
import MapKit

class DetailController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate, ManagerPlacesStoreObserver{
    @IBOutlet weak var constraintHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblUbicacion: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var btnUndo: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textDescription: UITextView!
    @IBOutlet weak var viewPicker: UIPickerView!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var textDiscount: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var trailingRemoveButton: NSLayoutConstraint!
    @IBOutlet weak var leadingCancelButton: NSLayoutConstraint!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var keyboardHeigh: CGFloat!
    var activeField: UIView!
    var lastOffset: CGPoint! // canviat de CGFloat
    let pickerElements = ["Generic","Touristic","Comercial"]
    var m_provider = ManagerPlaces.shared()
    var place: Place?
    var styler = Styler.shared()
    
    let m_location_manager: ManagerLocation = ManagerLocation.shared()
    
    // MARK: Codi requerit pel picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //num de columnes
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerElements.count // num d'elements
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerElements[row]
    }
    
    //func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Dona el seguent error però em comentat que l'ignorem
        // [discovery] errors encountered while discovering extensions: Error Domain=PlugInKit Code=13 "query cancelled" UserInfo={NSLocalizedDescription=query cancelled}
        
        //print(UIImagePickerController.isSourceTypeAvailable(.photoLibrary))
        view.endEditing(true)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePicked.contentMode = .scaleAspectFit
        imagePicked.image = image
        dismiss(animated: true, completion: nil)
        imagePicked.alpha = 1
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateTuristicMode()
    }
    
    // MARK: Requerit pels controls de posicionament i mostrar teclat
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
    
    // MARK: Inici del Controller en si
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // posar estils als objectes de la view
        styler.recursiveSetStyle(v: self.view)
        
        // necessari per ViewDataSource
        viewPicker.delegate = self
        viewPicker.dataSource = self
        textName.delegate = self
        textDescription.delegate = self
        textDiscount.delegate = self
        
        // assignem al delegate del managerplaces el DetailControler
        m_provider.storeDelegate = self
        
        // teclat numèric per defecte pel discount
        textDiscount.keyboardType = UIKeyboardType.numberPad

        // afegir click a la imatge per canviar d'imatge
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage(_:)))
        imagePicked.isUserInteractionEnabled = true
        imagePicked.addGestureRecognizer(tapGestureRecognizer)
        
        // mostrar botons que toquen
        if (place != nil){
            btnUndo.isHidden = true
            leadingCancelButton.isActive = false
        }else{
            btnRemove.isHidden = true
            trailingRemoveButton.isActive = false
        }
        
        // amagar activityIndicator
        activityIndicator.hidesWhenStopped = true
        
        
        // volia posar l'alçada en funció del botó inferior però no sé com va
        self.constraintHeight.constant = 100
        //self.constraintHeight.constant = self.btnUndo.frame.origin.y + self.btnUndo.frame.size.height + 10
        
        //Requerit pels events de teclat
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        #warning("Sobra una lin")
        
        if (place != nil){
            fillData()
        }else{
            btnUpdate.setTitle("New", for: .normal)
            fillDataNew()
        }
        updateTuristicMode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // es fa aquí i no al viewDidLoad perquè allà encara no es poden mostrar alerts
        checkStatusLocation()
    }
    
    private func fillData(){
        assert(place != nil,"Realizando fillData sin place!")
        
        textName.text = place!.name
        textDescription.text = place!.description
        lblId.text = "ID: \(place!.id)"
        
        // sempre té ubicacio
        fillDataLocationAndDistance(placeLocation: place!.location)
        
        viewPicker.selectRow(place!.type.rawValue, inComponent: 0, animated: true)
        if let pt = place as? PlaceTourist{
            textDiscount.text = pt.discount_tourist
        }
        updateTuristicMode()
        
        imagePicked.image = UIImage(contentsOfFile: m_provider.GetPathImage(of: place!))
        imagePicked.alpha = 1
    }
    
    private func fillDataLocationAndDistance(placeLocation: CLLocationCoordinate2D!){
        
        //location
        let lat : NSNumber = NSNumber(value: placeLocation.latitude)
        let lng : NSNumber = NSNumber(value: placeLocation.longitude)
        lblUbicacion.text = "Location: lat:\(lat) lon:\(lng)"
        
        //distance
        if let currentLocation = m_location_manager.GetLocation() {
            let (distancia, unitats) = m_location_manager.getDistance(location1: currentLocation, location2: placeLocation)
            let fm = NumberFormatter()
            fm.numberStyle = .decimal
            fm.maximumFractionDigits = 0
            lblDistance.text = "Distance from here: \(fm.string(for: distancia)!)\(unitats)"
        }
    }
    
    private func fillDataNew(){
        if let currentLocation = m_location_manager.GetLocation() {
            fillDataLocationAndDistance(placeLocation: currentLocation)
        }
    }
    
    private func updateTuristicMode(){
        let isTuristic = viewPicker.selectedRow(inComponent: 0) == 1
        lblDiscount.isHidden = !isTuristic
        textDiscount.isHidden = !isTuristic
    }
    
    // informem a l'usuari que no es podrà crear el Place si ha denegat l'accés a la ubicació
    private func checkStatusLocation(){
        if (m_location_manager.GetStatus() == CLAuthorizationStatus.denied){
            let alert = UIAlertController(title: "Avís", message: "S'ha denegat l'accés a la ubicació. Sense aquest permís no es podran crear nous Places." , preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "D'acord", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Actions dels buttons
    @IBAction func btnRemove(_ sender: Any) {
        if place != nil {
            m_provider.remove(place!)
            m_provider.store()
        }
    }

    // controls bàsics per guardar un place
    private func checkDataIsOk() -> ([String],[String]) {
        var errors = [String]()
        var warnings = [String]()
        
        // errors
        if textName.text!.count < 1 {
            errors.append("El camp 'Nom' està buit")
        }
        if textDescription.text!.count < 1 {
            errors.append("El camp 'Notes' està buit")
        }
        //if imagePicked.image == nil {
        if imagePicked.alpha != 1{
            errors.append("No s'ha sel·leccionat cap imatge")
        }
        if m_location_manager.GetLocation() == nil {
            errors.append("No s'ha pogut obtenir la localització actual")
        }
        
        // warnings
        if m_provider.ExistPlaceLike(name: textName.text!, apartFrom: self.place ){
            warnings.append("Ja existeix un Place amb el nom '\(textName.text!)'")
        }
        
        return (errors,warnings)
    }
    
    @IBAction func btnUpdateNew(_ sender: Any) {
        let (errors, warnings) = checkDataIsOk()
        if (errors.count > 0){
            let errorsAplanats = errors.joined(separator: "\n")
            let alert = UIAlertController(title: "Error", message: errorsAplanats , preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "D'acord", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        if (warnings.count>0) {
            let warningsAplanats = warnings.joined(separator: "\n") + "\n\n Vols continuar?"
            let warningAlert = UIAlertController(title: "Avís", message: warningsAplanats, preferredStyle: UIAlertController.Style.alert)
            warningAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in self.actualitzaCrea(sender) }))
            warningAlert.addAction(UIAlertAction(title: "Cancel·lar", style: .cancel, handler: { (action: UIAlertAction!) in return }))
            present(warningAlert, animated: true, completion: nil)
        } else {
            self.actualitzaCrea(sender)
        }
    }
    
    // obte el tipus actual
    private func getType() -> Place.PlacesTypes {
        switch viewPicker.selectedRow(inComponent: 0){
        case 0:
            return Place.PlacesTypes.GenericPlace
        case 1:
            return Place.PlacesTypes.TouristicPlace
        case 2:
            return Place.PlacesTypes.ComercialPlace
        default:
            print ("getType no esperado")
            return Place.PlacesTypes.GenericPlace
        }
    }
    
    // un cop passades les verificacions, crea o actualitza el place
    private func actualitzaCrea(_ sender: Any){
        // temporal, es farà més endavant la implementacio correcta
        #warning ("implementar canvi de tipus correctament")
        
        let currentType = getType()
        
        if place != nil && (place!.type != currentType){
        //if ((place is PlaceTourist && !willBeTuristic) || (!(place is PlaceTourist) && willBeTuristic)){
            // si canvia el tipus, l'elimino i el crearem de nou
            m_provider.remove(place!)
            place = nil
        }
        
        let imageData = imagePicked.image!.jpegData(compressionQuality: 1.0)
        if (place == nil){
            // New
            if currentType != Place.PlacesTypes.TouristicPlace {
                place = Place(type: currentType, name: textName.text!, description: textDescription.text!, image_in: imageData)
            }else{
                place = PlaceTourist(name: textName.text!, description: textDescription.text!, discount_tourist: textDiscount.text!, image_in: imageData)
            }
            place!.location = m_location_manager.GetLocation()!
            m_provider.append(place!)
        }else{
            // Update
            place!.name = textName.text!
            place!.description = textDescription.text!
            // l'exercici 4 diu que no es faci però està tant a mà que ho faig
            place!.image = imageData
            if (place is PlaceTourist){
                (place as! PlaceTourist).discount_tourist = textDiscount.text!
            }
        }
        
        //deshabilitem la vista
        scrollView.alpha = 0.1
        scrollView.isUserInteractionEnabled = false
        
        activityIndicator.startAnimating()
        m_provider.store()
    }
    
    @objc func selectImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func btnBack(_ sender: Any) {
        back()
    }
    
    private func back(){
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func onPlacesStoreEnd(result: Int) {
        self.performSelector(onMainThread: #selector(EndStore), with: nil, waitUntilDone: false)
    }
    
    @objc func EndStore(){
        activityIndicator.stopAnimating()
        m_provider.updateObservers()
        back()
    }
}
