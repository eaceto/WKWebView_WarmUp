//
//  WKWebViewHeater.swift
//  
//
//  Created by Kimi (Ezequiel Leonardo Aceto) on 9/3/20.
//

import WebKit

/// Extension for using URLRequestHeater alongside WKWebView
public extension URLRequestHeater where Object == WKWebView {

    /// An instance of **WKWebViewHeater** that has a **default configuration**
    /// for all the WKWebViews warmedup by this heater.
    ///
    /// Default Configuration uses the same **WKProcessPool** for all the WKWebViews return by the heater.
    static private(set) var shared = WKWebViewHeater {
        WKWebView(
            frame: .zero,
            configuration: WKWebViewSharedManager.default.config)
    }

    /// Creates an instance of **WKWebViewHeater** that has a **common configuration**
    /// for all the WKWebViews warmedup by this heater.
    ///
    /// Apart from the provided configuration, all WKWebView share the same **WKProcessPool**
    convenience init(sharedManager: WKWebViewSharedManager) {
        self.init {
            WKWebView(
                frame: .zero,
                configuration: sharedManager.config
            )
        }
    }
}

/// An analias for URLRequestHeater<WKWebView>
public typealias WKWebViewHeater = URLRequestHeater<WKWebView>
