//
//  camera.swift
//  swiftTrace
//
//  Created by Kristopher Campbell on 3/25/16.
//  Copyright © 2016 Kristopher Campbell. All rights reserved.
//

import Foundation
import simd

struct Camera {
    var lower_left_corner, lookFrom, lookAt, vup, horizontal, vertical, u, v, w : double3
    var vfov, aspect: Double

    init(lookFrom: double3, lookAt: double3, vup: double3, vfov: Double, aspect: Double) {
        self.lookFrom = lookFrom
        self.lookAt = lookAt
        self.vup = vup
        self.vfov = vfov
        self.aspect = aspect
        
        let theta = vfov * M_PI / 180
        let half_height = tan(theta / 2)
        let half_width = aspect * half_height

        w = normalize(lookFrom - lookAt)
        u = normalize(cross(vup, w))
        v = cross(w, u)

        lower_left_corner = lookFrom - half_width * u - half_height * v - w
        horizontal = 2 * half_width * u
        vertical = 2 * half_height * v
    }

    func getRay(u s: Double, v t: Double) -> Ray {
        let ray_direction = lower_left_corner + s * horizontal + t * vertical - lookFrom
        return Ray(origin: lookFrom, direction: ray_direction)
    }
}

struct CameraStatic {
    var lower_left_corner   = double3(-2, -1, -1)
    var horizontal          = double3(4, 0, 0)
    var vertical            = double3(0, 2, 0)
    var origin              = double3(0, 0, 0)
    
    func getRay(u u: Double, v: Double) -> Ray {
        return Ray(origin, lower_left_corner + u*horizontal + v*vertical - origin)
    }   
}