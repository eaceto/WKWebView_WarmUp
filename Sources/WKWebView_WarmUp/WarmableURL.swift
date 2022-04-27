//
//  WarmableURL.swift
//  
//
//  Created by Kimi (Ezequiel Leonardo Aceto) on 9/3/20.
//

import Foundation

/// Defines functions for warming up objects idenfified by **URL** and/or **URLRequest**
public protocol WarmableURL: Warmable {
    /// Implements the necessary logic for warming up an object identified by an URL
    func warmUp(with url: URL)

    /// Implements the necessary logic for warming up an object identified by an URLRequest
    func warmUp(with urlRequest: URLRequest)
}
