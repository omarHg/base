//
//  Store.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 27/02/26.
//

import Combine

public protocol Store: Sendable {
}

public final class StoreImplementation: Store {
    private let database: Database
    
    public init(database: Database) {
        self.database = database
    }
}
