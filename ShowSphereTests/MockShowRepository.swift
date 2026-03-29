//
//  MockShowRepository.swift
//  ShowSphere
//
//  Created by Sathya Krishna GR on 29/03/26.
//


import Testing
@testable import AirFranceInterviewTest

final class MockShowRepository: ShowRepositoryProtocol {
    
    var result: Result<[Show], Error> = .success([])
    
    func fetchShows() async throws -> [Show] {
        switch result {
        case .success(let shows):
            return shows
        case .failure(let error):
            throw error
        }
    }
}
