// swift-tools-version:5.3


import PackageDescription

let package = Package(
    name: "WKWebView_WarmUp",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_12),
    ],
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
