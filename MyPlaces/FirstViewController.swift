//
//  FirstViewController.swift
//  MyPlaces
//
//  Created by user143580 on 25/9/18.
//  Copyright © 2018 diphone. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController {

    let m_provider = ManagerPlaces.share()
    
    // nou pel retorn despres d'afegir n elemnt
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // prova
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
        let place: Place = m_provider.GetItemAt(position: indexPath[1])
        //dc.place = place
        //present(dc, animated: true, completion: nil)
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
        
        // Add subviews to cell
        // UILabel and UIImageView
        var label: UILabel

        let place: Place = m_provider.GetItemAt(position: indexPath[1])
        
        // afegim els elements del place i touristplace
        for element in 0...3{
            for i in 0...1{
                let posY: CGFloat = 5 + CGFloat(element) * 20.0 + CGFloat(i) * 2.0
                let posX: CGFloat = 5 + CGFloat(i) * 90
                label = UILabel(frame: CGRect(x:posX,y:posY,width:wt,height:20))
                label.font = (i == 0) ? fuenteTitulo : fuente
                label.numberOfLines = 1
                label.text = (i == 0) ? getTitle(of: place, at: element) : getDefinition(of: place, at: element)
                label.sizeToFit()
                cell.contentView.addSubview(label)
            }
        }
        if (place.image != nil){
            let imageIcon: UIImageView = UIImageView(image: UIImage(data: place.image!))
            let mida: CGFloat = 50
            imageIcon.frame = CGRect(x:wt - mida - 10, y:40, width:mida, height:mida)
            cell.contentView.addSubview(imageIcon)
        }
        return cell
    }
    
    private func getDefinition(of place: Place, at element: Int) -> String{
        switch element{
        case 0:
            return place.id
        case 1:
            return place.name
        case 2:
            return place.description
        case 3:
            if (place.type == PlaceTourist.PlacesTypes.TouristicPlace){
                let touristPlace = place as! PlaceTourist
                return touristPlace.discount_tourist + "%"
            }
            return ""
        default:
            return "Element inesperat"
        }
    }
    
    private func getTitle(of place: Place, at element: Int) -> String{
        switch element{
        case 0:
            return "ID"
        case 1:
            return "Lloc"
        case 2:
            return "Descripció"
        case 3:
            if (place.type == PlaceTourist.PlacesTypes.TouristicPlace){
                return "Descompte"
            }
            return ""
        default:
            return "??"
        }
    }
}
