//
//  AuthTextField.swift
//  Klassenbuch
//
//  Created by Developing on 17.01.17.
//  Copyright © 2017 Hadorn Developing. All rights reserved.
//

import UIKit
@IBDesignable

class AuthTextField: UITextField {

    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = UIColor(white: 231 / 255, alpha: 1).cgColor
        self.layer.borderWidth = 1
        
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 8, dy: 7)
    }
    
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    

   }


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
