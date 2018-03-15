//
//  Character.swift
//  FireInTheWhole
//
//  Created by dikkini on 15/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//
import Foundation

class Character: Tile {
    var groundPlace: Ground

    init(properties: TileProperties, place: Ground) {
        self.groundPlace = place
        super.init(properties: properties)
    }

    func getGroundTile() -> Ground {
        return self.groundPlace
    }
}
