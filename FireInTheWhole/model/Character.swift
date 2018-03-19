//
//  Character.swift
//  FireInTheWhole
//
//  Created by dikkini on 15/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//
import Foundation
import SpriteKit

class Character: Tile {
    
    init(type: TileType, direction: TileDirection, action: TileAction, imagePrefix: String? = nil, canMove: Bool? = false) {
        super.init(type: type, direction: direction, action: action, imagePrefix: imagePrefix, canMove: canMove)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
