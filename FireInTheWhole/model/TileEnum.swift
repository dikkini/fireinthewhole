//
//  TileEnum.swift
//  FireInTheWhole
//
//  Created by dikkini on 15/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//

import Foundation

enum TileType: Int {

    case Ground, Wall, Character

    var name: String {
        switch self {
        case .Ground: return "ground"
        case .Wall: return "wall"
        case .Character: return "droid"
        }
    }
}

enum TileAction: Int {
    case Idle, Move

    var name: String {
        switch self {
        case .Idle: return "idle"
        case .Move: return "move"
        }
    }
}


enum TileDirection: Int {

    case N, NE, E, SE, S, SW, W, NW

    var name: String {
        switch self {
        case .N: return "n"
        case .NE: return "ne"
        case .E: return "e"
        case .SE: return "se"
        case .S: return "s"
        case .SW: return "sw"
        case .W: return "w"
        case .NW: return "nw"
        }
    }
}
