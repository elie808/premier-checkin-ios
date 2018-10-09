//
//  WebViewController.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/9/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    // MARK: - Properties
    
    public var URLString : String = "https://www.google.com"
    
    // MARK: - Outlets
    
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Views Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebPage()
    }
    
    // MARK: - Helpers
    
    fileprivate func loadWebPage() {
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        let url = URL(string: URLString)!
        webView.load(URLRequest(url: url))
    }
    
    // MARK: - Actions
    
    @IBAction func didTapDone(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
