//
//  ApiClient.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 27/02/26.
//

import Foundation
import Combine

private struct _SendablePassthroughSubject<Value>: @unchecked Sendable {
    let subject: PassthroughSubject<Value, Never>
    init(_ subject: PassthroughSubject<Value, Never> = .init()) {
        self.subject = subject
    }
}

public enum AuthEvents {
    // Un Subject que emite el nuevo token cada vez que se hace inicio de sesión
    // Wrapped in an @unchecked Sendable container to acknowledge Combine's non-Sendable type
    private static let _token = _SendablePassthroughSubject<String>()
    public static var tokenPublisher: PassthroughSubject<String, Never> { _token.subject }
}

public protocol ApiClient: Actor {
    func request<T: Decodable>(endpoint: String,
                               method: HTTPMethod,
                               body: Data?,
                               headers: [String: String]?) async throws -> T
    func execute<Response: Decodable>(request: ApiRequest) async throws -> Response
}

public actor APIClientImplementation: ApiClient {
    private let session: URLSession
    private let jsonDecoder: JSONDecoder
    private var token: String?
    private var cancellables = Set<AnyCancellable>()
    
    public init(session: URLSession = .shared,
                jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.jsonDecoder = jsonDecoder
        // Defer subscription setup to avoid calling actor-isolated method synchronously from init
        Task { [weak self] in
            await self?.setupTokenSubscription()
        }
    }
    
    private func setupTokenSubscription() async {
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            AuthEvents.tokenPublisher
                .sink { [weak self] nuevoToken in
                    Task { [weak self] in
                        await self?.actualizarToken(nuevoToken)
                    }
                }
                .store(in: &cancellables)
            continuation.resume()
        }
    }
    
    // Función aislada dentro del actor para cambiar el estado de la variable privada
    private func actualizarToken(_ nuevoToken: String) {
        self.token = nuevoToken
        Console.logInfo("💡 APIClientImplementation: El token se actualizó de forma segura vía Combine.")
    }
    
    public func execute<Response>(request: ApiRequest) async throws -> Response where Response : Decodable {
        Console.logApi(request: request)
        let urlRequest = request
            .token(token)
            .build()
        // Execute the network request using async/await
        let (data, response) = try await session.data(for: urlRequest)
        var catchURLResponse: HTTPURLResponse?
        var catchData: Data?
        // Validate the HTTP response code
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidData
        }
        catchURLResponse = httpResponse
        catchData = data
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.requestFailed(statusCode: httpResponse.statusCode)
        }
        
        // Decode and return the expected type
        do {
            Console.logApi(response: httpResponse, request: request, data: data)
            return try jsonDecoder.decode(Response.self, from: data)
        } catch {
            Console.logApi(
                error: error,
                request: request,
                response: catchURLResponse,
                data: catchData)
            throw APIError.invalidData
        }
    }
    /// Sends an asynchronous network request and returns a decoded object
    public func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: Data? = nil,
        headers: [String: String]? = nil
    ) async throws -> T {
        
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        // Add headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Execute the network request using async/await
        let (data, response) = try await session.data(for: request)
        
        // Validate the HTTP response code
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidData
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.requestFailed(statusCode: httpResponse.statusCode)
        }
        
        // Decode and return the expected type
        do {
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
            throw APIError.invalidData
        }
    }
}

