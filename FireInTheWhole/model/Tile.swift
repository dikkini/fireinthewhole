//
//  Tile.swift
//  FireInTheWhole
//
//  Created by dikkini on 15/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//

enum Tile: Int {
    
    case Ground, Wall, Droid
    
    var description:String {
        switch self {
            case .Ground:return "Ground"
            case .Wall:return "Wall"
            case .Droid:return "Droid"
        }
    }
}
