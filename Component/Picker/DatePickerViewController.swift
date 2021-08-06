//
//  DatePickerViewController.swift
//  Component
//
//  Created by Tanakorn Phoochaliaw on 6/8/2564 BE.
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
