//
//  ShowListView.swift
//  ShowSphere
//
//  Created by Sathya Krishna GR on 28/03/26.
//


import SwiftUI

// MARK: - Main View
struct ShowListView: View {
    
    @State private var viewModel: ShowListViewModel
    
    init(viewModel: ShowListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        tvMazeShowList
            .navigationTitle("Shows")
            .task {
                await viewModel.loadInitial()
            }
            .refreshable {
                await viewModel.refresh()
            }
    }
    
    // MARK: - Content
    @ViewBuilder
    private var tvMazeShowList: some View {
        switch viewModel.state {
            
        case .loading:
            ProgressView()
            
        case .error(let message):
            StateView(
                text: message,
                systemImage: "exclamationmark.triangle"
            )
            
        case .empty:
            StateView(
                text: "No Shows Found",
                systemImage: "film"
            )
            
        case .loaded, .idle:
            List(viewModel.shows) { show in
                NavigationLink {
                    ShowDetailView(show: show)
                } label: {
                    ShowRow(show: show)
                }
                .task {
                    viewModel.loadMoreIfNeeded(currentItem: show)
                }
            }
            .listStyle(.plain)
        }
    }
}
