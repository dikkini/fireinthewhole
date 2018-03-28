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
    
    var view2D: SKSpriteNode
    var view25D: SKSpriteNode
    
    var groundLayer2D: SKNode
    var characterLayer2D: SKNode
    var objectLayer2D: SKNode
    var highlightPathLayer2D: SKNode
    var groundLayer25D: SKNode
    var characterLayer25D: SKNode
    var objectLayer25D: SKNode
    var highlightPathLayer25D: SKNode
    
    var mapRows: Int
    var mapCols: Int
    var tileSize: (width: Int, height: Int)
    
    init(tileSize: (width: Int, height: Int), mapRows: Int, mapCols: Int) {
        self.tileSize = tileSize
        self.mapRows = mapRows
        self.mapCols = mapCols
        
        
        self.view2D = SKSpriteNode()
        self.view25D = SKSpriteNode()
        self.groundLayer2D = SKNode()
        self.characterLayer2D = SKNode()
        self.objectLayer2D = SKNode()
        self.highlightPathLayer2D = SKNode()
        self.groundLayer25D = SKNode()
        self.characterLayer25D = SKNode()
        self.objectLayer25D = SKNode()
        self.highlightPathLayer25D = SKNode()
        
        // setup layers
        self.highlightPathLayer2D.zPosition = 999
        self.highlightPathLayer25D.zPosition = 999
    
        self.generateMap()
    }
    
    private func generateMap() {
        var tiles: [[Int]] = []
        for i in 0..<self.mapCols {
            var tileRow: [Int] = []
            for j in 0..<self.mapRows {
                let groundName = NSUUID().uuidString
                var ground = Ground.init(type: TileType.Ground, action: TileAction.Idle, imagePrefix: nil)
                ground.name = groundName
                ground.position = CGPoint(x: (j * self.tileSize.width), y: -(i *   tileSize.height))
                ground.anchorPoint = CGPoint(x: 0, y: 0)
                self.groundLayer2D.addChild(ground)
                
                ground = Ground.init(type: TileType.Ground, action: TileAction.Idle, imagePrefix: "iso_")
                ground.name = groundName
                ground.position = point2DTo25D(p: CGPoint(x: (j * self.tileSize.width), y: -(i * self.tileSize.height)))
                ground.anchorPoint = CGPoint(x: 0, y: 0)
                self.groundLayer25D.addChild(ground)
                
                tileRow.append(ground.type.rawValue)
                
                if (i == 2 && j == 1) || (i == 4 && j == 3) {
                    let charName = NSUUID().uuidString
                    let char2D = Character.init(type: TileType.Character, action: TileAction.Idle, direction: TileDirection.N, imagePrefix: nil, canMove: true)
                    char2D.name = charName
                    char2D.position = CGPoint(x: (j * self.tileSize.width), y: -(i * self.tileSize.height))
                    char2D.anchorPoint = CGPoint(x: 0, y: 0)
                    self.characterLayer2D.addChild(char2D)
                    
                    let char25D = Character.init(type: TileType.Character, action: TileAction.Idle, direction: TileDirection.E, imagePrefix: "iso_3d_", canMove: true)
                    char25D.name = charName
                    char25D.position = point2DTo25D(p: CGPoint(x: (j * self.tileSize.width), y: -(i * self.tileSize.height)))
                    char25D.anchorPoint = CGPoint(x: 0, y: 0)
                    self.characterLayer25D.addChild(char25D)
                }
            }
            tiles.append(tileRow)
        }
    }
    
    func setup(scene: SKScene) -> SKScene {
        // background
        let background = SKSpriteNode(imageNamed: "background.png")
        background.position = CGPoint(x: 0, y: 0)
        background.size.width = scene.size.width
        background.size.height = scene.size.height
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -999
        scene.addChild(background)
        
        let deviceScale = scene.size.width / 667
        
        self.groundLayer2D.zPosition = 1
        self.highlightPathLayer2D.zPosition = 2
        self.objectLayer2D.zPosition = 3
        self.characterLayer2D.zPosition = 4
        
        self.groundLayer25D.zPosition = 1
        self.highlightPathLayer25D.zPosition = 2
        self.objectLayer25D.zPosition = 3
        self.characterLayer25D.zPosition = 4
        
        self.view2D.position = CGPoint(x: -scene.size.width * 0.48, y: scene.size.height * 0.43)
        let view2DScale = CGFloat(0.4)
        self.view2D.xScale = deviceScale * view2DScale
        self.view2D.yScale = deviceScale * view2DScale
        
        self.view2D.addChild(self.groundLayer2D)
        self.view2D.addChild(self.objectLayer2D)
        self.view2D.addChild(self.characterLayer2D)
        self.view2D.addChild(self.highlightPathLayer2D)
        scene.addChild(self.view2D)
        
        self.view25D.position = CGPoint(x: scene.size.width * -0.05, y: scene.size.height * 0.33)
        self.view25D.xScale = deviceScale
        self.view25D.yScale = deviceScale
        
        self.view25D.addChild(self.groundLayer25D)
        self.view25D.addChild(self.objectLayer25D)
        self.view25D.addChild(self.characterLayer25D)
        self.view25D.addChild(self.highlightPathLayer25D)
        scene.addChild(self.view25D)
        
        return scene
    }
    
    func findCharacter2DTileByName(name: String) -> Tile {
        return self.characterLayer2D.childNode(withName: name) as! Tile
    }
    
    func getTouchedTile(touch: UITouch) -> Tile? {
        var touchedTile: Tile? = nil
        
        // try get character layer
        for var character25D in self.characterLayer25D.children {
            if character25D.contains(touch.location(in: self.characterLayer25D)) {
                touchedTile = (character25D as? Character)!
                print("Character touched: " + touchedTile!.debugDescription)
                return touchedTile
            }
        }
        // try get ground layer
        for var ground25D in self.groundLayer25D.children {
            if ground25D.contains(touch.location(in: self.groundLayer25D)) {
                touchedTile = (ground25D as? Ground)!
                print("Ground touched: " + touchedTile!.debugDescription)
                print("2D position of touched ground: " + point25DTo2D(p: touchedTile!.position).debugDescription)
                print("TileIndex of touched ground: " + point2DToPointTileIndex(point: point25DTo2D(p: touchedTile!.position), tileSize: GameLogic.tileSize).debugDescription)
                return touchedTile
            }
        }
        
        return touchedTile
    }

    func calculateTileLocation(tile25DName: String) -> TileLocation {
        let tile2D = self.groundLayer2D.childNode(withName: tile25DName)
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
    
    func move(tile25D: Character, tile2D: Character, location: TileLocation) {
        var moves = tile2D.getPossibleMoveTileIndexList(tileSize: GameLogic.tileSize, mapCols: GameLogic.mapCols, mapRows: GameLogic.mapRows)
        
        var canMove = false
        for move in moves {
            let move2DPoint = pointTileIndexToPoint2D(point: move, tileSize: GameLogic.tileSize)
            if move2DPoint == location.point2D {
                canMove = true
            }
        }
        
        if !canMove {
            print("Character can't move to point")
            print("2D point: " + location.point2D.debugDescription)
            print("25D point: " + location.point25D.debugDescription)
            print("Tile Index: " + point2DToPointTileIndex(point: location.point2D, tileSize: GameLogic.tileSize).debugDescription)
            return
        }
        
        // вычисляем положение тайла относительно движения (куда смотрит)
        if tile25D.direction != nil {
            let deltaY = location.point2D.y - tile2D.position.y
            let deltaX = location.point2D.x - tile2D.position.x
            let degrees = atan2(deltaX, deltaY) * (180.0 / CGFloat(Double.pi))
            let moveDirection = self.compassDirection(degrees: degrees)
            tile25D.changeDirection(direction: moveDirection)
            tile2D.changeDirection(direction: moveDirection)
        }
        
        let action25D = SKAction.move(to: location.point25D, duration: 0.2)
        tile25D.run(action25D)
        let action2D = SKAction.move(to: location.point2D, duration: 0.2)
        tile2D.run(action2D) {
            moves = tile2D.getPossibleMoveTileIndexList(tileSize: GameLogic.tileSize, mapCols: GameLogic.mapCols, mapRows: GameLogic.mapRows)
            self.highlightCharacterAllowMoves(moveTileIndexList: moves)
        }
    }
    
    func highlightCharacterAllowMoves(moveTileIndexList: [CGPoint]) {
        // clean highlights
        self.highlightPathLayer25D.removeAllChildren()
        self.highlightPathLayer2D.removeAllChildren()
        
        for var moveTI in moveTileIndexList {
            let move2DPoint = pointTileIndexToPoint2D(point: moveTI, tileSize: GameLogic.tileSize)
            var isChar = false
            for char in self.characterLayer2D.children {
                if char.position == move2DPoint {
                    isChar = true
                }
            }
            if !isChar {
                print("Visualize path: " + move2DPoint.debugDescription)
                visualizePath(move2DPoint: move2DPoint)
            }
        }
    }
    
    func visualizePath(move2DPoint: CGPoint, test: Bool? = false) {
        // 2D
        var highlightTile = Ground.init(type: TileType.Ground, action: TileAction.Idle, imagePrefix: nil)
        highlightTile.position = move2DPoint
        highlightTile.anchorPoint = CGPoint(x: 0, y: 0)
        
        if test! {
            highlightTile.color = SKColor(red: 0, green: 0, blue: 1.0, alpha: 0.25)
        } else {
            highlightTile.color = SKColor(red: 1.0, green: 0, blue: 0, alpha: 0.25)
        }
        highlightTile.colorBlendFactor = 1.0
        
        self.highlightPathLayer2D.addChild(highlightTile)
        
        // 25D
        highlightTile = Ground.init(type: TileType.Ground, action: TileAction.Idle, imagePrefix: "iso_")
        highlightTile.position = point2DTo25D(p: move2DPoint)
        highlightTile.anchorPoint = CGPoint(x: 0, y: 0)
        
        if test! {
            highlightTile.color = SKColor(red: 0, green: 0, blue: 1.0, alpha: 0.25)
        } else {
            highlightTile.color = SKColor(red: 1.0, green: 0, blue: 0, alpha: 0.25)
        }
        highlightTile.colorBlendFactor = 1.0
        
        self.highlightPathLayer25D.addChild(highlightTile)
    }
    
    // сортировка по глубине, чтобы персонажи не оказались "в текстуре"
    func sortDepth() {
        let childrenSortedForDepth = self.characterLayer25D.children.sorted() {
            
            let p0 = point25DTo2D(p: $0.position)
            let p1 = point25DTo2D(p: $1.position)
            
            if ((p0.x + (-p0.y)) > (p1.x + (-p1.y))) {
                return false
            } else {
                return true
            }
            
        }
        for i in 0..<childrenSortedForDepth.count {
            let node = (childrenSortedForDepth[i])
            node.zPosition = CGFloat(i)
            
        }
    }
}
