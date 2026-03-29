//
//  ShowListViewModelTests.swift
//  ShowSphere
//
//  Created by Sathya Krishna GR on 29/03/26.
//


import Testing
@testable import AirFranceInterviewTest

@MainActor
struct ShowListViewModelTests {
    
    // Helper to generate dummy data
    private func makeShows(count: Int) -> [Show] {
        (0..<count).map { Show(id: $0, name: "Show \($0)") }
    }
    
    // MARK: - Initial Load
    
    @Test
    func loadInitial_success_loadsFirstPage() async throws {
        let repo = MockShowRepository()
        let allShows = makeShows(count: 50)
        repo.result = .success(allShows)
        
        let vm = ShowListViewModel(repository: repo)
        
        await vm.loadInitial()
        
        #expect(vm.state == .loaded)
        #expect(vm.shows.count == 20) // pageSize
    }
    
    @Test
    func loadInitial_empty_setsEmptyState() async {
        let repo = MockShowRepository()
        repo.result = .success([])
        
        let vm = ShowListViewModel(repository: repo)
        
        await vm.loadInitial()
        
        #expect(vm.state == .empty)
        #expect(vm.shows.isEmpty)
    }
    
    @Test
    func loadInitial_failure_setsErrorState() async {
        let repo = MockShowRepository()
        repo.result = .failure(MockError.testError)
        
        let vm = ShowListViewModel(repository: repo)
        
        await vm.loadInitial()
        
        if case .error = vm.state {
            #expect(true)
        } else {
            #expect(Bool(false))
        }
    }
    
    // MARK: - Pagination
    
    @Test
    func loadMoreIfNeeded_loadsNextPage() async {
        let repo = MockShowRepository()
        let allShows = makeShows(count: 45)
        repo.result = .success(allShows)
        
        let vm = ShowListViewModel(repository: repo)
        await vm.loadInitial()
        
        let lastItem = vm.shows.last!
        
        vm.loadMoreIfNeeded(currentItem: lastItem)
        
        #expect(vm.shows.count == 40) // 20 + next 20
    }
    
    @Test
    func loadMoreIfNeeded_doesNotLoadIfNotLastItem() async {
        let repo = MockShowRepository()
        let allShows = makeShows(count: 50)
        repo.result = .success(allShows)
        
        let vm = ShowListViewModel(repository: repo)
        await vm.loadInitial()
        
        let firstItem = vm.shows.first!
        
        vm.loadMoreIfNeeded(currentItem: firstItem)
        
        #expect(vm.shows.count == 20) // unchanged
    }
    
    @Test
    func pagination_stopsAtEnd() async {
        let repo = MockShowRepository()
        let allShows = makeShows(count: 30)
        repo.result = .success(allShows)
        
        let vm = ShowListViewModel(repository: repo)
        await vm.loadInitial()
        
        // Load all pages
        vm.loadMoreIfNeeded(currentItem: vm.shows.last!)
        vm.loadMoreIfNeeded(currentItem: vm.shows.last!)
        
        #expect(vm.shows.count == 30) // no overflow
    }
    
    // MARK: - Refresh
    
    @Test
    func refresh_resetsAndReloads() async {
        let repo = MockShowRepository()
        let allShows = makeShows(count: 40)
        repo.result = .success(allShows)
        
        let vm = ShowListViewModel(repository: repo)
        await vm.loadInitial()
        
        #expect(vm.shows.count == 20)
        
        await vm.refresh()
        
        #expect(vm.state == .loaded)
        #expect(vm.shows.count == 20) // fresh reload
    }
}
