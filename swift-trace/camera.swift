//
//  camera.swift
//  swiftTrace
//
//  Created by Kristopher Campbell on 3/25/16.
//  Copyright © 2016 Kristopher Campbell. All rights reserved.
//

import Foundation

// struct Camera {
// 	var lookFrom, lookAt, vup: Vec3
// 	var vfov, aspect: Double
    

// 	func getRay(u s: Double, v t: Double) -> Ray {
// 		let theta               = vfov * M_PI/180
// 		let half_height         = tan(theta/2)
// 		let half_width          = aspect * half_height

// 		var lower_left_corner 	= Vec3(-half_width, -half_height, -1)
// 		var horizontal 			= Vec3(2 * half_width, 0, 0)
// 		var vertical 			= Vec3(0, 2 * half_height, 0)

// 		let w 					= unit_vector(lookFrom - lookAt)
// 		let u 					= unit_vector(cross(vup, w))
// 		let v 					= cross(w, u)


// 		lower_left_corner		= lookFrom - (half_width*u) - (-half_height*v) - w
// 		horizontal 				= (2 * half_width) * u
// 		vertical 				= (2 * half_height) * v

// 		let ray_direction 		= lower_left_corner + s*horizontal + t*vertical - lookFrom

// 		if (s > 0.9995) && (t > 0.9995) {
// 			fputs("theta: \(theta)\n", __stderrp)
// 			fputs("half_height: \(half_height)\n", __stderrp)
// 			fputs("half_width: \(half_width)\n", __stderrp)
// 			fputs("s: \(s)\nt: \(t)\n", __stderrp)
// 			fputs("  w: \(w)\n  u: \(u)\n  v: \(v)\n", __stderrp)
// 			fputs("  llc: \(lower_left_corner)\n", __stderrp)
// 			fputs("  horizontal: \(horizontal)\n", __stderrp)
// 			fputs("  vertical: \(vertical)\n", __stderrp)
// 			fputs("  ray_direction: \(ray_direction)\n", __stderrp)
// 		}

// 		return Ray(lookFrom, ray_direction)
// // 		return Ray(lookFrom, lower_left_corner + s*horizontal + t*vertical - lookFrom)
// 	}
// }

struct Camera {
    var lower_left_corner 	= Vec3(-2, -1, -1)
    var horizontal 			= Vec3(4, 0, 0)
    var vertical 			= Vec3(0, 2, 0)
    var origin 				= Vec3(0, 0, 0)
	
    func getRay(u u: Double, v: Double) -> Ray {
        return Ray(origin, lower_left_corner + u*horizontal + v*vertical - origin)
    }   
}