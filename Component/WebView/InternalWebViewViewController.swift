//
//  InternalWebViewViewController.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 27/7/2564 BE.
//

import UIKit
import Core

class InternalWebViewViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.customNavigationBar(.primary, title: "", leftBarButton: .back, rightBarButton: [])
    }
}
