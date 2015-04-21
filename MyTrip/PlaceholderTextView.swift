//
//  PlaceholderTextView.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 3/25/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

public class PlaceholderTextView: UITextView {
    @IBInspectable public var placeholder: String = ""
    var placeholderLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initPlaceholderLabel()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textDidChanged", name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    func initPlaceholderLabel() {
        if count(placeholder) > 0 {
            if placeholderLabel == nil {
                let linePadding = self.textContainer.lineFragmentPadding
                let placeholderFrame = CGRectMake(self.textContainerInset.left + linePadding,
                    self.textContainerInset.top,
                    self.frame.size.width - self.textContainerInset.left - self.textContainerInset.right - 2 * linePadding,
                    self.frame.size.height - self.textContainerInset.top - self.textContainerInset.bottom)
                
                placeholderLabel = UILabel(frame: placeholderFrame)
                placeholderLabel.font = self.font
                placeholderLabel.textAlignment = self.textAlignment
                placeholderLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
                placeholderLabel.text = placeholder
                self.addSubview(placeholderLabel)
                placeholderLabel.sizeToFit()
            }
            
            self.showOrHidePlaceholder()
        }
        
    }
    
    func textDidChanged() {
        if count(placeholder) == 0 {return}
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.showOrHidePlaceholder()
        })
    }
    
    func showOrHidePlaceholder() {
        if count(self.text) == 0 {
            self.placeholderLabel.alpha = 1.0
        }else {
            self.placeholderLabel.alpha = 0.0
        }
    }
}
