//
//  WKWebView+Extensions.swift
//
//
//  Created by Kimi (Ezequiel Leonardo Aceto) on 9/3/20.
//

import Foundation
import WebKit

extension WKWebView: WarmableURL {

    /// Warms up **only** the WKWebView and its engine. But it does not prefetch a requests...
    public func warmUp() {
        loadHTMLString("", baseURL: nil)
    }

    /// Warms up  the WKWebView,  its engine, and prefetches the requested **URL**
    /// using a URLRequest with a GET HTTP Request.
    /// - Parameter url: a valid URL to prefetch
    public func warmUp(with url: URL) {
        warmUp(with: URLRequest(url: url))
    }

    /// Warms up  the WKWebView,  its engine, and prefetches the **URLRequest**
    /// - Parameter urlRequest: a valid URL Request  to prefetch
    public func warmUp(with urlRequest: URLRequest) {
        _ = self.load(urlRequest)
    }

}
