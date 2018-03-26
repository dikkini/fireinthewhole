//
//  TileService.swift
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

    func calculateTileLocationOnLayer(tileIsoName: String, layer2D: SKNode) -> TileLocation {
        let tile2D = layer2D.childNode(withName: tileIsoName)
        let tilePoint2D = tile2D!.position
        let tilePoint25D = point2DTo25D(p: tilePoint2D)
        let tileLocation = TileLocation(point2D: tilePoint2D, pointIso: tilePoint25D)
        return tileLocation
    }

    func compassDirection(degrees: CGFloat) -> TileDirection {
        var n_degrees = degrees
        if n_degrees < 0 { n_degrees += 360 }

        let directions = [TileDirection.N, TileDirection.NE, TileDirection.E, TileDirection.SE, TileDirection.S, TileDirection.SW, TileDirection.W, TileDirection.NW]
        let index = Int((n_degrees + 22.5) / 45.0) & 7
        let d = directions[index]
        return d
    }

    func createMap() -> LayersMap {
        // layers
        let mapGroundLayer: SKNode = SKNode()
        let mapCharactersLayer: SKNode = SKNode()
        let mapObjectsLayer: SKNode = SKNode()
        let mapHighlightPathLayer: SKNode = SKNode()

        let isoGroundLayer: SKNode = SKNode()
        let isoCharactersLayer: SKNode = SKNode()
        let isoObjectsLayer: SKNode = SKNode()
        let isoHighlightPathLayer: SKNode = SKNode()

        // setup layers
        mapHighlightPathLayer.zPosition = 999


        // TODO здесь алгоритм создания карты

        // Тайлы
        var tiles: [[Int]] = []
        for i in 0..<GameLogic.mapCols {
            var tileRow: [Int] = []
            for j in 0..<GameLogic.mapRows {
                let groundName = NSUUID().uuidString
                //var ground = Ground.init(type: TileType.Ground, action: TileAction.Idle)
                var ground = Ground.init(type: TileType.Ground, action: TileAction.Idle, imagePrefix: nil)
                ground.name = groundName
                ground.position = CGPoint(x: (j * GameLogic.tileSize.width), y: -(i * GameLogic.tileSize.height))
                ground.anchorPoint = CGPoint(x: 0, y: 0)
                mapGroundLayer.addChild(ground)

                ground = Ground.init(type: TileType.Ground, action: TileAction.Idle, imagePrefix: "iso_")
                ground.name = groundName
                ground.position = point2DTo25D(p: CGPoint(x: (j * GameLogic.tileSize.width), y: -(i * GameLogic.tileSize.height)))
                ground.anchorPoint = CGPoint(x: 0, y: 0)
                isoGroundLayer.addChild(ground)
                
                tileRow.append(ground.type.rawValue)

                if (i == 2 && j == 1) || (i == 4 && j == 3) {
                    let charName = NSUUID().uuidString
                    let char2d = Character.init(type: TileType.Character, action: TileAction.Idle, direction: TileDirection.N, imagePrefix: nil, canMove: true)
                    char2d.name = charName
                    char2d.position = CGPoint(x: (j * GameLogic.tileSize.width), y: -(i * GameLogic.tileSize.height))
                    char2d.anchorPoint = CGPoint(x: 0, y: 0)
                    mapCharactersLayer.addChild(char2d)
                    
                    let charIso = Character.init(type: TileType.Character, action: TileAction.Idle, direction: TileDirection.E, imagePrefix: "iso_3d_", canMove: true)
                    charIso.name = charName
                    charIso.position = point2DTo25D(p: CGPoint(x: (j * GameLogic.tileSize.width), y: -(i * GameLogic.tileSize.height)))
                    charIso.anchorPoint = CGPoint(x: 0, y: 0)
                    isoCharactersLayer.addChild(charIso)
                }
            }
            tiles.append(tileRow)
        }

        let map = LayersMap.init(groundLayer2D: mapGroundLayer, characterLayer2D: mapCharactersLayer, objectLayer2D: mapObjectsLayer, highlightPathLayer2D: mapHighlightPathLayer, groundLayer25D: isoGroundLayer, characterLayer25D: isoCharactersLayer, objectLayer25D: isoObjectsLayer, highlightPathLayer25D: isoHighlightPathLayer)
        return map
    }
}
