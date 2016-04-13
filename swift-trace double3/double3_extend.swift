import simd

func / (d3: double3, d: Double) -> double3 {
    return double3(d3.x/d, d3.y/d, d3.z/d)
}

func /= (inout d3: double3, d: Double) {
    d3 /= double3(d)
}