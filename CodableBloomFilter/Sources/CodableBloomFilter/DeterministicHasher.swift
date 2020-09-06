// Copyright © 2020 Metabolist. All rights reserved.

import Foundation

public enum DeterministicHasher: String, Codable {
    case djb2
    case sdbm
}

extension DeterministicHasher {
    func apply(_ hashable: DeterministicallyHashable) -> Int {
        Array(hashable.hashableData)
            .map(Int.init)
            .reduce(initial, then)
    }
}

// https://gist.github.com/kharrison/2355182ac03b481921073c5cf6d77a73

private extension DeterministicHasher {
    var initial: Int {
        switch self {
        case .djb2: return 5381
        case .sdbm: return 0
        }
    }

    func then(result: Int, next: Int) -> Int {
        switch self {
        case .djb2:
            return (result << 5) &+ result &+ next
        case .sdbm:
            return next &+ (result << 6) &+ (result << 16) - result
        }
    }
}
