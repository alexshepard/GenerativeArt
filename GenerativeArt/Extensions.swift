//
//  Extensions.swift
//  GenerativeArt
//
//  Created by Alex Shepard on 7/11/21.
//

import Foundation
import CoreGraphics
import Swift
import UIKit

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

extension CGPoint {
    func distance(to other: CGPoint) -> CGFloat {
        let xDist = self.x - other.x
        let yDist = self.y - other.y
        return sqrt(xDist * xDist + yDist * yDist)
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

extension UIImage {
    // adapted from https://christianselig.com/2021/04/efficient-average-color/
    func allColors(size: CGSize) -> [UIColor]? {
        guard let cgImage = cgImage else { return nil }
                
        let width = Int(size.width)
        let height = Int(size.height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let bitmapInfo: UInt32 = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
        
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: colorSpace, bitmapInfo: bitmapInfo) else { return nil }

        context.draw(cgImage, in: CGRect(origin: .zero, size: size))

        guard let pixelBuffer = context.data else { return nil }
        
        let pointer = pixelBuffer.bindMemory(to: UInt32.self, capacity: width * height)
        
        var colors = [UIColor]()
        
        for y in 0 ..< height {
            for x in 0 ..< width {
                let pixel = pointer[(y * width) + x]
                let r = red(for: pixel)
                let g = green(for: pixel)
                let b = blue(for: pixel)

                let color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
                colors.append(color)
            }
        }
        
        return colors
    }
    
    private func red(for pixelData: UInt32) -> UInt8 {
        return UInt8((pixelData >> 16) & 255)
    }

    private func green(for pixelData: UInt32) -> UInt8 {
        return UInt8((pixelData >> 8) & 255)
    }

    private func blue(for pixelData: UInt32) -> UInt8 {
        return UInt8((pixelData >> 0) & 255)
    }
}

