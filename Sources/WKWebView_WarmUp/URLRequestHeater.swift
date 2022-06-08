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

    internal let anonymousHeater: Heater<Object>
    internal var pool: [URLRequest: Object] = [:]
    internal var objectsLivespan: [URLRequest: TimeInterval] = [:]
    internal var livespanTimer: Timer? = nil
    
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
    
    private func checkLivespanTimer() {
        if livespanTimer != nil { return }
        if let livespanTimer = livespanTimer, livespanTimer.isValid {
            return
        }
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ [weak self] _ in
                self?.checkWebViewsLivespan()
            }
        } else {
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.checkWebViewsLivespan), userInfo: nil, repeats: true)
        }
    }
    
    @objc
    private func checkWebViewsLivespan() {
        let now = Date().timeIntervalSinceReferenceDate
        self.objectsLivespan.forEach { (urlRequest, livespan) in
            if now > livespan, let object = self.pool[urlRequest] {
                DispatchQueue.main.async {
                    object.warmUp(with: urlRequest)
                }
            }
        }
    }
}

/// Extension for (URL) named objects pool
public extension URLRequestHeater {

    /// starts warming up a new **Object** identified by an **URL**
    /// - Parameter url: an URL that will be sent as param in the creation closure.
    /// - Parameter livespan: number of seconds of life of this warmed up object. It reloads the cache when the livespan ends.
    /// Object is identified by this url
    func warmUp(with url: URL, livespan: TimeInterval? = nil) {
        let urlRequest = URLRequest(url: url)
        warmUp(with: urlRequest, livespan: livespan)
    }

    /// starts warming up a new **Object** identified by an **urlString**
    /// - Parameter request: an URL Request that will be sent as param in the creation closure.
    /// - Parameter livespan: number of seconds of life of this warmed up object. It reloads the cache when the livespan ends.
    ///  Object is identified by its absolute URL String.
    func warmUp(with request: URLRequest, livespan: TimeInterval? = nil) {
        let object = creationClosure()
        object.warmUp(with: request)
        pool[request] = object
        if let livespan = livespan {
            let endsDate = Date().timeIntervalSinceReferenceDate + livespan
            objectsLivespan[request] = endsDate
            checkLivespanTimer()
        }
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
    /// - Returns: a warmed up **Object** if exists in the **URLRequestHeater** pool of objects, or a new one.
    func dequeue(with url: URL) -> Object {
        let urlRequest = URLRequest(url: url)
        return dequeue(with: urlRequest)
    }

    /// Dequeues a named object if available
    /// - Parameter request: an URL Request, which absolute URL identifies the warmed-up object
    /// - Returns: a warmed up **Object** if exists in the **URLRequestHeater** pool of objects, or a new one.
    func dequeue(with request: URLRequest) -> Object {
        guard let warmedUpObject = pool[request] else {
            let object = dequeue()
            object.warmUp(with: request)
            return object
        }
        pool.removeValue(forKey: request)
        objectsLivespan.removeValue(forKey: request)
        if objectsLivespan.isEmpty {
            livespanTimer?.invalidate()
            livespanTimer = nil
        }        
        return warmedUpObject
    }
}

public extension URLRequestHeater {

    /// Removed all the warmed-up objects
    func clear() {
        pool.removeAll()
    }
}
