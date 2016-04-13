import simd

let redLambert = Lambertian(albedo: double3(1, 0, 0))
let blueLambert = Lambertian(albedo: double3(0, 0, 1))
let grayLambert = Lambertian(albedo: double3(0.25, 0.25, 0.25))
let pinkLambert = Lambertian(albedo: double3(0.8, 0.3, 0.3))
let grayBlueLambert = Lambertian(albedo: double3(0.1, 0.2, 0.5))
let brownLambert = Lambertian(albedo: double3(0.8, 0.3, 0.15))
let mirrorMetal = Metal(albedo: double3(0.8, 0.8, 0.8), roughness: 0.3)
let goldMetal = Metal(albedo: double3(0.8, 0.6, 0.2), roughness: 0.5)
let glassDielectric = Dielectric(albedo: double3(1, 1, 1), iof: 1.6)
let glassAlways = DielectricAlways(albedo: double3(1, 1, 1), ref_index: 1.6)