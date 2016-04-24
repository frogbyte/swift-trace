//
//  randomScene.swift
//  swift-trace
//
//  Created by Kristopher Campbell on 4/20/16.
//  Copyright © 2016 Kris Campbell. All rights reserved.
//

import Foundation
import simd

func RandomSpheres(numberOfSpheres numberOfSpheres: Int = 500, gridSize: Int = 11, center: double3 = double3()) -> [Hitable] {
    var spheres_list : [Hitable] = []
    let half_side = Int(sqrt(Double(numberOfSpheres)))/2
    let offset = Double(gridSize)/Double(half_side)
    
    fputs("number of spheres: \(numberOfSpheres)\n", __stderrp)
    fputs("grid size: \(gridSize)\n", __stderrp)

    fputs("half_side: \(half_side)\n", __stderrp)
    fputs("offset: \(offset)\n", __stderrp)
    
    for x in -half_side..<half_side {
        for z in -half_side..<half_side {
            let radius = Clamp(drand48(), minValue: 0.1, maxValue: 0.2)
            let choose_mat = drand48()
            let kill_center = double3(4, radius, 0)
            let sphere_center = double3((Double(x) * offset) + 0.9 * drand48(), radius, (Double(z) * offset) + 0.9 * drand48())
//            let sphere_center = double3(Double(x) + 0.9 * drand48(), radius, Double(z) + 0.9 * drand48())
            fputs("sphere_center: \(sphere_center)\n", __stderrp)

            var material : Material
            if length(sphere_center - kill_center) > 0.9 { // kill if close to big spheres
                if choose_mat < 0.8 { // diffuse
                    let color = double3(drand48()*drand48(), drand48()*drand48(), drand48()*drand48())
                    material = Lambertian(albedo: color)
                }else if choose_mat < 0.95 { // metal
                    let color = double3(0.5 * (1 + drand48()), 0.5 * (1 + drand48()), 0.5 * (1 + drand48()))
                    material = Metal(albedo: color, roughness: 0.5 * drand48())
                } else { // glass
                    material = Dielectric(albedo: double3(1), ior: 1.6)
                }
                spheres_list.append(Sphere(center: sphere_center, radius: radius, material: material))
            }
        }
    }
    fputs("number of final spheres: \(spheres_list.count)\n", __stderrp)

    return spheres_list
}