//
//  DependencyInjectionExampleApp.swift
//  DependencyInjectionExample
//
//  Created by Bruce Rick on 2026-02-03.
//

import SwiftUI
import API

@main
struct DependencyInjectionExampleApp: App {
    var body: some Scene {
        WindowGroup {
            PokemonListView(viewModel: .init())
                .environment(\.api, LiveAPI())
        }
    }
}

private enum DependencyError: LocalizedError {
    case notInitialized(String)
    
    var errorDescription: String? {
        switch self {
        case .notInitialized(let name):
            "*\(name)* NOT INITIALIZED"
        }
    }
}

private struct NonInitializedAPI: API {
    func fetchData<APIResponse: APIResponseProtocol>(_ endpoint: Endpoint) async throws -> APIResponse {
        throw DependencyError.notInitialized("API")
    }
}

private struct APIEnvironmentKey: EnvironmentKey {
    static let defaultValue: API = NonInitializedAPI()
}

extension EnvironmentValues {
    var api: API {
        get { self[APIEnvironmentKey.self] }
        set { self[APIEnvironmentKey.self] = newValue }
    }
}
