# Table of Contents

1. References
    * [Code Documentation](./code/jazzy/index.html)
    * [Coverage Report](./coverage/index.html)
    * [Lint report](./code/swiftlint/index.html)
    * [Code Analysis](https://app.snyk.io/org/eaceto/project/9749d95d-30cd-4e89-af98-b57bdc22d8c7)
2. [Requirements](#requirements)
3. [Installation](#installation)
    * [Cocoapods](#cocoapods)
    * [Swift Package Manager](#swift-package-manager)
4. [Usage](#usage)
5. [Author](#author)

## Requirements

| Platform | Minimun Swift Version | Installation | Status |
| --- | --- | --- | --- |
| iOS 9.0+ | 5.3 | [Cocoapods](#cocoapods), [Swift Package Manager](#swift-package-manager) | Fully Tested |
| macOS 10.10+ | 5.3 | [Cocoapods](#cocoapods), [Swift Package Manager](#swift-package-manager) | Fully Tested |

## Installation
### Cocoapods

````ruby
pod 'WKWebView_WarmUp', '~> <latest version>'
````

### Swift Package Manager

````swift
// Inside Package definition
dependencies: [
    .package(url: "https://github.com/eaceto/WKWebView_WarmUp.git", .upToNextMajor(from: "<latest version>"))
]

// Inside Target definition
dependencies: [
    "WKWebView_WarmUp"
]
````

## Usage

When you want to speed up the loading of a WebView, perform the following request with the required URL / URLRequest to load. 

````swift
let url = URL(string: "https://duckduckgo.com")!
WKWebViewHeater.shared.warmUp(with: url)
````

This call should be done as soon as possible, and before your app makes all the critical calls, so the calls performed by the **WKWebViewHeater**.

Then, when you want to retrieve the warmed-up WebView, just call

````swift
let webView = WKWebViewHeater.shared.dequeue(with: url)!
````

**Remember that** this WebView's size is Zero! In order to added to your ViewController, use AutoLayout as follows:

````swift
// Declare a variable that holds the WebView
private lazy var webView: WKWebView = {
    let webView: WKWebView!
    webView = WKWebViewHeater.shared.dequeue(url: urlString)
    
    // Set other properties of the WebView
    webView.configuration.allowsInlineMediaPlayback = true
    
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.scrollView.alwaysBounceHorizontal = false
    return webView
}()

override func viewDidLoad() {
    super.viewDidLoad()

    // Add the WebView
    view.addSubview(webView)

    // Set WebView's delegate and props
    webView.navigationDelegate = self
    
    // User AutoLayout to set its constraints
    let webViewConstraints = [
        webView.topAnchor.constraint(equalTo: view.topAnchor),
        webView.leftAnchor.constraint(equalTo: view.leftAnchor),
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        webView.rightAnchor.constraint(equalTo: view.rightAnchor)
    ]
    NSLayoutConstraint.activate(webViewConstraints)
}
````

