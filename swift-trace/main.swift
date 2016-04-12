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

func getColor(r r: Ray, world: Hitable, maxDepth: Int = 4, currentDepth: Int = 0) -> Vec3 {
    if let rec = world.hit(r: r, t_min: 0.001, t_max: Double.infinity) {
        let (scattered, attenuation) = rec.material.scatter(ray_in: r, rec: rec)
        if currentDepth < maxDepth {
            return attenuation * getColor(r: scattered, world: world, maxDepth: maxDepth, currentDepth: currentDepth+1)
        } else {
            return Vec3(0, 0, 0)
        }
    }
    // background
    let unit_direction = unit_vector(r.direction)
    let t = 0.5 * (unit_direction.y + 1)
    return (1 - t) * Vec3(1, 1, 1) + t * Vec3(0.5, 0.7, 1.0)
}

let res = 3
let samples = 30
let width = 200 * res
let height = 100 * res


// ppm header
print("P3\n\(width) \(height)\n255")

//var hitableCollection = [Hitable]()
var hitableCollection = World()

let redLambert = Lambertian(albedo: Vec3(1, 0, 0))
let blueLambert = Lambertian(albedo: Vec3(0, 0, 1))
let grayLambert = Lambertian(albedo: Vec3(0.25, 0.25, 0.25))
let pinkLambert = Lambertian(albedo: Vec3(0.8, 0.3, 0.3))
let grayBlueLambert = Lambertian(albedo: Vec3(0.1, 0.2, 0.5))
let yellowLambert = Lambertian(albedo: Vec3(0.8, 0.8, 0))
let mirrorMetal = Metal(albedo: Vec3(0.8, 0.8, 0.8), roughness: 0.3)
let goldMetal = Metal(albedo: Vec3(0.8, 0.6, 0.2), roughness: 0.5)
let glassDielectric = Dielectric(albedo: Vec3(1, 1, 1), iof: 1.6)
let glassAlways = DielectricAlways(albedo: Vec3(1, 1, 1), ref_index: 1.6)

// let R = cos(M_PI/4)
// hitableCollection.append(Sphere(center: Vec3(-R, 0, -1), radius: R, material: blueLambert))
// hitableCollection.append(Sphere(center: Vec3( R, 0, -1), radius: R, material: redLambert))

// glass sphere
hitableCollection.append(Sphere(center: Vec3( 0,      0, -1), radius: 0.5, material: grayBlueLambert))
hitableCollection.append(Sphere(center: Vec3( 0, -100.5, -1), radius: 100, material: yellowLambert))
hitableCollection.append(Sphere(center: Vec3( 1,      0, -1), radius: 0.5, material: goldMetal))
hitableCollection.append(Sphere(center: Vec3(-1,      0, -1), radius: 0.5, material: glassDielectric, name: "Glass Sphere"))
//hitableCollection.append(Sphere(center: Vec3(-1,      0, -1), radius: -0.45, material: glassDielectric))

//let singleSphere = Sphere(center: Vec3(0, 0, -1), radius: 0.5)

// // let lookFrom = Vec3(-2, 2, 0)

// let lookFrom = Vec3(0, 0, 0)
// let lookAt = Vec3(0, 0, -1)
// let vup = Vec3(0, 1, 0)
// let vfov = 90.0
// let aspect = Double(width/height)
// let cam = Camera(lookFrom: lookFrom,
//                  lookAt: lookAt,
//                  vup:vup,
//                  vfov: vfov,
//                  aspect: aspect)
let cam = Camera()

for py in (0..<height).reverse() {
    // var stop = false
    var color = Vec3()
    for px in 0..<width {
        // let py = 315
        // let px = 390
        for sample in 1..<samples{
            let ran_px = Double(px) + drand48()
            let ran_py = Double(py) + drand48()
            let u = ran_px / Double(width)
            let v = ran_py  / Double(height)
            let r = cam.getRay(u: u, v: v)
            let sampleColor = getColor(r: r, world: hitableCollection, maxDepth: 5)
            color += sampleColor
        }
        
        color /= Double(samples)
        
        // gamma correction 2.0
        color = Vec3(sqrt(color.x), sqrt(color.y), sqrt(color.z))
//        let intColor = double3(Int(255 * color.x), Int(255 * color.y), Int(255 * color.z))
        // pixel = Pixel()
        
        // if (rec != nil) {
        // 	fputs("r: \(r)\n", __stderrp)
        // 	fputs("color:\n  r: \(color.intr)\n  g: \(color.intg)\n  b: \(color.intb)\n    u: \(u)\n    v: \(v)\n    py: \(py)\n    px: \(px)\n", __stderrp)
        // 	fputs("    t: \(rec!.t)\n", __stderrp)
        // 	stop = true
        // 	break
        // }
         print("\(color.intr) \(color.intg) \(color.intb)")
//        print("\(intColor.x) \(intColor.y) \(intColor.z)")
    }
    // if stop { break }
}
