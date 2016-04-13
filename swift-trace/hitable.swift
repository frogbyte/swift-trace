//
//  hitable.swift
//  swiftTrace
//
//  Created by Kristopher Campbell on 3/21/16.
//  Copyright © 2016 Kristopher Campbell. All rights reserved.
//

import Foundation
import Darwin
import simd

struct HitRecord {
	var t: Double
	var p: double3 
	var normal: double3
	var material: Material
    var primName: String?
    
    init(t: Double, p: double3, normal: double3, material: Material){
        self.t = t
        self.p = p
        self.normal = normal
        self.material = material
        self.primName = nil
    }
    
    init(t: Double, p: double3, normal: double3, material: Material, primName: String){
        self.t = t
        self.p = p
        self.normal = normal
        self.material = material
        self.primName = primName
    }
}

protocol Hitable {
	 func hit(r r: Ray, t_min: Double, t_max: Double) -> HitRecord?
}

struct Scene: Hitable {
	var list: [Hitable] = []

	mutating func append(item: Hitable) {
		list.append(item)
	}

	func hit(r r: Ray, t_min: Double, t_max: Double) -> HitRecord? {
		var record: HitRecord?

		for item in list {
			if let hit = item.hit(r: r, t_min: t_min, t_max: record?.t ?? t_max) { 
				record = hit
			}
		}
		return record
	}
}

//extension CollectionType where Generator.Element : Hitable {
//    func hit(r r: Ray, t_min: Double, t_max: Double) -> HitRecord? {
//        fputs("In Hitable Array\n", __stderrp)
//        var closest = t_max
//        var record: HitRecord?
//        
//        for hitable in self{
//            guard let temp_record = hitable.hit(r: r, t_min: t_min, t_max: closest) else { continue }
//            if temp_record.t < closest {
//                closest = temp_record.t
//                record = temp_record
//            }
//        }
//        return record
//    }
//}


/* extension Array: Hitable {
	func hit(r r: Ray, t_min: Double, t_max: Double) -> HitRecord? {
		// fputs("In Defalut Array\n", __stderrp)
		return nil
	}
}

extension Array where Element:Hitable {
	func hit(r r: Ray, t_min: Double, t_max: Double) -> HitRecord? {
		fputs("In Hitable Array\n", __stderrp)
		var closest = t_max
		var record: HitRecord?
		
		for hitable in self{
			guard let temp_record = hitable.hit(r: r, t_min: t_min, t_max: closest) else { continue }
			if temp_record.t < closest {
				closest = temp_record.t
				record = temp_record
			}
		}
		if record == nil { return nil }
		return record
	}
} */

struct Sphere : Hitable {
	var center: double3
	var radius: Double
	var material: Material
	var name: String
	
    init(center: double3, radius: Double, material: Material) {
		self.center = center
		self.radius = radius
		self.material = material
		self.name = "Un-named Sphere"
    }

    init(center: double3, radius: Double, material: Material, name: String) {
		self.center = center
		self.radius = radius
		self.material = material
		self.name = name
    }
    
	func hit(r r: Ray, t_min: Double, t_max: Double) -> HitRecord? {
		let sphereCenter = r.origin - center
		let a = dot(r.direction, r.direction)
		let b = dot(sphereCenter, r.direction)
		let c = dot(sphereCenter, sphereCenter) - radius*radius
		let discriminant = b*b - a*c
		var record: HitRecord?
		
		if discriminant > 0 {
			// fputs("Hello fom Sphere.hit\n", __stderrp)
			var t = (-b - sqrt(discriminant)) / a
			if (t < t_max) && (t > t_min) {
				let p = r.PointAtParamerter(t)
				let normal = (p - center) / radius
				record = HitRecord(t: t, p: p, normal: normal, material: material, primName: name)
			} else {
				t = (-b + sqrt(discriminant)) / a
				if (t < t_max) && (t > t_min) {
					let p = r.PointAtParamerter(t)
					let normal = (p - center) / radius
					record = HitRecord(t: t, p: p, normal: normal, material: material, primName: name)
				}
			}
		}
		return record
	}
}