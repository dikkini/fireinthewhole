//
//  Wall.swift
//  FireInTheWhole
//
//  Created by dikkini on 15/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//

import Foundation
import SpriteKit

class Wall: Tile {
    override init(type: TileType, action: TileAction, position2D: CGPoint, direction: TileDirection? = nil, imagePrefix: String? = nil) {
        super.init(type: type, action: action, position2D: position2D, direction: direction, imagePrefix: imagePrefix)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
