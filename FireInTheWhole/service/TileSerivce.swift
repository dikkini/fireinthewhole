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

    func moveTile(tile: Tile, pointTo: CGPoint, speed: Int, clean: Bool? = false) {
        let deltaY = pointTo.y - tile.sprite2D.position.y
        let deltaX = pointTo.x - tile.sprite2D.position.x

        var degrees = atan2(deltaX, deltaY) * (180.0 / CGFloat(Double.pi))
        let nTileDirection = self.degreesToDirection(degrees: degrees)

        tile.changeDirection(direction: nTileDirection)
        tile.update()

        let p1 = pointTo
        let p2 = tile.sprite2D.position
        let xDist = (p2.x - p1.x)
        let yDist = (p2.y - p1.y)
        let distance = sqrt((xDist * xDist) + (yDist * yDist))

        let time = TimeInterval(distance / CGFloat(speed))

        if clean == true {
            tile.sprite2D.removeAllActions()
        }

        let action = SKAction.move(to: pointTo, duration: time)
        tile.sprite2D.run(action)
    }

    private func degreesToDirection(degrees: CGFloat) -> TileDirection {
        var n_degrees = degrees
        if (degrees < 0) {
            n_degrees += 360
        }
        let directionRange = 45.0

        n_degrees += CGFloat(directionRange / 2)

        var direction = Int(floor(Double(degrees) / directionRange))

        if (direction > 8 || direction < 0) {
            direction = 0
        }

        return TileDirection(rawValue: direction)!
    }

    private func placeTile2D(view: SKSpriteNode, tile: Tile, position: CGPoint) {
        let tileSprite = SKSpriteNode(imageNamed: tile.properties.image())
        tileSprite.position = position
        tileSprite.anchorPoint = CGPoint(x: 0, y: 0)

        tile.sprite2D = tileSprite
        view.addChild(tileSprite)
    }

    func placeAllTiles2D(view: SKSpriteNode, tiles: [[Tile]], tileSize: (width: Int, height: Int)) {
        for i in 0..<tiles.count {
            let row = tiles[i]

            for j in 0..<row.count {
                let tile = row[j]
                let point = CGPoint(x: (j * tileSize.width), y: -(i * tileSize.height))

                if tile is Character {
                    let charTile = tile as! Character
                    placeTile2D(view: view, tile: charTile.getGroundTile(), position: point)
                }

                placeTile2D(view: view, tile: tile, position: point)
            }
        }
    }

    private func placeTileIso(view: SKSpriteNode, tile: Tile, position: CGPoint) {
        let tileSprite = SKSpriteNode(imageNamed: "iso_3d_" + tile.properties.image())
        tileSprite.position = position
        tileSprite.anchorPoint = CGPoint(x: 0, y: 0)

        tile.spriteIso = tileSprite
        view.addChild(tileSprite)
    }

    func placeAllTilesIso(view: SKSpriteNode, tiles: [[Tile]], tileSize: (width: Int, height: Int)) {
        for i in 0..<tiles.count {
            let row = tiles[i]

            for j in 0..<row.count {
                let tile = row[j]
                let point = point2DToIso(p: CGPoint(x: (j * tileSize.width), y: -(i * tileSize.height)))

                if tile is Character {
                    let charTile = tile as! Character
                    placeTileIso(view: view, tile: charTile.getGroundTile(), position: point)
                }

                placeTileIso(view: view, tile: tile, position: point)
            }
        }
    }
}
