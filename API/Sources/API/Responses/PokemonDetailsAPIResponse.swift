//
//  PokemonDetailsAPIResponse.swift
//  API
//
//  Created by Bruce Rick on 2026-02-03.
//

import Foundation

public struct PokemonDetailsAPIResponse: APIResponseProtocol {
    public let order: Int
    public let sprites: Sprite
    public let types: [TypeItem]
    
    public struct TypeItem: Decodable {
        public let type: Details
        
        public struct Details: Decodable {
            public let name: String
        }
    }
    
    public struct Sprite: Decodable {
        public let frontDefault: String
    }
}

