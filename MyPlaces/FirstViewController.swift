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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Devolver la altura de una fila situada en una posicion determinada
        return 90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // devolver una instancia de una clase UITable ViewCell que pinte la fila seleccionada
        let cell = UITableViewCell()
        let wt: CGFloat = tableView.bounds.size.width
        let fuente: UIFont = UIFont(name: "Arial", size: 12)!
        let fuenteTitulo = UIFont.boldSystemFont(ofSize: 14)
        
        tableView.rowHeight = UITableView.automaticDimension
        
        
        // Add subviews to cell
        // UILabel and UIImageView
        var label: UILabel
        var labelFilaActual: UILabel? = nil
        var labelFilaAnterior: UILabel? = nil
        let defaultSpaceX: CGFloat = 20
        let defaultSpaceY: CGFloat = 15
        
        let place: Place = m_provider.GetItemAt(position: indexPath[1])
        
        // afegim els elements del place i touristplace
        // for per el Name Descripction i Discount
        for element in 0...2{
            // es el label o el contingut
            for i in 0...1{
                label = UILabel()
                cell.contentView.addSubview(label)
                
                // posicionament x
                label.translatesAutoresizingMaskIntoConstraints = false
                if (i == 0){
                    // primera columna
                    label.leadingAnchor.constraint(greaterThanOrEqualTo: cell.leadingAnchor, constant: defaultSpaceX).isActive = true
                    label.widthAnchor.constraint(equalToConstant: 80).isActive = true
                } else {
                    label.leadingAnchor.constraint(greaterThanOrEqualTo: labelFilaActual!.trailingAnchor, constant: defaultSpaceX).isActive = true
                    label.trailingAnchor.constraint(greaterThanOrEqualTo: cell.trailingAnchor, constant: defaultSpaceX)
                }
                // posicionament y
                if (element == 0){
                    // primera fila
                    label.topAnchor.constraint(greaterThanOrEqualTo: cell.topAnchor, constant: defaultSpaceY).isActive = true
                } else {
                    label.topAnchor.constraint(greaterThanOrEqualTo: labelFilaAnterior!.bottomAnchor , constant: 10).isActive = true
                }
                if (i==0){
                    labelFilaActual = label
                } else {
                    labelFilaAnterior = label
                }
                
                label.font = (i == 0) ? fuenteTitulo : fuente
                label.numberOfLines = 1
                label.text = (i == 0) ? getTitle(of: place, at: element) : getDefinition(of: place, at: element)
                label.sizeToFit()
            }
        }
        
        // de moment no es permet Place sense imatge
        let imageIcon: UIImageView = UIImageView(image: UIImage(contentsOfFile: m_provider.GetPathImage(of: place)))
        let mida: CGFloat = 60
        imageIcon.frame = CGRect(x:wt - mida - defaultSpaceX, y:defaultSpaceY, width:mida, height:mida)
        imageIcon.contentMode = UIView.ContentMode.scaleAspectFit
        cell.contentView.addSubview(imageIcon)
        //imageIcon.translatesAutoresizingMaskIntoConstraints = false
        //imageIcon.topAnchor.constraint(greaterThanOrEqualTo: cell.topAnchor, constant: defaultSpace).isActive = true
        //imageIcon.bottomAnchor.constraint(greaterThanOrEqualTo: cell.bottomAnchor, constant: defaultSpace).isActive = true
        //imageIcon.trailingAnchor.constraint(greaterThanOrEqualTo: cell.trailingAnchor, constant: defaultSpace).isActive = true
        //imageIcon.widthAnchor.constraint(equalToConstant: 10)
        //imageIcon.heightAnchor.constraint(equalToConstant: 10)

        return cell
    }
    
    private func getDefinition(of place: Place, at element: Int) -> String{
        switch element{
        case 0:
            return place.name
        case 1:
            return place.description
        case 2:
            if let pt = (place as? PlaceTourist){
                return pt.discount_tourist + "%"
            }
            return ""
        default:
            return "Element inesperat"
        }
    }
    
    private func getTitle(of place: Place, at element: Int) -> String{
        switch element{
        case 0:
            return "Lloc"
        case 1:
            return "Descripció"
        case 2:
            if (place.type == PlaceTourist.PlacesTypes.TouristicPlace){
                return "Descompte"
            }
            return ""
        default:
            return "??"
        }
    }
}
