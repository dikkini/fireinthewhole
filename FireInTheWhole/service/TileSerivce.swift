//
//  TileSerivce.swift
//  FireInTheWhole
//
//  Created by dikkini on 15/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//

import SpriteKit
import GameplayKit

class TileService {
    init() {
        
    }
    
    func placeTile2D(view: SKSpriteNode, tile:Tile, direction:Direction, position:CGPoint) {
        let tileSprite = SKSpriteNode(imageNamed: textureImage(tile:tile, direction:direction, action:Action.Idle))
        tileSprite.position = position
        tileSprite.anchorPoint = CGPoint(x:0, y:0)
        view.addChild(tileSprite)
    }
    
    func placeAllTiles2D(view: SKSpriteNode, tiles: [[(Int, Int)]], tileSize: (width: Int, height: Int)) {
        for i in 0..<tiles.count {
            let row = tiles[i];
            for j in 0..<row.count {
                let tile = Tile(rawValue: row[j].0)!
                let direction = Direction(rawValue: row[j].1)!
                
                let point = CGPoint(x: (j*tileSize.width), y: -(i*tileSize.height))
                
                if (tile == Tile.Droid) {
                    placeTile2D(view:view, tile:Tile.Ground, direction:direction, position:point)
                }
                
                placeTile2D(view:view, tile:tile, direction:direction, position:point)
            }
        }
    }
    
    func placeTileIso(view:SKSpriteNode, tile:Tile, direction:Direction, position:CGPoint) {
        let tileSprite = SKSpriteNode(imageNamed: "iso_3d_"+textureImage(tile:tile, direction:direction, action:Action.Idle))
        tileSprite.position = position
        tileSprite.anchorPoint = CGPoint(x:0, y:0)
        view.addChild(tileSprite)
    }
    
    func placeAllTilesIso(view: SKSpriteNode, tiles: [[(Int, Int)]], tileSize: (width: Int, height: Int)) {
        for i in 0..<tiles.count {
            let row = tiles[i];
            for j in 0..<row.count {
                let tile = Tile(rawValue: row[j].0)!
                let direction = Direction(rawValue: row[j].1)!
                let point = point2DToIso(p:CGPoint(x: (j*tileSize.width), y: -(i*tileSize.height)))
                
                if (tile == Tile.Droid) {
                    placeTileIso(view:view, tile:Tile.Ground, direction:direction, position:point)
                }
                
                placeTileIso(view:view, tile:tile, direction:direction, position:point)
                
            }
        }
    }
}
