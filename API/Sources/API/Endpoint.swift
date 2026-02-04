//
//  Endpoint.swift
//  API
//
//  Created by Bruce Rick on 2026-02-03.
//

import Foundation

public enum Endpoint {
    case pokemon, pokemonDetails(String)
    
    var path: String {
        switch self {
        case .pokemon:
            "pokemon/"
        case .pokemonDetails(let name):
            "pokemon/\(name)"
        }
    }
}
