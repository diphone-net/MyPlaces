//
//  LauchscreenViewController.swift
//  MyPlaces
//
//  Created by Albert Rovira on 13/11/2018.
//  Copyright © 2018 diphone. All rights reserved.
//

import UIKit
import SwiftyGif

class LoadingViewController: UIViewController {

    let logoAnimationView = LogoAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoAnimationView.center = CGPoint(x: view.frame.size.width  / 2, y: view.frame.size.height - 100 )
        view.addSubview(logoAnimationView)
        CreateThread()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoAnimationView.logoGifImageView.startAnimatingGif()
    }

    var m_queue: OperationQueue = OperationQueue()
    
    func CreateThread() {
        let operation:BlockOperation = BlockOperation { () -> Void in self.CarregarDades();}
        self.m_queue.addOperation(operation)
    }
    
    func CarregarDades(){
        print("ini loading")
        Thread.sleep(forTimeInterval: 0.5)
        let _ = ManagerLocation.shared()
        let _ = ManagerPlaces.shared()
        print("fi loading")
        self.performSelector(onMainThread: #selector(self.ThreadEnd), with: nil, waitUntilDone: true)
    }
    
    @objc func ThreadEnd(){
        performSegue(withIdentifier: "main", sender: self)
    }

}
