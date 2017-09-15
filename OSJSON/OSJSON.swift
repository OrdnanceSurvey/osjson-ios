//
//  OSJSON.swift
//  OSJSON
//
//  Created by Dave Hardiman on 10/03/2016.
//  Copyright © 2016 Ordnance Survey. All rights reserved.
//

import Foundation

/// Shorthand typealias
public typealias JSON = OSJSON

/**
 *  Represents an entity that can be decoded from a JSON object
 */
public protocol OSDecodable {

    /**
     Optional initialiser that can create an entity from the passed in JSON

     - parameter json: The JSON to use to create the object

     - returns: An initialised entity or nil if decoding failed
     */
    init?(json: JSON)
}
