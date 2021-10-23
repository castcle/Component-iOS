//  Copyright (c) 2021, Castcle and/or its affiliates. All rights reserved.
//  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
//
//  This code is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 3 only, as
//  published by the Free Software Foundation.
//
//  This code is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
//  version 3 for more details (a copy is included in the LICENSE file that
//  accompanied this code).
//
//  You should have received a copy of the GNU General Public License version
//  3 along with this work; if not, write to the Free Software Foundation,
//  Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  Please contact Castcle, 22 Phet Kasem 47/2 Alley, Bang Khae, Bangkok,
//  Thailand 10160, or visit www.castcle.com if you need additional information
//  or have any questions.
//
//  DatePickerViewController.swift
//  Component
//
//  Created by Castcle Co., Ltd. on 6/8/2564 BE.
//

import UIKit
import Core
import PanModal
import SwiftDate

public protocol DatePickerViewControllerDelegate {
    func datePickerViewController(_ view: DatePickerViewController, didSelectDate date: Date, displayDate: String)
}

public class DatePickerViewController: UIViewController {

    @IBOutlet var doneButton: UIButton!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var toolBarView: UIView!
    
    public var delegate: DatePickerViewControllerDelegate?
    var maxHeight = (UIScreen.main.bounds.height - 350)
    
    public var initDate: Date? = nil
    private var dateSelect: Date = Date()
    private var displayDate: String = ""
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.toolBarView.backgroundColor = UIColor.Asset.darkGray
        self.doneButton.titleLabel?.font = UIFont.asset(.medium, fontSize: .h4)
        self.datePicker.datePickerMode = .date
        self.datePicker.maximumDate = Date()
        self.datePicker.minimumDate = Date() - 100.years
        self.datePicker.addTarget(self, action: #selector(self.datePickerValueChanged(_:)), for: .valueChanged)
        
        if let date = self.initDate {
            self.datePicker.date = date
        }
        
        self.dateSelect = self.datePicker.date
        self.displayDate = self.datePicker.date.dateToString()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        self.dateSelect = sender.date
        self.displayDate = sender.date.dateToString()
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.datePickerViewController(self, didSelectDate: self.dateSelect, displayDate: self.displayDate)
    }
}

extension DatePickerViewController: PanModalPresentable {

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public var panScrollable: UIScrollView? {
        return nil
    }

    public var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(self.maxHeight)
    }

    public var anchorModalToLongForm: Bool {
        return false
    }
}
