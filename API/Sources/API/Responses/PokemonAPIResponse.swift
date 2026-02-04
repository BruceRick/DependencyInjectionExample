//
//  PokemonAPIResponse.swift
//  API
//
//  Created by Bruce Rick on 2026-02-03.
//

import Foundation

public struct PokemonAPIResponse: APIResponseProtocol {
    public struct Item: Decodable {
        public let name: String
        
        public init(name: String) {
            self.name = name
        }
    }
    
    public let results: [Item]
    
    public init(results: [Item]) {
        self.results = results
    }
}
