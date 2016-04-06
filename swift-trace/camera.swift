//
//  camera.swift
//  swiftTrace
//
//  Created by Kristopher Campbell on 3/25/16.
//  Copyright © 2016 Kristopher Campbell. All rights reserved.
//

import Foundation

struct Camera {
    var lower_left_corner 	= Vec3(-2, -1, -1)
    var horizontal 			= Vec3(4, 0, 0)
    var vertical 			= Vec3(0, 2, 0)
    var origin 				= Vec3(0, 0, 0)

	func getRay(u u: Double, v: Double) -> Ray {
	   	return Ray(origin, lower_left_corner + u*horizontal + v*vertical - origin)
	}   
}