//
//  PokemonListViewSnapshotTests.swift
//  DependencyInjectionExampleTests
//
//  Created by Bruce Rick on 2026-02-03.
//

import Foundation
import Testing
import SnapshotTesting
import UIKit
@testable import DependencyInjectionExample

@MainActor
struct PokemonListViewSnapshotTests {
    @Test
    func loaded() {
        let pokemon: [PokemonListView.ViewModel.PokemonModel] = [
            .init(name: "Pokemon 1"),
            .init(name: "Pokemon 2"),
            .init(name: "Pokemon 3"),
            .init(name: "Pokemon 4"),
        ]
        
        testImageSnapshot(PokemonListView(viewModel: .init(state: .loaded(pokemon))))
    }
    
    @Test
    func loading() {
        testImageSnapshot(PokemonListView(viewModel: .init(state: .loading)))
    }
    
    @Test
    func empty() {
        testImageSnapshot(PokemonListView(viewModel: .init(state: .empty)))
    }
    
    @Test
    func error() {
        enum MockError: LocalizedError {
            case error
            
            var errorDescription: String? {
                switch self {
                case .error:
                    "Really long error description to test this in previews"
                }
            }
        }

        testImageSnapshot(PokemonListView(viewModel: .init(state: .error(MockError.error))))
    }
}
