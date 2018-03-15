//
//  Utils.swift
//  FireInTheWhole
//
//  Created by dikkini on 15/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//

import GameplayKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x * scalar.x, y: point.y * scalar.y)
}

func / (point: CGPoint, scalar: CGPoint) -> CGPoint {
    return CGPoint(x: point.x / scalar.x, y: point.y / scalar.y)
}

func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
    return CGFloat(hypotf(Float(p1.x) - Float(p2.x), Float(p1.y) - Float(p2.y)))
}

func round(point: CGPoint) -> CGPoint {
    return CGPoint(x: round(point.x), y: round(point.y))
}

func floor(point: CGPoint) -> CGPoint {
    return CGPoint(x: floor(point.x), y: floor(point.y))
}

func ceil(point: CGPoint) -> CGPoint {
    return CGPoint(x: ceil(point.x), y: ceil(point.y))
}

func point2DToIso(p: CGPoint) -> CGPoint {

    //invert y pre conversion
    var point = p * CGPoint(x: 1, y: -1)

    //convert using algorithm
    point = CGPoint(x: (point.x - point.y), y: ((point.x + point.y) / 2))

    //invert y post conversion
    point = point * CGPoint(x: 1, y: -1)

    return point

}
func pointIsoTo2D(p: CGPoint) -> CGPoint {

    //invert y pre conversion
    var point = p * CGPoint(x: 1, y: -1)

    //convert using algorithm
    point = CGPoint(x: ((2 * point.y + point.x) / 2), y: ((2 * point.y - point.x) / 2))

    //invert y post conversion
    point = point * CGPoint(x: 1, y: -1)

    return point

}
