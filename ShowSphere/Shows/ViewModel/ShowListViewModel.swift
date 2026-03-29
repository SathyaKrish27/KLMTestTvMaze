//
//  ShowListViewModel.swift
//  ShowSphere
//
//  Created by Sathya Krishna GR on 28/03/26.
//


import Foundation
import Observation

@Observable
@MainActor
final class ShowListViewModel {
    // MARK: - State

    var shows: [Show] = []
    var state: ViewState = .idle
    
    // MARK: - Private

    private let repository: ShowRepositoryProtocol
    
    private var allShows: [Show] = []
    private let pageSize = 20
    
    private var currentIndex = 0
    private var isFetching = false
    
    // MARK: - Init

    init(repository: ShowRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Initial Load

    func loadInitial() async {
        guard shows.isEmpty else { return }
        
        state = .loading
        
        do {
            allShows = try await repository.fetchShows()
            
            appendNextPage()
            
            state = shows.isEmpty ? .empty : .loaded
            
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    // MARK: - Pagination Trigger

    func loadMoreIfNeeded(currentItem: Show) {
        guard let last = shows.last else { return }
        
        if currentItem.id == last.id {
            appendNextPage()
        }
    }
    
    // MARK: - Pagination Logic

    private func appendNextPage() {
        guard !isFetching else { return }
        
        isFetching = true
        
        let nextBatch = allShows
            .dropFirst(currentIndex)
            .prefix(pageSize)
        
        guard !nextBatch.isEmpty else {
            isFetching = false
            return
        }
        
        shows.append(contentsOf: nextBatch)
        currentIndex += nextBatch.count
        
        isFetching = false
    }
    
    // MARK: - Refresh

    func refresh() async {
        shows.removeAll()
        allShows.removeAll()
        currentIndex = 0
        
        await loadInitial()
    }
}
