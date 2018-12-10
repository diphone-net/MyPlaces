//
//  FirstViewController.swift
//  MyPlaces
//
//  Created by user143580 on 25/9/18.
//  Copyright © 2018 diphone. All rights reserved.
//

import UIKit
import ViewAnimator

class FirstViewController: UITableViewController, ManagerPlacesObserver, ManagerPlacesStoreObserver {

    let m_provider = ManagerPlaces.shared()
    let animation1 = AnimationType.zoom(scale: 0.1)
    let animatino2 = AnimationType.from(direction: .bottom, offset: 130.0)
    var styler = Styler.shared()
    
    func onPlacesChange() {
        let view: UITableView = (self.view as? UITableView)!
        view.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(views: tableView.visibleCells, animations: [animation1, animatino2])
        m_provider.storeDelegate = self
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styler.recursiveSetStyle(v: self.view)
        
        // añadimos el controller como observer
        ManagerPlaces.shared().addOberserver(object: self)
        
        // no mostrar les ralletes de les celes buides
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.separatorColor = UIColor.gray
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Numero de elementos del manager
        return m_provider.GetCount()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Sirve para indicar subsecciones de la lista. En nuestro caso devolvemos 1 porque no hay subsecciones.
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Detectar pulsación en un elemento
        
        // he creat un segon segue per fer un show detail (no se si es correcte, pero provo)
        // aixi si es clica al boto 'add' ho faig com es feia al video pero si es consulta dono la opció a tornar show VS show detail
        //let dc:DetailController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        //dc.place = place
        //present(dc, animated: true, completion: nil)
        let place: Place = m_provider.GetItemAt(position: indexPath.row)
        performSegue(withIdentifier: "show", sender: place)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { 
        if segue.identifier == "show" {
            if let destinationVC = segue.destination as? DetailController {
                destinationVC.place = sender as? Place
            } 
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place: Place = m_provider.GetItemAt(position: indexPath[1])
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellImage") as! FirstViewTableViewCell
        cell.nom.text = place.name
        cell.descripcio.text = place.description
        cell.imatge.image = UIImage(contentsOfFile: m_provider.GetPathImage(of: place))
        var displayDiscount = false
        if let touristPlace = place as? PlaceTourist{
            if (touristPlace.discount_tourist != "0"){
                cell.discount.text = touristPlace.discount_tourist + "%"
                displayDiscount = true
            }
        }
        cell.sale.isHidden = (place.type != Place.PlacesTypes.ComercialPlace)
        cell.discount.isHidden = !displayDiscount
        
        // constraints en funció de la imatge o disconut lateral
        cell.title_trailing.isActive = (place.type == Place.PlacesTypes.GenericPlace || (place.type == Place.PlacesTypes.TouristicPlace && !displayDiscount))
        cell.title_icon.isActive = (place.type == Place.PlacesTypes.ComercialPlace)
        cell.title_discount.isActive = (place.type == Place.PlacesTypes.TouristicPlace && displayDiscount)
        cell.description_trailing.isActive = (place.type == Place.PlacesTypes.GenericPlace || (place.type == Place.PlacesTypes.TouristicPlace && !displayDiscount))
        cell.description_icon.isActive = (place.type == Place.PlacesTypes.ComercialPlace)
        cell.description_discount.isActive = (place.type == Place.PlacesTypes.TouristicPlace && displayDiscount)
        
    
        // cal aplicar l'styler perquè es creen dinàmicament
        styler.recursiveSetStyle(v: cell)
        // canvio el comportament estànder de l'styler per aquest UITextView
        cell.descripcio.layer.borderWidth = 0
        
        return cell
    }
    
    // permetem el swipe de la cel·la
    /*override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }*/
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let placeEliminar: Place = m_provider.GetItemAt(position: indexPath.row)
            m_provider.remove(placeEliminar)
            m_provider.store()
        }
        if (editingStyle == .insert){
            print ("insertar")
        }
    }
    
    func onPlacesStoreEnd(result: Int) {
        self.performSelector(onMainThread: #selector(EndStore), with: nil, waitUntilDone: false)
        
    }
    
    @objc func EndStore(){
        m_provider.updateObservers()
    }
}
