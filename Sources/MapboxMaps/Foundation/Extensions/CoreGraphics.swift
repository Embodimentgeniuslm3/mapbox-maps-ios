import Foundation
import CoreLocation
import CoreGraphics
import MapboxCoreMaps

// MARK: - CGPoint
extension CGPoint {

    /// Converts a `CGPoint` to an internal `ScreenCoordinate` type.
    internal var screenCoordinate: ScreenCoordinate {
        ScreenCoordinate(x: Double(x), y: Double(y))
    }

    /// Interpolate a point along a fraction of a line between two points.
    /// - Parameters:
    ///   - origin: The starting point for the interpolation.
    ///   - destination: The ending point for the interpolation.
    ///   - fraction: A value between 0 and 1 that represents the fraction to interpolate to.
    ///               A value of 0 represents the start position, and a value of 1
    ///               represents the end position.
    /// - Returns: A `CGPoint` that represents the fractional point along the path
    ///            between the source and destination points.
    internal static func interpolate(origin: CGPoint, destination: CGPoint, fraction: CGFloat) -> CGPoint {
        return CGPoint(x: origin.x + fraction * (destination.x - origin.x),
                       y: origin.y + fraction * (destination.y - origin.y))
    }
}

// MARK: - CGFloat
extension CGFloat {

    /// Converts a `CGFloat` to a `NSValue` which wraps a `Double`.
    internal var NSNumber: NSNumber {
        Foundation.NSNumber(value: Double(self))
    }
}

// MARK: - CGRect
extension CGRect {

    /// Returns a new `CGRect` whose origin is a given `CGPoint` value.
    /// - Parameter originPoint: The `CGPoint` which acts as the origin of the new `CGRect`.
    /// - Note: This method is the equivalent of `MGLExtendRect` in pre-v10.0.0 versions of the SDK.
    internal func extend(from originPoint: CGPoint) -> CGRect {

        var rect = self

        if originPoint.x < rect.origin.x {
            rect.size.width += rect.origin.x - originPoint.x
            rect.origin.x = originPoint.x
        }
        if originPoint.x > rect.origin.x + rect.size.width {
            rect.size.width += originPoint.x - (rect.origin.x + rect.size.width)
        }
        if originPoint.y < rect.origin.y {
            rect.size.height += rect.origin.y - originPoint.y
            rect.origin.y = originPoint.y
        }
        if originPoint.y > rect.origin.y + rect.size.height {
            rect.size.height += originPoint.y - (rect.origin.y + rect.size.height)
        }

        return rect
    }
}

extension CGImage {
    internal func isEmpty() -> Bool {
        let size = width * height

        guard let dataProvider = dataProvider, size > 0 else {
            return true
        }

        let pixelData = dataProvider.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let uint32Pointer = UnsafeRawPointer(data).bindMemory(to: UInt32.self, capacity: size)

        for x in 0..<size {
            if uint32Pointer[x] != 0 {
                return false
            }
        }

        return true
    }
}
