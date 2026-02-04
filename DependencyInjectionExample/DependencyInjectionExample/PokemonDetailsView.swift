//
//  PokemonDetailsView.swift
//  DependencyInjectionExample
//
//  Created by Bruce Rick on 2026-02-03.
//

import API
import Foundation
import SwiftUI

struct PokemonDetailsView: View {
    @Environment(\.api) private var api
    @State private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .navigationTitle(viewModel.name.capitalized)
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
        case .error(let error):
            errorView(error)
        }
    }
    
    func list(pokemon: ViewModel.PokemonDetailsModel) -> some View {
        List {
            if let spriteURL = URL(string: pokemon.spriteURLString) {
                Section {
                    VStack(alignment: .center) {
                        Spacer()
                        AsyncImage(url: spriteURL) { image in
                            image
                        } placeholder: {
                            ProgressView()
                        }
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
            Section {
                LabeledContent("Order", value: String(pokemon.order))
                LabeledContent {
                    HStack {
                        ForEach(pokemon.typing, id: \.self) {
                            Text($0.capitalized)
                                .padding(6)
                                .foregroundStyle(Color.white)
                                .background(Color.accentColor, in: Capsule())
                        }
                    }
                } label: {
                    Text("Types")
                }
            }
        }
    }
    
    var loading: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .padding()
    }
    
    func errorView(_ error: Error) -> some View {
        VStack {
            Spacer()
            Text(error.localizedDescription)
            Spacer()
        }
        .padding()
    }
}

extension PokemonDetailsView {
    @MainActor
    @Observable
    class ViewModel {
        var name: String
        var state: State
        
        init(name: String, state: State = State.notLoaded) {
            self.name = name
            self.state = state
        }
        
        func loadPokemon(_ api: API) {
            state = .loading
            Task {
                do {
                    let pokemon: PokemonDetailsAPIResponse = try await api.fetchData(.pokemonDetails(name))
                    state = .loaded(.init(
                        order: pokemon.order,
                        spriteURLString: pokemon.sprites.frontDefault,
                        typing: pokemon.types.map { $0.type.name }
                    ))
                }
                catch {
                    state = .error(error)
                }
            }
        }
    }
}

extension PokemonDetailsView.ViewModel {
    enum State: Equatable {
        case loaded(PokemonDetailsModel), notLoaded, loading, error(Error)
        
        static func == (lhs: PokemonDetailsView.ViewModel.State, rhs: PokemonDetailsView.ViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.loaded, .loaded), (.notLoaded, .notLoaded), (.loading, .loading), (.error, .error):
                true
            default:
                false
            }
        }
    }
    
    struct PokemonDetailsModel {
        let order: Int
        let spriteURLString: String
        let typing: [String]
    }
}

#Preview("Loaded") {
    let pokemon: PokemonDetailsView.ViewModel.PokemonDetailsModel = .init(
        order: 1,
        spriteURLString: "",
        typing: ["grass", "ghost"]
    )
    
    return NavigationStack {
        PokemonDetailsView(viewModel: .init(name: "Pokemon Name", state: .loaded(pokemon)))
    }
}

#Preview("Loading") {
    NavigationStack {
        PokemonDetailsView(viewModel: .init(name: "Pokemon Name", state: .loading))
    }
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

    return NavigationStack {
        PokemonDetailsView(viewModel: .init(name: "Pokemon Name", state: .error(MockError.error)))
    }
}
