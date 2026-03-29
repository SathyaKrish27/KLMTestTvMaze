//
//  ShowSphereApp.swift
//  ShowSphere
//
//  Created by Sathya Krishna GR on 28/03/26.
//

import SwiftUI

@main
struct ShowSphereApp: App {
    
    // MARK: - Dependencies
    private let network = DefaultNetworkService()
    private let cache = FileCacheService()
    private let repository: ShowRepositoryProtocol
    
    init() {
        self.repository = ShowRepository(
            network: network,
            cache: cache
        )
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ShowListView(
                    viewModel: ShowListViewModel(
                        repository: repository
                    )
                )
            }
        }
    }
}
