//
//  NonEditableTextField.swift
//  Klassenbuch
//
//  Created by Developing on 18.01.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit

// Makes Textfields in Datepickers and Pickerviews not editable

class NonEditableTextField: UITextField {

    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    override func selectionRects(for range: UITextRange) -> [Any] {
        return []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
            
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}



