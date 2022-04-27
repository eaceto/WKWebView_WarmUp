//
//  URLRequestHeater.swift
//
//
//  Created by Kimi (Ezequiel Leonardo Aceto) on 9/3/20.
//

import Foundation
import WebKit

/**
 An **URLRequestHeater** warms up an **Object** that has an associated operation that requieres an **URLRequest**
 It provies a function warm up objects, and retrieve them.
 
 Objects can be enqueued by using an **URL**, **URLRequest**, or none.
 
 Dequeue can be done at any time, but that doesn't meed the object is fully loaded. Yet, it should be usable.
 If an object is dequeued without specifiygin an **URL** or **URLRequest**, a default (warmedup) object is returned.
*/
public class URLRequestHeater<Object: WarmableURL> {

    private let creationClosure: () -> Object

    internal var pool: [String: Object ] = [:]
    internal let anonymousHeater: Heater<Object>

    /**
     Initialize a **URLRequestHeater** with **creationClosure** as the block of code to init its objects

     Usage:
        
     ````swift
     let objectHeater = URLRequestHeater<AWarmableURL>(creationClosure: {
        AWarmableURL()
     })
     ````
     */
    internal init(creationClosure: @escaping () -> Object) {
        self.creationClosure = creationClosure
        self.anonymousHeater = Heater<Object>(creationClosure: creationClosure)
    }
}

/// Extension for (URL) named objects pool
public extension URLRequestHeater {

    /// starts warming up a new **Object** identified by an **URL**
    /// - Parameter url: an URL that will be sent as param in the creation closure.
    /// Object is identified by this url
    func warmUp(with url: URL) {
        let urlRequest = URLRequest(url: url)
        warmUp(with: urlRequest)
    }

    /// starts warming up a new **Object** identified by an **urlString**
    /// - Parameter request: an URL Request that will be sent as param in the creation closure.
    ///  Object is identified by its absolute URL String.
    func warmUp(with request: URLRequest) {
        guard let url = request.url else { return }
        let object = creationClosure()
        object.warmUp(with: request)
        pool[url.absoluteString] = object
    }
}

public extension URLRequestHeater {

    /// Dequeues an anonymous object (not initialized with any URL)
    /// - Returns: an **Object**
    func dequeue() -> Object {
        return anonymousHeater.dequeue()
    }

    /// Dequeues a named object if available
    /// - Parameter url: an URL that  identifies the warmed-up object
    /// - Returns: an **Object** if exists in the **URLRequestHeater** pool of objects, **nil** otherwise
    func dequeue(with url: URL) -> Object? {
        let urlString = url.absoluteString
        guard let warmedUpObject = pool[urlString] else {
            return nil
        }
        pool.removeValue(forKey: urlString)
        return warmedUpObject
    }

    /// Dequeues a named object if available
    /// - Parameter request: an URL Request, which absolute URL identifies the warmed-up object
    /// - Returns: an **Object** if exists in the **URLRequestHeater** pool of objects, **nil** otherwise
    func dequeue(with request: URLRequest) -> Object? {
        guard let url = request.url,
              let warmedUpObject = pool[url.absoluteString] else {
            return nil
        }
        pool.removeValue(forKey: url.absoluteString)
        return warmedUpObject
    }
}

public extension URLRequestHeater {

    /// Removed all the warmed-up objects
    func clear() {
        pool.removeAll()
    }
}
