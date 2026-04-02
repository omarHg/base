//
//  ApiClient.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 27/02/26.
//

import UIKit
import Combine

public protocol ApiClient: Actor {
}

public actor ApiClientImplementation: ApiClient {
    
    public init() {}
}
