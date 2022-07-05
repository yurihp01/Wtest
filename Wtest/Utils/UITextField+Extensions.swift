//
//  UITextField+Extensions.swift
//  Wtest
//
//  Created by Yuri on 04/07/2022.
//

import UIKit

// MARK: - Extension UISearchBar
extension UISearchBar {

    /// It allows to set the done button to the keyboard when using the storyboard
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    /// Add done button in the top of the keyboard
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    /// It resigns the keyboard from the screen
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }

}
