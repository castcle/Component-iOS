//
//  ReportSuccessViewController.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 7/12/2564 BE.
//

import UIKit
import Core
import Defaults
import ActiveLabel

class ReportSuccessViewController: UIViewController {

    @IBOutlet var thankLabel: UILabel!
    @IBOutlet var termLabel: ActiveLabel!
    
    var isReportContent: Bool = true
    var castcleId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.setupNevBar()
        
        self.thankLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.thankLabel.textColor = UIColor.Asset.white
        
        if self.isReportContent {
            self.termLabel.text = "If we find this cast violating Castcle Terms of Service, we will take action on it"
        } else {
            self.termLabel.text = "If we find @\(self.castcleId) violating Castcle Terms of Service, we will take action on it"
        }
        
        self.termLabel.customize { label in
            label.font = UIFont.asset(.regular, fontSize: .body)
            label.numberOfLines = 0
            label.textColor = UIColor.Asset.white
            
            let termType = ActiveType.custom(pattern: "Castcle Terms of Service")
            
            label.enabledTypes = [.mention, termType]
            label.mentionColor = UIColor.Asset.lightBlue
            label.customColor[termType] = UIColor.Asset.lightBlue
            label.customSelectedColor[termType] = UIColor.Asset.lightBlue
            
            label.handleCustomTap(for: termType) { element in
                Utility.currentViewController().navigationController?.pushViewController(ComponentOpener.open(.internalWebView(URL(string: Environment.privacyPolicy)!)), animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Defaults[.screenId] = ""
    }
    
    private func setupNevBar() {
        self.customNavigationBar(.primary, title: "Report")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIButton())
        
        var rightButton: [UIBarButtonItem] = []
        
        let icon = UIButton()
        icon.setTitle("Done", for: .normal)
        icon.titleLabel?.font = UIFont.asset(.bold, fontSize: .h4)
        icon.setTitleColor(UIColor.Asset.white, for: .normal)
        icon.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        rightButton.append(UIBarButtonItem(customView: icon))

        self.navigationItem.rightBarButtonItems = rightButton
    }
    
    @objc private func doneAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
