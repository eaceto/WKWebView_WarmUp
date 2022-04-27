//
//  Heater.swift
//  
//
//  Created by Kimi (Ezequiel Leonardo Aceto) on 9/3/20.
//

import Foundation
import WebKit

/**
 A **Heater** warms up objects in order to accelerate they resources needs.
 It provies a function for dequeuing warmedup **Objects** that implement **Warmable**
 
 Dequeue can be done at any time, but that doesn't mean the object is fully loaded by that moment.
 Yet, it should be usable.
*/
public class Heater<Object: Warmable> {

    private let creationClosure: () -> Object

    internal let defaultAnonymousPoolSize = 4
    internal var anonymousPool: [Object] = []
    internal var anonymousPoolSize: Int {
        didSet {
            warmUp()
        }
    }

    /**
     Initialize a **Heater** with **creationClosure** as the block of code to call for intantiating its objects
     
     Usage:
        
     ````swift
     let objectHeater = Heater<AWarmableObject>(creationClosure: {
        AWarmableObject()
     })
     ````
     */
    public init(creationClosure: @escaping () -> Object) {
        self.creationClosure = creationClosure
        self.anonymousPoolSize = defaultAnonymousPoolSize
        warmUp()
    }

    /// Prepares the pool of anonymous objects and warms them up
    private func warmUp() {
        while anonymousPool.count < anonymousPoolSize {
            let object = creationClosure()
            object.warmUp()
            anonymousPool.append(object)
        }
    }

    /// Creates and object and warms it up
    private func createAndWarmUp() -> Object {
        let object = creationClosure()
        object.warmUp()
        return object
    }
}

/// Extension for anonymous objects pool
public extension Heater {

    /// Dequeues a warmed-up **Object**
    func dequeue() -> Object {
        let warmedUpObject: Object
        if let object = anonymousPool.first {
            anonymousPool.removeFirst()
            warmedUpObject = object
        } else {
            warmedUpObject = createAndWarmUp()
        }
        warmUp()
        return warmedUpObject
    }
}
