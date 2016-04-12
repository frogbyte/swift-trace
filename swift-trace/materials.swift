//
//  materials.swift
//  swiftTrace
//
//  Created by Kristopher Campbell on 3/26/16.
//  Copyright © 2016 Kristopher Campbell. All rights reserved.
//

import Foundation

func Clamp<T: Comparable>(value: T, minValue: T, maxValue: T) -> T {
	return min(max(value, minValue), maxValue)
}

func RandomInUnitSphere() -> Vec3 {
	func NewP() -> Vec3 {
		return 2.0*Vec3(drand48(), drand48(), drand48()) - Vec3(1,1,1)
	}
	
	var p = NewP()

	while (p.squared_length >= 1.0) {
		p = NewP()
	}

	return p
}

func Reflect(v v: Vec3, n: Vec3) -> Vec3 {
	return v - 2*dot(v,n)*n
}

func Refract(v v: Vec3, n: Vec3, ni_over_nt: Double) -> Vec3? {
	let unitV = unit_vector(v)
	let dt = dot(unitV, n)
	let discriminant = 1.0 - ni_over_nt * ni_over_nt * (1 - dt * dt)
	if (discriminant > 0 ) {
		return ni_over_nt*(v - n * dt) - n * sqrt(discriminant)
	} else {
		return nil
	}
}

func Schlick(cosine: Double, iof: Double) -> Double {
	var r0 = (1-iof) / (1+iof)
	r0 = r0*r0
	return r0 + (1-r0)*pow((1 - cosine), 5)
}

protocol Material {
	func scatter(ray_in ray_in: Ray, rec: HitRecord) -> (scattered:Ray, attenuation: Vec3)
}

struct NormalColor: Material {
	func scatter(ray_in ray_in: Ray, rec: HitRecord) -> (scattered: Ray, attenuation: Vec3) {
		let N = unit_vector(rec.normal)
		let attenuation = 0.5 * Vec3(N.x+1, N.y+1, N.z+1)
		let target = rec.p + rec.normal + RandomInUnitSphere()
		let scattered = Ray(rec.p, target - rec.p)
		return (scattered, attenuation)
	}
}

struct Lambertian : Material {
	let albedo: Vec3

	func scatter(ray_in ray_in: Ray, rec: HitRecord) -> (scattered:Ray, attenuation: Vec3) {
		let target = rec.p + rec.normal + RandomInUnitSphere()
		let scattered = Ray(rec.p, target - rec.p)
		let attenuation = albedo
		return (scattered, attenuation)
	}
}

struct Metal : Material {
	let albedo: Vec3
	let roughness: Double

	func scatter(ray_in ray_in: Ray, rec: HitRecord) -> (scattered:Ray, attenuation: Vec3) {
		let clampped = Clamp(roughness, minValue: 0, maxValue: 1)
		let reflected = Reflect(v: unit_vector(ray_in.direction), n: rec.normal)
		let scattered = Ray(rec.p, reflected + (clampped * RandomInUnitSphere()))
		let attenuation = albedo
		return (scattered, attenuation)
	}
}

struct Dielectric: Material {
	let albedo: Vec3
	let iof: Double
	
	func scatter(ray_in ray_in: Ray, rec: HitRecord) -> (scattered:Ray, attenuation: Vec3) {		
		let attenuation = albedo
		let reflected = Reflect(v: ray_in.direction, n: rec.normal)

		var scattered = Ray(rec.p, reflected)

		var normal = rec.normal
		var ni_over_nt = 1.0 / iof
		var cosine = -dot(ray_in.direction, rec.normal) / ray_in.direction.length

		// Inside the object
		if dot(ray_in.direction, rec.normal) > 0 {
			normal = -rec.normal
			ni_over_nt = iof
			cosine = iof * dot(ray_in.direction, rec.normal) / ray_in.direction.length
		}

		// If refraction is posible scatter using the refracted ray
		if let refracted = Refract(v: ray_in.direction, n: normal, ni_over_nt: ni_over_nt) {
			// Fake fresnel by randombly picking using Schlick
			if (Schlick(cosine, iof: iof) < drand48()) {
				scattered = Ray(rec.p, refracted)
			}
		}
		return (scattered, attenuation)
	}
}

struct DielectricAlways: Material {
    let albedo: Vec3
    var ref_index: Double
    
    func scatter(ray_in ray_in: Ray, rec: HitRecord) -> (scattered:Ray, attenuation: Vec3) {
        var scattered: Ray
        var ni_over_nt: Double = 1
        var outward_normal = Vec3()
        let reflected = Reflect(v: ray_in.direction, n: rec.normal)
        let attenuation = albedo
        if dot(ray_in.direction, rec.normal) > 0 {
            outward_normal = -rec.normal
            ni_over_nt = ref_index
        } else {
            outward_normal = rec.normal
            ni_over_nt = 1 / ref_index
        }
        let refracted = Refract(v: ray_in.direction, n: outward_normal, ni_over_nt: ni_over_nt)
        if refracted != nil {
            scattered = Ray(rec.p, refracted!)
            return (scattered, attenuation)
        } else {
            scattered = Ray(rec.p, reflected)
            return (scattered, attenuation)
        }
    }
}