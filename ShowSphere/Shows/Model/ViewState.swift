//
//  ViewState.swift
//  ShowSphere
//
//  Created by Sathya Krishna GR on 28/03/26.
//


import Foundation

enum ViewState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case error(String)
}
extension ViewState {
    static func == (lhs: ViewState, rhs: ViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading), (.loaded, .loaded), (.empty, .empty):
            return true
        case let (.error(l), .error(r)):
            return l == r
        default:
            return false
        }
    }
}

