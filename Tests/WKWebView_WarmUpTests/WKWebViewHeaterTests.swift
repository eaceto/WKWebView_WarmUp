//
//  WKWebViewHeaterTests.swift
//
//
//  Created by Kimi (Ezequiel Leonardo Aceto) on 9/3/20.
//

import XCTest
import WebKit

@testable import WKWebView_WarmUp

final class WKWebViewHeaterTests: XCTestCase {

    override func setUp() {
        WKWebViewHeater.shared.anonymousHeater.anonymousPoolSize =
            WKWebViewHeater.shared.anonymousHeater.defaultAnonymousPoolSize
    }

    func testDefaultPoolSize() {
        let poolSize = 4

        XCTAssert(WKWebViewHeater.shared.anonymousHeater.anonymousPoolSize == poolSize)
        XCTAssert(WKWebViewHeater.shared.anonymousHeater.anonymousPool.count == poolSize)
        XCTAssert(WKWebViewHeater.shared.pool.isEmpty)
    }

    func testUpdatePoolSize() {
        let poolSize = 8
        WKWebViewHeater.shared.anonymousHeater.anonymousPoolSize = poolSize

        XCTAssert(WKWebViewHeater.shared.anonymousHeater.anonymousPoolSize == poolSize)
        XCTAssert(WKWebViewHeater.shared.anonymousHeater.anonymousPool.count == poolSize)
        XCTAssert(WKWebViewHeater.shared.pool.isEmpty)
    }

    func testWKWebViewHeaterWithCustomConfiguration() {
        let customWKWebViewConfiguration = WKWebViewConfiguration()
        customWKWebViewConfiguration.preferences.javaScriptCanOpenWindowsAutomatically = true
        let webViewSharedManager = WKWebViewSharedManager(configuration: customWKWebViewConfiguration)

        let customHeater = WKWebViewHeater(sharedManager: webViewSharedManager)

        let webView = customHeater.dequeue()
        let webViewConfiguation = webView.configuration

        let webViewJSIsEnabled: Bool = webViewConfiguation.preferences.javaScriptCanOpenWindowsAutomatically ==
            customWKWebViewConfiguration.preferences.javaScriptCanOpenWindowsAutomatically

        let webViewHonorsAirPlaySettings: Bool = webViewConfiguation.allowsAirPlayForMediaPlayback ==
            customWKWebViewConfiguration.allowsAirPlayForMediaPlayback

        XCTAssert(webViewJSIsEnabled)
        XCTAssert(webViewHonorsAirPlaySettings)

        let anotherWebView = customHeater.dequeue()

        let webViewsAreDifferent: Bool =
            webView != anotherWebView

        let webViewsHasBothJSEnabled: Bool = webViewConfiguation.preferences.javaScriptCanOpenWindowsAutomatically ==
            anotherWebView.configuration.preferences.javaScriptCanOpenWindowsAutomatically

        let webViewsUseTheSameProcessPool: Bool = webViewConfiguation.processPool ==
            anotherWebView.configuration.processPool

        XCTAssert(webViewsAreDifferent)
        XCTAssert(webViewsHasBothJSEnabled)
        XCTAssert(webViewsUseTheSameProcessPool)

    }

    func testDequeueAnEmptyWebView() {
        let webView = WKWebViewHeater.shared.dequeue()

        XCTAssert(webView.url?.absoluteString == "about:blank")
        XCTAssert(webView.configuration.processPool == WKWebViewSharedManager.default.processPool)
    }

    func testWarmUpAWebViewByURL() {
        let url = URL(string: "https://duckduckgo.com/")!
        WKWebViewHeater.shared.warmUp(with: url)

        let expectation = XCTestExpectation(
            description: "expect to have a WebView warmed-up at URL: \(url)"
        )

        DispatchQueue.global().async {
            guard let webView = WKWebViewHeater.shared.dequeue(with: url) else {
                XCTFail("WebView identified by \(url) does not exists")
                return
            }

            repeat {
                Thread.sleep(forTimeInterval: 0.05) // Give WKWebViewHeater time to load
            } while (webView.isLoading)

            XCTAssert(webView.url?.absoluteString == url.absoluteString)
            XCTAssert(webView.configuration.processPool == WKWebViewSharedManager.default.processPool)
            XCTAssert(!webView.isLoading)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 30.0) // Give this test 30 seconds max to complete
    }

    func testWarmedUpWebViewRedirectsURL() {
        let initialUrl = URL(string: "https://duckduckgo.com")!
        let finalUrl = URL(string: "https://duckduckgo.com/")!
        WKWebViewHeater.shared.warmUp(with: initialUrl)

        let expectation = XCTestExpectation(
            description: "expect to have a WebView warmed-up at URL: \(initialUrl)"
        )

        DispatchQueue.global().async {
            guard let webView = WKWebViewHeater.shared.dequeue(with: initialUrl) else {
                XCTFail("WebView identified by \(initialUrl) does not exists")
                return
            }

            repeat {
                Thread.sleep(forTimeInterval: 0.05) // Give WKWebViewHeater time to load
            } while (webView.isLoading)

            XCTAssert(webView.url?.absoluteString == finalUrl.absoluteString)
            XCTAssert(webView.configuration.processPool == WKWebViewSharedManager.default.processPool)
            XCTAssert(!webView.isLoading)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 30.0) // Give this test 30 seconds max to complete
    }
}
