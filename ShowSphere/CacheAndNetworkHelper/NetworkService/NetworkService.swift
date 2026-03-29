//
//  NetworkError.swift
//  ShowSphere
//
//  Created by Sathya Krishna GR on 28/03/26.
//


import Foundation
import os

// MARK: - Network Error
enum NetworkError: Error {
    case invalidResponse
    case serverError(Int)
    case decodingError(Error)
}

// MARK: - Endpoint
enum Endpoint {
    
    case shows(page: Int)
    
    // MARK: - Base URL
    private var baseURL: URL {
        URL(string: "https://api.tvmaze.com")!
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .shows:
            return "/shows"
        }
    }
    
    // MARK: - Request
    var urlRequest: URLRequest {
        let components = URLComponents(
            url: baseURL.appendingPathComponent(path),
            resolvingAgainstBaseURL: false
        )!
        
        
        guard let url = components.url else {
            fatalError("❌ Invalid URL components")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        
        return request
    }
}

// MARK: - Network Service Protocol
protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

// MARK: - Default Implementation
final class DefaultNetworkService: NetworkService {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let logger = Logger(subsystem: "com.yourapp.network", category: "Network")
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
    }
    
    // MARK: - Request
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        
        let request = endpoint.urlRequest
        
        logger.debug("➡️ Request: \(request.url?.absoluteString ?? "")")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("❌ Invalid response")
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            logger.error("❌ Server error: \(httpResponse.statusCode)")
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        do {
            let decoded = try decoder.decode(T.self, from: data)
            logger.debug("✅ Decoding success")
            return decoded
            
        } catch {
            logger.error("❌ Decoding error: \(error.localizedDescription)")
            throw NetworkError.decodingError(error)
        }
    }
}
