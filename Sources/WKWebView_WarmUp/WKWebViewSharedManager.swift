//
//  WKWebViewSharedManager.swift
//  
//
//  Created by Kimi (Ezequiel Leonardo Aceto) on 9/3/20.
//

import WebKit

/// **WKWebViewSharedManager** handles the **process pool** and **configuration** shared by several WKWebViews
public class WKWebViewSharedManager {

    private(set) static var `default` = WKWebViewSharedManager(configuration: WKWebViewConfiguration())

    /// process pool **shared** by multiple WKWebView
    public let processPool: WKProcessPool

    /// configuration **shared** by multiple WKWebView
    public let config: WKWebViewConfiguration

    init(configuration: WKWebViewConfiguration) {
        self.processPool = WKProcessPool()
        self.config = configuration
        self.config.processPool = self.processPool
    }
}
