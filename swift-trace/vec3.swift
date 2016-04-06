//
//  Vec3.swift
//  swiftTrace
//
//  Created by Kristopher Campbell on 3/20/16.
//  Copyright © 2016 Kristopher Campbell. All rights reserved.
//

import Foundation

struct Vec3 {
    var x = 0.0
    var y = 0.0
    var z = 0.0
    
    var intr: Int {
        get {
            return Int(255.99*x)
        }
    }
    
    var intg: Int {
        get {
            return Int(255.99*y)
        }
    }
    
    var intb: Int {
        get {
            return Int(255.99*z)
        }
    }
    
    var squared_length: Double {
        get {
            return x*x + y*y + z*z
        }
    }
    
    var length: Double {
        get {
            return sqrt(squared_length)
        }
    }
    
    init() {
        self.x = 0
        self.y = 0
        self.z = 0
    }
    
    init(_ x: Double, _ y: Double, _ z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
}

func dot(v1: Vec3, _ v2: Vec3) -> Double {
    return v1.x * v2.x + v1.y * v2.y + v1.z * v2.z
}

func cross(v1: Vec3, v2: Vec3) -> Vec3 {
    return Vec3( v1.y*v2.z - v1.z*v2.y,
                -v1.x*v2.z - v1.z*v2.x,
                 v1.x*v2.y - v1.y*v2.x)
}

func unit_vector(v: Vec3) -> Vec3 {
    return v / v.length
}

func * (t: Double, v: Vec3) -> Vec3 {
    return Vec3(t*v.x, t*v.y, t*v.z)
}

func * (v: Vec3, t: Double) -> Vec3 {
    return Vec3(t*v.x, t*v.y, t*v.z)
}

func * (v1: Vec3, v2: Vec3) -> Vec3 {
    return Vec3(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z)
}
func + (v1: Vec3, v2: Vec3) -> Vec3 {
    return Vec3(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z)
}

func - (v1: Vec3, v2: Vec3) -> Vec3 {
    return Vec3(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)
}

prefix func - (v: Vec3) -> Vec3{
    return Vec3(-v.x, -v.y, -v.z)
}

func / (v: Vec3, t: Double) -> Vec3 {
    return Vec3(v.x/t, v.y/t, v.z/t)
}

func += (inout v1: Vec3, v2: Vec3) {
    v1.x += v2.x
    v1.y += v2.y
    v1.z += v2.z
}

func /= (inout v: Vec3, t: Double) {
    v.x /= t
    v.y /= t
    v.z /= t
}