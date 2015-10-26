//
//  NumberUtils.swift
//  Geometry
//
//  Created by Eric Ito on 10/25/15.
//  Copyright © 2015 Eric Ito. All rights reserved.
//

import Foundation

public class NumberUtils {
    
    public class func snap<T where T: Comparable>(v: T, minv: T, maxv: T) -> T {
        return v < minv ? minv : v > maxv ? maxv : v
    }

    class func sizeOf(v: Double) -> Int {
        return 8
    }

    class func sizeOfDouble() -> Int {
        return 8
    }

    class func sizeOf(v: Int) -> Int {
        return 4
    }

    class func sizeOf(v: Int64) -> Int {
        return 8
    }
    
    // FIXME:
//    static int sizeOf(byte v) {
//    return 1;
//    }
    

    class func isNaN(d: Double) -> Bool {
        return d.isNaN
    }
    
//    final static double TheNaN = Double.NaN;


    class func NaN() -> Double {
        return Double.NaN
    }
    
    class func hash(n: Int) -> Int {
        var hash = 5381;
        hash = ((hash << 5) + hash) + (n & 0xFF) /* hash * 33 + c */
        hash = ((hash << 5) + hash) + ((n >> 8) & 0xFF)
        hash = ((hash << 5) + hash) + ((n >> 16) & 0xFF)
        hash = ((hash << 5) + hash) + ((n >> 24) & 0xFF)
        hash &= 0x7FFFFFFF
        return hash
    }
    
    // FIXME:
    class func hash(d: Double) -> Int {
//    long bits = Double.doubleToLongBits(d);
//    int hc = (int) (bits ^ (bits >>> 32));
//    return hash(hc);
        return 0
    }
    
    class func hash(hashIn: Int, n: Int) -> Int {
        var hash = ((hashIn << 5) + hashIn) + (n & 0xFF) /* hash * 33 + c */
        hash = ((hash << 5) + hash) + ((n >> 8) & 0xFF)
        hash = ((hash << 5) + hash) + ((n >> 16) & 0xFF)
        hash = ((hash << 5) + hash) + ((n >> 24) & 0xFF)
        hash &= 0x7FFFFFFF
        return hash
    }
    
    // FIXME:
    class func hash(hash: Int, d: Double) -> Int {
//    long bits = Double.doubleToLongBits(d);
//    int hc = (int) (bits ^ (bits >>> 32));
//    return hash(hash, hc);
        return 0
    }
    
//    static long doubleToInt64Bits(double d) {
//    return Double.doubleToLongBits(d);
//    }
//    
    
    class func negativeInf() -> Double {
        return -Double.infinity
    }
    
    class func positiveInf() -> Double {
        return Double.infinity
    }
    
    class func intMax() -> Int {
        return Int.max
    }
    
    class func doubleEps() -> Double {
        return 2.2204460492503131e-016
    }
    
    // FIXME: max not inf
    class func doubleMax() -> Double {
//    return Double.max
        return Double.infinity
    }
    
    class func nextRand(prevRand: Int) -> Int {
        // according to Wiki, this is gcc's
        return (1103515245 * prevRand + 12345) & intMax()
    }
}