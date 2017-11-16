//
//  RoundTextField.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/13/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit

@IBDesignable
class RoundTextField : UITextField {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius>0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var bgColor : UIColor? {
        didSet {
            layer.backgroundColor = bgColor?.cgColor
        }
    }
    
    @IBInspectable var placeholderColor: UIColor? {
        didSet{
            let rawString = attributedPlaceholder?.string != nil ? attributedPlaceholder!.string : ""
            let str = NSAttributedString(string: rawString, attributes: [NSAttributedStringKey.foregroundColor:placeholderColor!])
            self.attributedPlaceholder = str
        }
    }
    
}

