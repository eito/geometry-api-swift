//
//  MathUtils.swift
//  Geometry
//
//  Created by Eric Ito on 10/25/15.
//  Copyright © 2015 Eric Ito. All rights reserved.
//

import Foundation

final class MathUtils {
    
    
    
    /**
     The implementation of the Kahan summation algorithm. Use to get better
     precision when adding a lot of values.
    */
    final class KahanSummator {
        
        /** The accumulated sum */
        private var sum: Double = 0.0
        
        private var compensation: Double = 0.0
        
        /** the Base (the class returns sum + startValue) */
        private var startValue: Double = 0.0
        
        /**
         initialize to the given start value. \param startValue_ The value to
         be added to the accumulated sum.
        */
        init(startValue: Double) {
            self.startValue = startValue
            reset()
        }
        
        /**
         Resets the accumulated sum to zero. The getResult() returns
         startValue_ after this call.
        */
        func reset() {
            sum = 0
            compensation = 0
        }
        
        /** add a value. */
        func add(v: Double) {
            let y: Double = v - compensation
            let t: Double = sum + y
            let h: Double = t - sum
            compensation = h - y
            sum = t;
        }
        
        /** Subtracts a value. */
        func sub(v: Double) {
            add(-v)
        }

        /** add another summator. */
        func add(/* const */ v: KahanSummator) {
            let y: Double = (v.result() + v.compensation) - compensation
            let t: Double = sum + y
            let h: Double = t - sum
            compensation = h - y
            sum = t
        }
        
        /** Subtracts another summator. */
        func sub(/* const */ v: KahanSummator) {
            let y: Double = -(v.result() - v.compensation) - compensation
            let t: Double = sum + y
            let h: Double = t - sum
            compensation = h - y
            sum = t
        }
        
        /** Returns current value of the sum. */
        func result() -> Double /* const */{
            return startValue + sum
        }
    }
    
    /** Returns one value with the sign of another (like copysign). */
    class func copySign(x: Double, y: Double) -> Double {
        return y >= 0.0 ? abs(x) : -abs(x)
    }
    
    /** Calculates sign of the given value. Returns 0 if the value is equal to 0. */
    class func sign(value: Double) -> Int {
        return value < 0 ? -1 : (value > 0) ? 1 : 0;
    }
    
    /** C fmod function. */
    class func FMod(x: Double, y: Double) -> Double {
        return x - floor(x / y) * y
    }
    
    /** Rounds double to the closest integer value. */
    class func round(v: Double) -> Double {
        return floor(v + 0.5)
    }
    
    class func sqr(v: Double) -> Double {
        return v * v
    }
    
    /**
    Computes interpolation between two values, using the interpolation factor t.
    The interpolation formula is (end - start) * t + start.
    However, the computation ensures that t = 0 produces exactly start, and t = 1, produces exactly end.
    It also guarantees that for 0 <= t <= 1, the interpolated value v is between start and end.
    */
    class func lerp(start_: Double, end_: Double,t: Double) -> Double {
        // When end == start, we want result to be equal to start, for all t
        // values. At the same time, when end != start, we want the result to be
        // equal to start for t==0 and end for t == 1.0
        // The regular formula end_ * t + (1.0 - t) * start_, when end_ ==
        // start_, and t at 1/3, produces value different from start
        var v: Double = 0
        if t <= 0.5 {
            v = start_ + (end_ - start_) * t
        } else {
            v = end_ - (end_ - start_) * (1.0 - t)
        }
        
        assert (t < 0 || t > 1.0 || (v >= start_ && v <= end_) || (v <= start_ && v >= end_) || NumberUtils.isNaN(start_) || NumberUtils.isNaN(end_))
        return v
    }

    /**
    Computes interpolation between two values, using the interpolation factor t.
    The interpolation formula is (end - start) * t + start.
    However, the computation ensures that t = 0 produces exactly start, and t = 1, produces exactly end.
    It also guarantees that for 0 <= t <= 1, the interpolated value v is between start and end.
    */
    class func lerp(start_: Point2D , end_: Point2D , t: Double, result: Point2D ) {
        // When end == start, we want result to be equal to start, for all t
        // values. At the same time, when end != start, we want the result to be
        // equal to start for t==0 and end for t == 1.0
        // The regular formula end_ * t + (1.0 - t) * start_, when end_ ==
        // start_, and t at 1/3, produces value different from start
        if t <= 0.5 {
            result.x = start_.x + (end_.x - start_.x) * t
            result.y = start_.y + (end_.y - start_.y) * t
        } else {
            result.x = end_.x - (end_.x - start_.x) * (1.0 - t)
            result.y = end_.y - (end_.y - start_.y) * (1.0 - t)
        }
        
        assert (t < 0 || t > 1.0 || (result.x >= start_.x && result.x <= end_.x) || (result.x <= start_.x && result.x >= end_.x))
        assert (t < 0 || t > 1.0 || (result.y >= start_.y && result.y <= end_.y) || (result.y <= start_.y && result.y >= end_.y))
    }
    
    class func lerp(start_x: Double, start_y: Double, end_x: Double, end_y: Double, t: Double, result: Point2D) {
        // When end == start, we want result to be equal to start, for all t
        // values. At the same time, when end != start, we want the result to be
        // equal to start for t==0 and end for t == 1.0
        // The regular formula end_ * t + (1.0 - t) * start_, when end_ ==
        // start_, and t at 1/3, produces value different from start
        if t <= 0.5 {
            result.x = start_x + (end_x - start_x) * t
            result.y = start_y + (end_y - start_y) * t
        } else {
            result.x = end_x - (end_x - start_x) * (1.0 - t)
            result.y = end_y - (end_y - start_y) * (1.0 - t)
        }
        
        assert (t < 0 || t > 1.0 || (result.x >= start_x && result.x <= end_x) || (result.x <= start_x && result.x >= end_x))
        assert (t < 0 || t > 1.0 || (result.y >= start_y && result.y <= end_y) || (result.y <= start_y && result.y >= end_y))
    }
}

// MARK: Operators for KahanSummator

func +=(inout left: MathUtils.KahanSummator, right: Double) {
    left.add(right)
}

func -=(inout left: MathUtils.KahanSummator, right: Double) {
    left.add(-right)
}

func +=(inout left: MathUtils.KahanSummator, right: MathUtils.KahanSummator) {
    left.add(right)
}

func -=(inout left: MathUtils.KahanSummator, right: MathUtils.KahanSummator) {
    left.sub(right)
}
