//
//  WebView.swift
//  Timetable App
//
//  Created by Aurel Feer and Lukas Boner on 20.11.15.
//  Copyright © 2015 Aurel Feer and Lukas Boner. All rights reserved.
//

import UIKit

class LoginWebViewController: UIViewController, UIWebViewDelegate {
    
    //MARK: CLASSES
    let userDefaults = UserDefaults.standard
    
    //MARK: OUTLETS
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: IDENTIFIERS
    let mainAppCycleSegueIdentifier = "showMainAppCycle"
    let firstLaunchSegueIdentifier = "ShowFL"
    
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
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        let URLString = request.url?.absoluteString
        
        // If the URL is correct, switch to timetable
        if URLString!.contains("uniapp://klw-stupla-app#access_token=") {
            goToTimetable()
            if !userDefaults.bool(forKey: "HasLaunchedOnce") {
                userDefaults.set(true, forKey: "HasLaunchedOnce")
            }
            // Delete the cookies to prevent auto-login in next start of the webView
            for cookie:HTTPCookie in HTTPCookieStorage.shared.cookies! {
                if cookie.domain.contains("tam") {
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
            }
        }
        return true
    }
    
    /**
    Stop loading wheel
    */
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    /**
    Automatically loading starting URL once the View appears
    */
    override func viewWillAppear(_ animated: Bool) {
        let URLforRequest = URL(string: "https://oauth.tam.ch/signin/klw-stupla-app?response_type=token&client_id=0Wv69s7vyidj3cKzNckhiSulA5on8uFM&redirect_uri=uniapp%3A%2F%2Fklw-stupla-app&_blank&scope=all")
        
        let request = URLRequest(url: URLforRequest!)
        
        webView.loadRequest(request)
    }
    
    func goToTimetable() {
        self.performSegue(withIdentifier: mainAppCycleSegueIdentifier, sender: self)
    }
    
    func goToFL() {
        self.performSegue(withIdentifier: firstLaunchSegueIdentifier, sender: self)
    }
    
    /**
    Cancel Button
    */
    @IBAction func cancelButton(_ sender: AnyObject) {
        userDefaults.set(true, forKey: "loginCancelled")
        if !userDefaults.bool(forKey: "HasLaunchedOnce") {
            goToFL()
        } else {
            goToTimetable()
        }
    }
}
