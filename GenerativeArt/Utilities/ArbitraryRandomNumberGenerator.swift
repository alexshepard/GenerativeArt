//
//  ArbitraryRandomNumberGenerator.swift
//  ArbitraryRandomNumberGenerator
//
//  Created by Alex Shepard on 7/26/21.
//

import Foundation
import GameplayKit

// thanks https://stackoverflow.com/a/57370987

struct ArbitraryRandomNumberGenerator : RandomNumberGenerator {

    mutating func next() -> UInt64 {
        // GKRandom produces values in [INT32_MIN, INT32_MAX] range; hence we need two numbers to produce 64-bit value.
        let next1 = UInt64(bitPattern: Int64(gkrandom.nextInt()))
        let next2 = UInt64(bitPattern: Int64(gkrandom.nextInt()))
        return next1 ^ (next2 << 32)
    }

    init(seed: UInt64) {
        self.gkrandom = GKMersenneTwisterRandomSource(seed: seed)
    }

    private let gkrandom: GKRandom
}
