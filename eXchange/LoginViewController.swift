//
//  LoginViewController.swift
//  eXchange
//
//  Created by Emanuel Castaneda on 4/6/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, WKNavigationDelegate {
    
    var netid: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = NSURL(string: "http://www.cs.princeton.edu/~cmoretti/cos333/CAS/CAStestpy.cgi")
        let marginTop:CGFloat = self.view.bounds.height * 0.05;
        let marginLeft:CGFloat = self.view.bounds.width * 0.08
        let width:CGFloat = self.view.bounds.width - marginLeft
        let height = self.view.bounds.height - marginTop
        let webView = WKWebView(frame: CGRectMake(marginLeft, marginTop, width, height))

        webView.navigationDelegate = self
        self.view.addSubview(webView)
        webView.loadRequest(NSURLRequest(URL: url!))
    }
    
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.body.innerHTML") { (result, error) in
            let page = result as! String
            if page.containsString("Hello") {
                let lines = page.characters.split("\n").map { String($0) }
                let line = lines[0]
                let start = line.characters.indexOf(",")?.advancedBy(2)
                self.netid = line.substringFromIndex(start!)
                self.performSegueWithIdentifier("login", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //let destination = segue.destinationViewController as! eXchangeTabBarController
        // uncomment this to un-hardcode userNetID
        // destination.userNetID = self.netid
    }

}
