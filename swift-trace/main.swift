//
//  main.swift
//  swiftTrace
//
//  Created by Kristopher Campbell on 3/20/16.
//  Copyright © 2016 Kristopher Campbell. All rights reserved.
//

import Foundation
import Darwin
import simd


func getColor(r r: Ray, world: Hitable, maxDepth: Int = 4, currentDepth: Int = 0) -> double3 {
    if let rec = world.hit(r: r, t_min: 0.001, t_max: Double.infinity) {
        let (scattered, attenuation) = rec.material.scatter(ray_in: r, rec: rec)
        if currentDepth < maxDepth {
            return attenuation * getColor(r: scattered, world: world, maxDepth: maxDepth, currentDepth: currentDepth+1)
        } else {
            return double3(0, 0, 0)
        }
    }
    // background
    let unit_direction = normalize(r.direction)
    let t = 0.5 * (unit_direction.y + 1)
    return (1 - t) * double3(1, 1, 1) + t * double3(0.5, 0.7, 1.0)
}

let res = 4
let maxDepth = 5
let samples = Clamp(20 * res, minValue: 1, maxValue: 150)
let width = 200 * res
let height = 100 * res


// ppm header
print("P3\n\(width) \(height)\n255")

//var hitableCollection = [Hitable]()
var hitableCollection = Scene()

hitableCollection.append(Sphere(center: double3( 0, -100.5, -1),
                                radius: 100,
                                material: brownLambert,
                                name: "Ground Sphere"))
hitableCollection.append(Sphere(center: double3( 0, 0, -1),
                                radius: 0.5,
                                material: grayBlueLambert,
                                name: "Blue Sphere"))
hitableCollection.append(Sphere(center: double3( 1, 0, -1),
                                radius: 0.5,
                                material: goldMetal))
hitableCollection.append(Sphere(center: double3(-1, 0, -1),
                                radius: 0.5,
                                material: glassDielectric,
                                name: "Glass Sphere"))


let lookFrom, lookAt, vup : double3
let vfov, aspect, aperture, focus_dist : Double

//lookFrom = double3(-1.8, 0.55, 0)
//lookFrom = double3(0, 0, 0)
lookFrom = double3(3, 3, 2)
lookAt = double3(0, 0, -1)
vup = double3(0, 1, 0)
//vfov = 90.0
vfov = 20
aspect = Double(width/height)
aperture = 2.0
focus_dist = length(lookFrom - lookAt)

let cam = Camera(lookFrom: lookFrom,
                 lookAt: lookAt,
                 vup:vup,
                 vfov: vfov,
                 aspect: aspect,
                 aperture: aperture,
                 focus_dist: focus_dist)

//let cam = CameraPinhole(lookFrom: lookFrom,
//                        lookAt: lookAt,
//                        vup:vup,
//                        vfov: vfov,
//                        aspect: aspect)

//cam = Camera()

let timeStart = CFAbsoluteTimeGetCurrent()

for py in (0..<height).reverse() {
    var color = double3()
    for px in 0..<width {
        for sample in 1..<samples{
            let ran_px = Double(px) + drand48()
            let ran_py = Double(py) + drand48()
            let u = ran_px / Double(width)
            let v = ran_py  / Double(height)
            let r = cam.getRay(u: u, v: v)
            let sampleColor = getColor(r: r, world: hitableCollection, maxDepth: maxDepth)
            color += sampleColor
        }
        
        color /= Double(samples)
        // gamma correction 2.0
        color = double3(sqrt(color.x), sqrt(color.y), sqrt(color.z))
        let icolor = [Int(color.x * 255), Int(color.y * 255), Int(color.z * 255)]

        print("\(icolor[0]) \(icolor[1]) \(icolor[2])")
    }
}

let timeEnd = CFAbsoluteTimeGetCurrent()
let timeTotal = timeEnd - timeStart

fputs("Time: \(timeTotal)\n", __stderrp)

