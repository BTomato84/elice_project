//
//  NetworkState.swift
//  elice_project
//
//  Created by 영수 박 on 2023/12/09.
//

import Foundation

enum NetworkState : Equatable {
    case busy(id: String)
    case done(id: String)
    case fail(error: Error, id: String)

    func createBusyState() -> NetworkState {
        return .busy(id: UUID().uuidString)
    }

    func done() -> NetworkState {
        switch self {
        case let .busy(id): return .done(id: id)
        default:            return self
        }
    }

    func fail(with error: Error) -> NetworkState {
        switch self {
        case let .busy(id): return .fail(error: error, id: id)
        default:            return self
        }
    }

    var isBusy : Bool {
        switch self {
        case .busy: return true
        default:    return false
        }
    }

    var sessionId : String {
        switch self {
        case let .busy(id):     return id
        case let .done(id):     return id
        case let .fail(_, id):  return id
        }
    }

    static func == (lhs: NetworkState, rhs: NetworkState) -> Bool {
        switch (lhs, rhs) {
        case let (.busy(lId), .busy(rId)):          return lId == rId
        case let (.done(lId), .done(rId)):          return lId == rId
        case let (.fail(_, lId), .fail(_, rId)):    return lId == rId
        default:                                    return false
        }
    }

    func isEqualSession(with state: NetworkState) -> Bool {
        self.sessionId == state.sessionId
    }
}
