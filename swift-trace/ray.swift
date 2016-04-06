//
//  ray.swift
//  swiftTrace
//
//  Created by Kristopher Campbell on 3/20/16.
//  Copyright © 2016 Kristopher Campbell. All rights reserved.
//

struct Ray {
    var origin, direction : Vec3
    
    init(_ origin: Vec3, _ direction: Vec3) {
    	self.origin = origin
    	self.direction = direction
    }

    init(direction: Vec3) {
    	self.origin = Vec3()
    	self.direction = direction
    }

    func PointAtParamerter(t: Double) -> Vec3{
        return origin + t * direction
    }
}