//
//  CustomWebView.swift
//  Movo
//
//  Created by Ahmad on 23/12/2020.
//

import UIKit
import WebKit

class CustomWebView: UIView ,WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        setup()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.className, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return view
    }

    private func setup() {
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isUserInteractionEnabled = true
        webView.navigationDelegate = self
    }
    
    func configureView(str: String) {
        self.hideProgressFromView()

        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer) in
            DispatchQueue.main.async {
                if let url = URL(string: str) {
                    self.setupWebView(url: url)
                }
            }
        }
    }
    
    
    private func setupWebView(url: URL) {
        
        self.showProgressOnView()
        webView.load(URLRequest(url: url))
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideProgressFromView()
        
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.hideProgressFromView()
    }
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Intercept target=_blank links
        guard
          navigationAction.targetFrame == nil,
          let url = navigationAction.request.url else {
            return nil
        }

//        self.showProgressOnView()
        let request = URLRequest(url: url)
        webView.load(request)
        
        return nil
      }

}
