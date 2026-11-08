// value_types.swift — value vs reference in Swift
struct Point { var x: Double; var y: Double }   // value type (copied)
class Box { var x: Double = 0 }                 // reference type (shared, ARC)

var p1 = Point(x: 1, y: 2)
var p2 = p1
p2.x = 99
print(p1.x)   // 1 (copied)

let b1 = Box()
let b2 = b1
b2.x = 99
print(b1.x)   // 99 (shared)