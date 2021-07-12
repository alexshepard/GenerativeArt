//
//  Extensions.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/11/21.
//

import Foundation
import CoreGraphics

extension CGFloat {
    func clamp(range: ClosedRange<CGFloat> = CGFloat(0)...CGFloat(1.0)) -> CGFloat {
        var newVal = self
        if newVal > range.upperBound {
            newVal = range.upperBound
        } else if newVal < range.lowerBound {
            newVal = range.lowerBound
        }
        return newVal
    }
    
    func deg2rad() -> CGFloat {
        return self * .pi / 180
    }
}
