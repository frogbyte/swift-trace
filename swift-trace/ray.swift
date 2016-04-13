//
//  ray.swift
//  swiftTrace
//
//  Created by Kristopher Campbell on 3/20/16.
//  Copyright © 2016 Kristopher Campbell. All rights reserved.
//
import simd

struct Ray {
    var origin, direction : double3
    
    init(origin: double3, direction: double3) {
        self.origin = origin
        self.direction = direction
    }

    init(_ origin: double3, _ direction: double3) {
        self.origin = origin
        self.direction = direction
    }

    init(direction: double3) {
        self.origin = double3()
        self.direction = direction
    }

    func PointAtParamerter(t: Double) -> double3{
        return origin + t * direction
    }
}