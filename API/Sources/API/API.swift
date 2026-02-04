//
//  API.swift
//  API
//
//  Created by Bruce Rick on 2026-02-03.
//

import Foundation

public protocol API {
    func fetchData<APIResponse: APIResponseProtocol>(_ endpoint: Endpoint) async throws -> APIResponse
}

public struct LiveAPI: API {
    let baseURL = "https://pokeapi.co/api/v2/"
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    let urlSession = URLSession.shared
    
    public func fetchData<APIResponse: APIResponseProtocol>(_ endpoint: Endpoint) async throws -> APIResponse {
        guard let url = URL(string: baseURL + endpoint.path) else {
            fatalError("INVALID URL")
        }
        
        let (data, _) = try await urlSession.data(from: url)
        let decoded = try decoder.decode(APIResponse.self, from: data)

        return decoded
    }
    
    public init() {}
}
