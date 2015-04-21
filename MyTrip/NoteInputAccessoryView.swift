//
//  NoteInputAccessoryView.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 3/25/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

protocol NoteInputAccessoryViewDelegate {
    func didHideKeyboard(hideKeyboard: UIButton);
}

class NoteInputAccessoryView: UIView {
    
    @IBOutlet var hideKeyboard: UIButton!
    
    var delegate: NoteInputAccessoryViewDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 40)
    }
    @IBAction func hideKeyboardClicked(sender: AnyObject) {
        if delegate != nil {
            delegate.didHideKeyboard(hideKeyboard)
        }
    }
}
