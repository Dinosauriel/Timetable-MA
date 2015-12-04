//
//  WebView.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 20.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    //OUTLETS
    @IBOutlet weak var webView: UIWebView!
    
    //IDENTIFIERS
    let mainAppCycleSegueIdentifier = "showMainAppCycle"
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let URLString = request.URL?.absoluteString
        
        if URLString!.containsString("uniapp://klw-stupla-app#access_token=") {
            print("Token URL Loaded!")
            self.performSegueWithIdentifier(mainAppCycleSegueIdentifier, sender: self)
        }
            
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {

        let URLforRequest = NSURL(string: "https://oauth.tam.ch/signin/klw-stupla-app?response_type=token&client_id=0Wv69s7vyidj3cKzNckhiSulA5on8uFM&redirect_uri=uniapp%3A%2F%2Fklw-stupla-app&_blank&scope=all")
        let request = NSURLRequest(URL: URLforRequest!)
        
        webView.loadRequest(request)
    }
}