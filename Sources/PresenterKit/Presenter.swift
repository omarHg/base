//
//  Presenter.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 24/09/26.
//

@MainActor
public protocol Presenter { }

extension Presenter {
    @discardableResult
    public func safeTask(
        _ operation: @escaping @MainActor () async throws -> Void,
        catch errorHandler: (@MainActor (Error) -> Void)? = nil
    ) -> Task<Void, Never> {
        Task { @MainActor in
            do {
                try await operation()
            } catch {
                errorHandler?(error)
            }
        }
    }
}
