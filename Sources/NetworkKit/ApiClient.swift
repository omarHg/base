//
//  ApiClient.swift
//  Base
//
//  Created by Omar Hernandez Gonzalez on 27/02/26.
//

import Foundation

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
    
    public init(session: URLSession = .shared, jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.jsonDecoder = jsonDecoder
    }
    
    
    public func execute<Response>(request: ApiRequest) async throws -> Response where Response : Decodable {
        var request = request.build()
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
            let dataString = String(data: data, encoding: .utf8)
            Console.logApi(dataString ?? "")
            return try jsonDecoder.decode(Response.self, from: data)
        } catch {
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
