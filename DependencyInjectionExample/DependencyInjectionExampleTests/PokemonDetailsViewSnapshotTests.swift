//
//  PokemonDetailsViewSnapshotTests.swift
//  DependencyInjectionExampleTests
//
//  Created by Bruce Rick on 2026-02-03.
//

import Foundation
import Testing
import SnapshotTesting
import SwiftUI
@testable import DependencyInjectionExample

@MainActor
struct PokemonDetailsViewSnapshotTests {
    @Test
    func loaded() {
        let pokemon: PokemonDetailsView.ViewModel.PokemonDetailsModel = .init(
            order: 1,
            spriteURLString: "",
            typing: ["grass", "ghost"]
        )
        
        testImageSnapshot(PokemonDetailsView(viewModel: .init(name: "Pokemon Name", state: .loaded(pokemon))).navigationStack())
    }
    
    @Test
    func loading() {
        testImageSnapshot(PokemonDetailsView(viewModel: .init(name: "Pokemon Name", state: .loading)).navigationStack())
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

        testImageSnapshot(PokemonDetailsView(viewModel: .init(
            name: "Pokemon Name",
            state: .error(MockError.error)
        )).navigationStack())
    }
}
