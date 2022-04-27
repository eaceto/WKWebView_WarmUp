// swift-tools-version:5.3


import PackageDescription

let package = Package(
    name: "WKWebView_WarmUp",
    products: [
        .library(
            name: "WKWebView_WarmUp",
            targets: ["WKWebView_WarmUp"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "WKWebView_WarmUp",
            dependencies: []),
        .testTarget(
            name: "WKWebView_WarmUpTests",
            dependencies: ["WKWebView_WarmUp"]),
    ]
)
