//
//  Point2D.swift
//  Geometry
//
//  Created by Eric Ito on 10/26/15.
//  Copyright © 2015 Eric Ito. All rights reserved.
//

import Foundation

/** Basic 2D point class. Contains only two double fields. */
public final class Point2D {
    
    private static let serialVersionUID: Int64 = 1
    
    public private(set) var x: Double = 0
    public private(set) var y: Double = 0
    
    public init() {}
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    public func setCoords(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    public func setCoords(other: Point2D) {
        x = other.x
        y = other.y
    }
    
    public func isEqual(other: Point2D) -> Bool {
        return x == other.x && y == other.y
    }
    
    public func isEqual(x: Double, y: Double) -> Bool {
        return self.x == x && self.y == y
    }
    
    public func isEqual(other: Point2D, tol: Double) -> Bool {
        return (abs(x - other.x) <= tol) && (abs(y - other.y) <= tol)
    }
    
    public func equals(other: Point2D) -> Bool {
        return x == other.x && y == other.y
    }
    
    //FIXME: 
//    @Override
//    public boolean equals(Object other) {
//    if (other == this)
//    return true;
//    
//    if (!(other instanceof Point2D))
//    return false;
//    
//    Point2D v = (Point2D)other;
//    
//    return x == v.x && y == v.y;
//    }
    

    public func sub(other: Point2D) {
        x -= other.x
        y -= other.y
    }
    
    public func sub(p1: Point2D, p2: Point2D) {
        x = p1.x - p2.x
        y = p1.y - p2.y
    }
    
    public func add(other: Point2D) {
        x += other.x
        y += other.y
    }
    
    public func add(p1: Point2D, p2: Point2D) {
        x = p1.x + p2.x
        y = p1.y + p2.y
    }
    
    public func negate() {
        x = -x
        y = -y
    }
    
    public func negate(other: Point2D) {
        x = -other.x
        y = -other.y
    }
    
    public func interpolate(other: Point2D, alpha: Double) {
        x = x * (1.0 - alpha) + other.x * alpha
        y = y * (1.0 - alpha) + other.y * alpha
    }
    
    public func interpolate(p1: Point2D, p2: Point2D, alpha: Double) {
        x = p1.x * (1.0 - alpha) + p2.x * alpha
        y = p1.y * (1.0 - alpha) + p2.y * alpha
    }
    
    public func scaleAdd(f: Double, shift: Point2D) {
        x = x * f + shift.x
        y = y * f + shift.y
    }
    
    public func scaleAdd(f: Double, other: Point2D, shift: Point2D) {
        x = other.x * f + shift.x
        y = other.y * f + shift.y
    }
    
    public func scale(f: Double, other: Point2D) {
        x = f * other.x
        y = f * other.y
    }
    
    public func scale(f: Double) {
        x *= f
        y *= f
    }
    
    /** Compares two vertices lexicographicaly. */
    public func compare(other: Point2D) -> Int {
        return y < other.y ? -1 : (y > other.y ? 1 : (x < other.x ? -1
            : (x > other.x ? 1 : 0)))
    }
    
    public func normalize(other: Point2D) {
        let len = other.length();
        if len == 0 {
            x = 1.0
            y = 0.0
        } else {
            x = other.x / len
            y = other.y / len
        }
    }
    
    public func normalize() {
        let len = length()
        if len == 0 {
            x = 1.0
            y = 0.0
        }
        x /= len
        y /= len
    }
    
    public func length() -> Double {
        return sqrt(x * x + y * y)
    }
    
    public func sqrLength() -> Double {
        return x * x + y * y
    }
    
    public class func distance(pt1: Point2D, pt2: Point2D) -> Double {
        return sqrt(sqrDistance(pt1, pt2))
    }
    
    public func dotProduct(other: Point2D) -> Double {
        return x * other.x + y * other.y
    }
    
    func dotProductAbs(other: Point2D) -> Double {
        return abs(x * other.x) + abs(y * other.y)
    }
    
    public func crossProduct(other: Point2D) -> Double {
        return x * other.y - y * other.x
    }
    
    public func rotateDirect(Cos: Double, Sin: Double) {
        // corresponds to the
        // Transformation2D.SetRotate(cos,
        // sin).Transform(pt)
        let xx = x * Cos - y * Sin
        let yy = x * Sin + y * Cos
        x = xx
        y = yy
    }
    
    public func rotateReverse(Cos: Double, Sin: Double) {
        let xx = x * Cos + y * Sin
        let yy = -x * Sin + y * Cos
        x = xx
        y = yy
    }
    
    /**
     90 degree rotation, anticlockwise. Equivalent to RotateDirect(cos(pi/2),
     sin(pi/2)).
    */
    public func leftPerpendicular() {
        let xx = x
        x = -y
        y = xx
    }
    
    /**
     90 degree rotation, anticlockwise. Equivalent to RotateDirect(cos(pi/2),
     sin(pi/2)).
    */
    public func leftPerpendicular(pt: Point2D) {
        x = -pt.y
        y = pt.x
    }
    
    /**
     270 degree rotation, anticlockwise. Equivalent to
     RotateDirect(-cos(pi/2), sin(-pi/2)).
    */
    public func rightPerpendicular() {
        let xx = x
        x = y
        y = -xx
    }
    
    /**
     270 degree rotation, anticlockwise. Equivalent to
     RotateDirect(-cos(pi/2), sin(-pi/2)).
    */
    public func rightPerpendicular(pt: Point2D) {
        x = pt.y
        y = -pt.x
    }
    
    func setNan() {
        x = NumberUtils.NaN()
        y = NumberUtils.NaN()
    }
    
    func isNan() -> Bool {
        return NumberUtils.isNaN(x)
    }
    
    /** 
    Calculates which quarter of xy plane the vector lies in. First quater is
    between vectors (1,0) and (0, 1), second between (0, 1) and (-1, 0), etc.
    The quarters are numbered counterclockwise.
    Angle intervals corresponding to quarters: 1 : [0 : 90); 2 : [90 : 180);
    3 : [180 : 270); 4 : [270 : 360)
    */
    final func quarter() -> Int {
        if x > 0 {
            if y >= 0 {
                return 1 // x > 0 && y <= 0
            } else {
                // y < 0 && x > 0. Should be x >= 0 && y < 0. The x ==
                // 0 case is processed later.
                return 4
            }
        } else {
            if y > 0 {
                return 2 // x <= 0 && y > 0
            } else {
                // 3: x < 0 && y <= 0. The case x == 0 &&
                // y <= 0 is attribute to the case 4.
                // The point x==0 and y==0 is a bug, but
                // will be assigned to 4.
                return x == 0 ? 4 : 3
            }
        }
    }
    
    /**
     Assume vector v1 and v2 have same origin. The function compares the
     vectors by angle in the counter clockwise direction from the axis X.
    
     For example, V1 makes 30 degree angle counterclockwise from horizontal x axis
     V2, makes 270, V3 makes 90, then
     compareVectors(V1, V2) == -1.
     compareVectors(V1, V3) == -1.
     compareVectors(V2, V3) == 1.
     @return Returns 1 if v1 is less than v2, 0 if equal, and 1 if greater.
    */
    public class func compareVectors(v1: Point2D, v2: Point2D) -> Int {
        let q1 = v1.quarter()
        let q2 = v2.quarter()
        
        if q2 == q1 {
            let cross = v1.crossProduct(v2)
            return cross < 0 ? 1 : (cross > 0 ? -1 : 0)
        } else {
            return q1 < q2 ? -1 : 1
        }
    }
    
}
