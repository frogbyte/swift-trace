//
//  materials.swift
//  swiftTrace
//
//  Created by Kristopher Campbell on 3/26/16.
//  Copyright © 2016 Kristopher Campbell. All rights reserved.
//

import Foundation
import simd

func Clamp<T: Comparable>(value: T, minValue: T, maxValue: T) -> T {
    return min(max(value, minValue), maxValue)
}

func RandomInUnitSphere() -> double3 {
    var p : double3
    repeat {
        p = 2.0*double3(drand48(), drand48(), drand48()) - double3(1,1,1)
    } while length_squared(p) >= 1.0
    return p
}

func Reflect(v v: double3, n: double3) -> double3 {
    return v - 2 * dot(v, n) * n
}

func Refract(v v: double3, n: double3, ni_over_nt: Double) -> double3? {
    let unitV = normalize(v)
    let dt = dot(unitV, n)
    let discriminant = 1.0 - ni_over_nt * ni_over_nt * (1.0 - dt * dt)
    if discriminant > 0 {
        return ni_over_nt * (unitV - n * dt) - n * sqrt(discriminant)
    }
    return nil
}

func Schlick(cosine: Double, ior: Double, power:Double = 5) -> Double {
    var r0 = (1-ior) / (1+ior)
    r0 = r0*r0
    return r0 + (1-r0)*pow((1 - cosine), power)
}

protocol Material {
    func scatter(ray_in ray_in: Ray, rec: HitRecord) -> (scattered:Ray, attenuation: double3)
}

struct NormalColor: Material {
    func scatter(ray_in ray_in: Ray, rec: HitRecord) -> (scattered: Ray, attenuation: double3) {
        let N = normalize(rec.normal)
        let attenuation = 0.5 * double3(N.x+1, N.y+1, N.z+1)
        let target = rec.p + rec.normal + RandomInUnitSphere()
        let scattered = Ray(rec.p, target - rec.p)
        return (scattered, attenuation)
    }
}

//struct LambertianFresnel : Material {
//    let albedo: double3
//    
//    func scatter(ray_in ray_in: Ray, rec: HitRecord) -> (scattered:Ray, attenuation: double3) {
//        let reflected = Reflect(v: ray_in.direction, n: rec.normal)
//        let target = rec.p + rec.normal + RandomInUnitSphere()
//        
//        
//        var scattered = Ray(rec.p, target - rec.p)
//        let attenuation = albedo
//        return (scattered, attenuation)
//    }
//}

struct Lambertian : Material {
    let albedo: double3

    func scatter(ray_in ray_in: Ray, rec: HitRecord) -> (scattered:Ray, attenuation: double3) {
        let target = rec.p + rec.normal + RandomInUnitSphere()
        let scattered = Ray(rec.p, target - rec.p)
        let attenuation = albedo
        return (scattered, attenuation)
    }
}

struct Metal : Material {
    let albedo: double3
    let roughness: Double

    func scatter(ray_in ray_in: Ray, rec: HitRecord) -> (scattered:Ray, attenuation: double3) {
        let clampped = Clamp(roughness, minValue: 0, maxValue: 1)
        let reflected = Reflect(v: normalize(ray_in.direction), n: rec.normal)
        let scattered = Ray(rec.p, reflected + (clampped * RandomInUnitSphere()))
        let attenuation = albedo
        return (scattered, attenuation)
    }
}

struct Dielectric: Material {
    let albedo: double3
    let ior: Double
    
    func scatter(ray_in ray_in: Ray, rec: HitRecord) -> (scattered:Ray, attenuation: double3) {     
        let attenuation = albedo
        let reflected = Reflect(v: ray_in.direction, n: rec.normal)

        var scattered = Ray(rec.p, reflected)

        var normal = rec.normal
        var ni_over_nt = 1.0 / ior
        var cosine = -dot(ray_in.direction, rec.normal) / length(ray_in.direction)

        // Inside the object
        if dot(ray_in.direction, rec.normal) > 0 {
            normal = -rec.normal
            ni_over_nt = ior
            cosine = ior * dot(ray_in.direction, rec.normal) / length(ray_in.direction)
        }

        // If refraction is posible scatter using the refracted ray
        if let refracted = Refract(v: ray_in.direction, n: normal, ni_over_nt: ni_over_nt) {
            // Fake fresnel by randombly picking using Schlick
            if (Schlick(cosine, ior: ior) < drand48()) {
                scattered = Ray(rec.p, refracted)
            }
        }
        return (scattered, attenuation)
    }
}