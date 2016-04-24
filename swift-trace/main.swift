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

func writePixels(width: Int, height: Int, minSamples: Int, maxSamples: Int, cam: camera, scene: Scene, maxBounces: Int) -> [double3] {
    var pixels : [double3] = []
    var samples : Int = 1
    for py in (0..<height).reverse() {
        var color = double3()
        for px in 0..<width {
            for _ in 1..<maxSamples{
                samples += 1
                let ran_px = Double(px) + drand48()
                let ran_py = Double(py) + drand48()
                let u = ran_px / Double(width)
                let v = ran_py  / Double(height)
                let r = cam.getRay(u: u, v: v)
                let sampleColor = getColor(r: r, world: scene, maxDepth: maxBounces)
                color += sampleColor
            }
            
            color /= Double(samples)
            pixels.append(color)
            // gamma correction 2.0
            color = double3(sqrt(color.x), sqrt(color.y), sqrt(color.z))
            let icolor = [Int(color.x * 255), Int(color.y * 255), Int(color.z * 255)]
            
            print("\(icolor[0]) \(icolor[1]) \(icolor[2])")
        }
    }
    return pixels
}

let res = 2.5
let maxDepth = 5
let samples = Int(Clamp(8 * res, minValue: 1, maxValue: 150))
let width = Int(200 * res)
let height = Int(100 * res)

fputs("Max Bounces: \(maxDepth)\n", __stderrp)
fputs("Samples Per Pixel: \(samples)\n", __stderrp)
fputs("Image Dimentions: \(width) x \(height)\n", __stderrp)

let timeStartScene = CFAbsoluteTimeGetCurrent()


// ppm header
print("P3\n\(width) \(height)\n255")

//var hitableCollection = [Hitable]()
var hitableCollection = Scene()

hitableCollection.append(Sphere(center: double3( 0, -1000, 0),
                                radius: 1000,
                                material: grayLambert,
                                name: "Ground Sphere"))

hitableCollection.append(Sphere(center: double3( -4, 1, 0),
                                radius: 1,
                                material: grayBlueLambert,
                                name: "Blue Sphere"))

hitableCollection.append(Sphere(center: double3( 4, 1, 0),
                                radius: 1,
                                material: mirrorMetal))

hitableCollection.append(Sphere(center: double3(0, 1, 0),
                                radius: 1,
                                material: glassDielectric,
                                name: "Glass Sphere"))


hitableCollection.list.appendContentsOf(RandomSpheres(numberOfSpheres: 200, gridSize: 11))


let lookFrom, lookAt, vup : double3
let vfov, aspect, aperture, focus_dist : Double

lookFrom = double3(8.5, 1.25, 2.5)
lookAt = double3(0, 1, 0.25)
vup = double3(0, 1, 0)
vfov = 30
aspect = Double(width/height)
aperture = 0.2
focus_dist = length(lookFrom - lookAt)

let cam = Camera(lookFrom: lookFrom,
                 lookAt: lookAt,
                 vup:vup,
                 vfov: vfov,
                 aspect: aspect,
                 aperture: aperture,
                 focus_dist: focus_dist)

let timeEndScene = CFAbsoluteTimeGetCurrent()
let timeSceneBuild = timeEndScene - timeStartScene

fputs("Scene Build Time: \(timeSceneBuild)\n", __stderrp)

let timeStartTrace = CFAbsoluteTimeGetCurrent()


//let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//dispatch_apply(height, queue) { py in
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

let timeEndTrace = CFAbsoluteTimeGetCurrent()
let timeTrace = timeEndTrace - timeStartTrace
let timeTotal = timeEndTrace - timeStartScene

fputs("Trace Time: \(timeTrace)\n", __stderrp)
fputs("Total Time: \(timeTotal)\n", __stderrp)


