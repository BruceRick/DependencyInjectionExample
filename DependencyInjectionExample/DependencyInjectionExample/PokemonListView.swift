//
//  PokemonListView.swift
//  DependencyInjectionExample
//
//  Created by Bruce Rick on 2026-02-03.
//

import API
import Foundation
import SwiftUI

struct PokemonListView: View {
    @Environment(\.api) private var api
    @State private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Pokemon")
        }
        .onAppear {
            if viewModel.state == .notLoaded {
                viewModel.loadPokemon(api)
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .loaded(let pokemon):
            list(pokemon: pokemon)
        case .loading, .notLoaded:
            loading
        case .empty:
            empty
        case .error(let error):
            errorView(error)
        }
    }
    
    func list(pokemon: [ViewModel.PokemonModel]) -> some View {
        List(pokemon, id: \.name) { pokemon in
            NavigationLink(pokemon.name.capitalized) {
                PokemonDetailsView(viewModel: .init(name: pokemon.name))
            }
        }
    }
    
    var loading: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
    
    var empty: some View {
        VStack {
            Spacer()
            Text("No Pokemon")
            Spacer()
        }
        .padding()
    }
    
    func errorView(_ error: Error) -> some View {
        VStack {
            Spacer()
            Text(error.localizedDescription)
                .foregroundStyle(Color.red)
                .fontWeight(.semibold)
            Spacer()
        }
        .padding()
    }
}

extension PokemonListView {
    @MainActor
    @Observable
    class ViewModel {
        var state: State
        
        init(state: State = State.notLoaded) {
            self.state = state
        }
        
        func loadPokemon(_ api: API) {
            state = .loading
            Task {
                do {
                    let pokemon: PokemonAPIResponse = try await api.fetchData(.pokemon)
                    let models = pokemon.results.map { PokemonModel(name: $0.name) }
                    state = models.isEmpty ? .empty : .loaded(models)
                }
                catch {
                    state = .error(error)
                }
            }
        }
    }
}

extension PokemonListView.ViewModel {
    enum State: Equatable {
        case loaded([PokemonModel]), notLoaded, loading, empty, error(Error)
        
        static func == (lhs: PokemonListView.ViewModel.State, rhs: PokemonListView.ViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.loaded, .loaded), (.notLoaded, .notLoaded), (.loading, .loading), (.empty, .empty), (.error, .error):
                true
            default:
                false
            }
        }
    }
    
    struct PokemonModel {
        let name: String
        
        init(name: String) {
            self.name = name
        }
    }
}

#Preview("Loaded") {
    let pokemon: [PokemonListView.ViewModel.PokemonModel] = [
        .init(name: "Pokemon 1"),
        .init(name: "Pokemon 2"),
        .init(name: "Pokemon 3"),
        .init(name: "Pokemon 4"),
    ]
    
    return PokemonListView(viewModel: .init(state: .loaded(pokemon)))
}

#Preview("Loading") {
    PokemonListView(viewModel: .init(state: .loading))
}

#Preview("Empty") {
    PokemonListView(viewModel: .init(state: .empty))
}

#Preview("Error") {
    enum MockError: LocalizedError {
        case error
        
        var errorDescription: String? {
            switch self {
            case .error:
                "Really long error description to test this in previews"
            }
        }
    }

    return PokemonListView(viewModel: .init(state: .error(MockError.error)))
}
