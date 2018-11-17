//
//  FirstViewController.swift
//  MyPlaces
//
//  Created by user143580 on 25/9/18.
//  Copyright © 2018 diphone. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController, ManagerPlacesObserver {

    let m_provider = ManagerPlaces.shared()
    
    func onPlacesChange() {
        let view: UITableView = (self.view as? UITableView)!
        view.reloadData()
    }
    
    // nou pel retorn despres d'afegir n elemnt
    override func viewWillAppear(_ animated: Bool) {
        //self.tableView.reloadData()
        // ja no cal perquè es controla per l'observer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Devolver la altura de una fila situada en una posicion determinada
        return 90
    }
 */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place: Place = m_provider.GetItemAt(position: indexPath[1])
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellImage") as! FirstViewTableViewCell
        cell.nom.text = place.name
        cell.descripcio.text = place.description
        
        cell.imatge.image = UIImage(contentsOfFile: m_provider.GetPathImage(of: place))
        
        // arrodoniment i borde
        cell.imatge.layer.borderWidth = 1
        cell.imatge.layer.borderColor = UIColor.black.cgColor
        cell.imatge.layer.cornerRadius = 10
        // imatges rodones
        //cell.imatge.layer.cornerRadius = cell.imatge.frame.size.width / 2
        cell.imatge.clipsToBounds = true
        
        return cell
    }
    
    // permetem el swipe de la cel·la
    /*override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }*/
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let placeEliminar: Place = m_provider.GetItemAt(position: indexPath[1])
            m_provider.remove(placeEliminar)
            m_provider.updateObserversAndStore()
        }
        if (editingStyle == .insert){
            print ("insertar")
        }
    }
}
