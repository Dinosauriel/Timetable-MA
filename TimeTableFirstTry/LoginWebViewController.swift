//
//  WebView.swift
//  TimeTableFirstTry
//
//  Created by Aurel Feer on 20.11.15.
//  Copyright © 2015 Aurel Feer. All rights reserved.
//

import UIKit

class LoginWebViewController: UIViewController, UIWebViewDelegate {
    
    //MARK: CLASSES
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    //MARK: OUTLETS
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: IDENTIFIERS
    let mainAppCycleSegueIdentifier = "showMainAppCycle"
    
    /**
    Assigning Delegate
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
    }
    
    /**
    Detecting correct URL for segue!
    */
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        let URLString = request.URL?.absoluteString
        
        if URLString!.containsString("uniapp://klw-stupla-app#access_token=") {
            print("Token URL Loaded!")
            self.performSegueWithIdentifier(mainAppCycleSegueIdentifier, sender: self)
            if !userDefaults.boolForKey("HasLaunchedOnce") {
                userDefaults.setBool(true, forKey: "HasLaunchedOnce")
            }
            for cookie:NSHTTPCookie in NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies! {
                print(cookie.domain)
                if cookie.domain.containsString("tam") {
                    NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
                }
            }
        }
        NSURLCache.sharedURLCache().removeAllCachedResponses()
        return true
    }
    
    /**
    stop loading wheel
    */
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    /**
    Automatically loading starting URL once the View appears
    */
    override func viewWillAppear(animated: Bool) {
        activityIndicator.startAnimating()
        let URLforRequest = NSURL(string: "https://oauth.tam.ch/signin/klw-stupla-app?response_type=token&client_id=0Wv69s7vyidj3cKzNckhiSulA5on8uFM&redirect_uri=uniapp%3A%2F%2Fklw-stupla-app&_blank&scope=all")
        
        let request = NSURLRequest(URL: URLforRequest!)
        
        webView.loadRequest(request)
    }
}
