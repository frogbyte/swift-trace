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

// struct Camera {
//  var lookFrom, lookAt, vup: double3
//  var vfov, aspect: Double
    

//  func getRay(u s: Double, v t: Double) -> Ray {
//      let theta               = vfov * M_PI/180
//      let half_height         = tan(theta/2)
//      let half_width          = aspect * half_height

//      var lower_left_corner   = double3(-half_width, -half_height, -1)
//      var horizontal          = double3(2 * half_width, 0, 0)
//      var vertical            = double3(0, 2 * half_height, 0)

//      let w                   = normalize(lookFrom - lookAt)
//      let u                   = normalize(cross(vup, w))
//      let v                   = cross(w, u)


//      lower_left_corner       = lookFrom - (half_width*u) - (-half_height*v) - w
//      horizontal              = (2 * half_width) * u
//      vertical                = (2 * half_height) * v

//      let ray_direction       = lower_left_corner + s*horizontal + t*vertical - lookFrom

//      if (s > 0.9995) && (t > 0.9995) {
//          fputs("theta: \(theta)\n", __stderrp)
//          fputs("half_height: \(half_height)\n", __stderrp)
//          fputs("half_width: \(half_width)\n", __stderrp)
//          fputs("s: \(s)\nt: \(t)\n", __stderrp)
//          fputs("  w: \(w)\n  u: \(u)\n  v: \(v)\n", __stderrp)
//          fputs("  llc: \(lower_left_corner)\n", __stderrp)
//          fputs("  horizontal: \(horizontal)\n", __stderrp)
//          fputs("  vertical: \(vertical)\n", __stderrp)
//          fputs("  ray_direction: \(ray_direction)\n", __stderrp)
//      }

//      return Ray(lookFrom, ray_direction)
// //       return Ray(lookFrom, lower_left_corner + s*horizontal + t*vertical - lookFrom)
//  }
// }

struct CameraStatic {
    var lower_left_corner   = double3(-2, -1, -1)
    var horizontal          = double3(4, 0, 0)
    var vertical            = double3(0, 2, 0)
    var origin              = double3(0, 0, 0)
    
    func getRay(u u: Double, v: Double) -> Ray {
        return Ray(origin, lower_left_corner + u*horizontal + v*vertical - origin)
    }   
}