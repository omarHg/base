//
//  Presenter.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 24/09/26.
//

@MainActor
public protocol Presenter { }

public extension Presenter {
    @discardableResult
    public func safeTask(
        _ operation: @escaping @MainActor() async throws -> Void,
        catch errorHandler: @escaping @MainActor (Error) -> Void
    ) -> Task<Void, Never> {
        Task { @MainActor in
            do {
                try await operation()
            } catch {
                errorHandler(error)
            }
        }
    }
}
