//
//  Direction.swift
//  FireInTheWhole
//
//  Created by dikkini on 15/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//

enum Direction: Int {
    
    case N,NE,E,SE,S,SW,W,NW
    
    var description:String {
        switch self {
        case .N:return "North"
        case .NE:return "North East"
        case .E:return "East"
        case .SE:return "South East"
        case .S:return "South"
        case .SW:return "South West"
        case .W:return "West"
        case .NW:return "North West"
        }
    }
}
