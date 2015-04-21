//
//  DisplayEventViewController.swift
//  OnJourney
//
//  Created by Jiaxin.Li on 4/18/15.
//  Copyright (c) 2015 jl6467. All rights reserved.
//

import UIKit

class DisplayEventViewController: RootViewController {
    
    @IBOutlet var webView: UIWebView!
    
    var url: String!
    var tripName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var htmlURL = DocumentHelper.getDocumentDirectory().stringByAppendingPathComponent(tripName)
        let baseURL = NSURL(fileURLWithPath: htmlURL)
        htmlURL = htmlURL.stringByAppendingPathComponent(url)
        
        println(htmlURL)
        
        let string = String(contentsOfURL: NSURL(fileURLWithPath: htmlURL)!, encoding: NSUTF8StringEncoding, error: nil)
        
        self.webView.loadHTMLString(string, baseURL: baseURL)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.toolbarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.toolbarHidden = false
    }
}
