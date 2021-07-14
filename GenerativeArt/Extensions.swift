//
//  Extensions.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/11/21.
//

import Foundation
import CoreGraphics
import Swift

extension CGFloat {
    func deg2rad() -> CGFloat {
        return self * .pi / 180
    }
    
    func map(minRange: CGFloat, maxRange: CGFloat, minDomain: CGFloat, maxDomain: CGFloat) -> CGFloat {
        return minDomain + (maxDomain - minDomain) * (self - minRange) / (maxRange - minRange)
    }

    func lerp(to: CGFloat, alpha: CGFloat) -> CGFloat {
        return self + alpha * (to - self)
    }
}

extension Comparable {
    func clamp(to range: ClosedRange<Self>) -> Self {
        let min = range.lowerBound
        let max = range.upperBound
        
        if self < min {
            return min
        } else if self > max {
            return max
        } else {
            return self
        }
    }
}
