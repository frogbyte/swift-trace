//
//  camera.swift
//  swiftTrace
//
//  Created by Kristopher Campbell on 3/25/16.
//  Copyright © 2016 Kristopher Campbell. All rights reserved.
//

import Foundation
import simd

func RandomInUnitDisk() -> double3 {
    var p : double3
    repeat {
        p = 2.0 * double3(drand48(), drand48(), 0) - double3(1, 1, 0)
    } while dot(p, p) >= 1.0
    return p
}


protocol camera {
    func getRay(u s: Double, v t: Double) -> Ray
}

struct Camera : camera {
    var lower_left_corner, horizontal, vertical, u, v, w : double3
    var lens_radius: Double
    
    init(lookFrom: double3, lookAt: double3, vup: double3, vfov: Double, aspect: Double, aperture: Double, focus_dist: Double) {
        lens_radius = aperture / 2
        
        let theta = vfov * M_PI / 180
        let half_height = tan(theta / 2)
        let half_width = aspect * half_height
        
        w = normalize(lookFrom - lookAt)
        u = normalize(cross(vup, w))
        v = cross(w, u)
        
        // with focus_dist
        lower_left_corner = lookFrom - half_width * focus_dist * u - half_height * focus_dist * v - focus_dist * w
        horizontal = 2 * half_width * focus_dist * u
        vertical = 2 * half_height * focus_dist * v
    }
    
    func getRay(u s: Double, v t: Double) -> Ray {
        let random_lens_offset = lens_radius * RandomInUnitDisk()
        let offset = u * random_lens_offset.x + v * random_lens_offset.y
        let ray_origin = lookFrom + offset
        let ray_direction = lower_left_corner + s * horizontal + t * vertical - lookFrom - offset
        return Ray(origin: ray_origin, direction: ray_direction)
    }
}

//struct Camera {
//    var lower_left_corner, lookFrom, lookAt, vup, horizontal, vertical, u, v, w : double3
//    var vfov, aspect, lens_radius, aperture, focus_dist: Double
//    
//    init(lookFrom: double3, lookAt: double3, vup: double3, vfov: Double, aspect: Double, aperture: Double, focus_dist: Double) {
//        self.lookFrom = lookFrom
//        self.lookAt = lookAt
//        self.vup = vup
//        self.vfov = vfov
//        self.aspect = aspect
//        self.aperture = aperture
//        self.focus_dist = focus_dist
//        
//        lens_radius = aperture / 2
//        let theta = vfov * M_PI / 180
//        let half_height = tan(theta / 2)
//        let half_width = aspect * half_height
//        
//        w = normalize(lookFrom - lookAt)
//        u = normalize(cross(vup, w))
//        v = cross(w, u)
//        
//        lower_left_corner = lookFrom - half_width * focus_dist * u - half_height * focus_dist * v - focus_dist * w
//        horizontal = 2 * half_width * focus_dist * u
//        vertical = 2 * half_height * focus_dist * v
//        
//        //        lower_left_corner = lookFrom - half_width * u - half_height * v - w
//        //        horizontal = 2 * half_width * u
//        //        vertical = 2 * half_height * v
//    }
//    
//    func getRay(u s: Double, v t: Double) -> Ray {
//        let random_lens_offset = lens_radius * RandomInUnitDisk()
//        //        fputs("lens offset: \(random_lens_offset)\n", __stderrp)
//        let offset = u * random_lens_offset.x + v * random_lens_offset.y
//        //        fputs("Offset: \(offset)\n", __stderrp)
//        let ray_direction = lower_left_corner + (s * horizontal) + (t * vertical) - (lookFrom - offset)
//        return Ray(origin: lookFrom * offset, direction: ray_direction)
//    }
//}

struct CameraPinhole {
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