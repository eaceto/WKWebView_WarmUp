libraryVersion = "1.0.0"

Pod::Spec.new do |s|
    s.name	= "WKWebView_WarmUp"
    s.version   = libraryVersion
    s.summary   = "A library that speeds up the loading of Web Pages when using WKWebView"

    s.homepage  = "https://eaceto.github.io/WKWebView_WarmUp"
    s.license   = { :type => "MIT", :file => "LICENSE" }
    s.author    = { "Ezequiel (Kimi) Aceto" => "ezequiel.aceto@gmail.com" }

    s.source    = {
        :git => "https://github.com/eaceto/WKWebView_WarmUp.git",
        :tag => s.version.to_s
    }

    s.ios.deployment_target   = "9.0"
    s.macos.deployment_target = "10.10"

    s.swift_versions = ['5.3', '5.4', '5.5', '5.6']

    s.cocoapods_version = ">= 1.4.0"

    s.frameworks = "WebKit"

    s.source_files = "Sources/WKWebView_WarmUp/**/*"
end

