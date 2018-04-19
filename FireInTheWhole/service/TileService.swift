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

    var mapView: SKSpriteNode

    var groundLayer: SKNode
    var characterLayer: SKNode
    var objectLayer: SKNode
    var highlightPathLayer: SKNode

    var mapRows: Int
    var mapCols: Int
    var tileSize: (width: Int, height: Int)

    var tileMap: [[Int]] = [[]]
    var traversibleTileMap: [[Int]] = [[]]

    init(tileSize: (width: Int, height: Int), mapRows: Int, mapCols: Int) {
        self.tileSize = tileSize
        self.mapRows = mapRows
        self.mapCols = mapCols


        self.mapView = SKSpriteNode()

        self.groundLayer = SKNode()
        self.characterLayer = SKNode()
        self.objectLayer = SKNode()
        self.highlightPathLayer = SKNode()

        // setup layers
        self.highlightPathLayer.zPosition = 999

        // setup tile map
        self.tileMap = self.generateMap()
        self.traversibleTileMap = self.traversableTiles()
    }

    private func generateMap() -> [[Int]] {
        var tileMap: [[Int]] = []
        for i in 0..<self.mapCols {
            var tileRow: [Int] = []
            for j in 0..<self.mapRows {
                let groundName = NSUUID().uuidString

                let position2D = CGPoint(x: (j * self.tileSize.width), y: -(i * tileSize.height))
                let ground = Ground.init(type: TileType.Ground, action: TileAction.Idle, position2D: position2D, imagePrefix: "iso_")
                ground.name = groundName
                ground.position = point2DTo25D(p: CGPoint(x: (j * self.tileSize.width), y: -(i * self.tileSize.height)))
                ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)

                self.groundLayer.addChild(ground)

                if (i == 2 && j == 1) || (i == 4 && j == 3) {
                    let charName = NSUUID().uuidString

                    let char = Character.init(type: TileType.Character, action: TileAction.Idle, position2D: position2D, direction: TileDirection.E, imagePrefix: "iso_3d_", canMove: true)
                    char.name = charName
                    char.position = point2DTo25D(p: CGPoint(x: (j * self.tileSize.width), y: -(i * self.tileSize.height)))
                    char.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                    self.characterLayer.addChild(char)

                    tileRow.append(char.type.rawValue)
                } else if i == 4 && j == 4 {
                    let charName = NSUUID().uuidString

                    let droid = Droid.init(type: TileType.Character, action: TileAction.Idle, position2D: position2D, direction: TileDirection.E, imagePrefix: "iso_3d_", canMove: true, canFire: true)
                    droid.name = charName
                    droid.position = point2DTo25D(p: CGPoint(x: (j * self.tileSize.width), y: -(i * self.tileSize.height)))
                    droid.anchorPoint = CGPoint(x: 0.5, y: 0.5)

                    self.characterLayer.addChild(droid)
                    tileRow.append(droid.type.rawValue)
                } else {
                    tileRow.append(ground.type.rawValue)
                }
            }
            tileMap.append(tileRow)
        }

        return tileMap
    }

    func updateTileMap(oldIndex: CGPoint, newIndex: CGPoint, oldType: TileType, newType: TileType) {
        print(self.tileMap)
        self.tileMap[-Int(oldIndex.y)][Int(oldIndex.x)] = oldType.rawValue
        self.tileMap[-Int(newIndex.y)][Int(newIndex.x)] = newType.rawValue
        print(self.tileMap)
    }

    func traversableTiles() -> [[Int]] {
        var tTiles = [[Int]]()

        func binarize(num: Int) -> Int {
            if (num != TileType.Ground.rawValue) {
                return Global.tilePath.nonTraversable
            } else {
                return Global.tilePath.traversable
            }
        }

        for i in 0..<self.tileMap.count {
            let tt = self.tileMap[i].map { i in
                binarize(num: i)
            }
            tTiles.append(tt)
        }

        return tTiles
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

        self.groundLayer.zPosition = 1
        self.highlightPathLayer.zPosition = 2
        self.objectLayer.zPosition = 3
        self.characterLayer.zPosition = 4

        self.mapView.position = CGPoint(x: scene.size.width * -0.05, y: scene.size.height * 0.33)
        self.mapView.xScale = deviceScale
        self.mapView.yScale = deviceScale

        self.mapView.addChild(self.groundLayer)
        self.mapView.addChild(self.objectLayer)
        self.mapView.addChild(self.characterLayer)
        self.mapView.addChild(self.highlightPathLayer)
        scene.addChild(self.mapView)

        return scene
    }

    func getTouchedTile(touch: UITouch) -> Tile? {
        var touchedTile: Tile? = nil

        // try get character layer
        for character25D in self.characterLayer.children {
            //if character25D.contains(touch.location(in: self.characterLayer25D))
            if (containsCustom(node: character25D, p: touch.location(in: self.characterLayer))) {
                touchedTile = (character25D as? Character)!
                print("Character touched: " + touchedTile!.debugDescription)
                print("touch: " + touch.location(in: self.characterLayer).debugDescription)
                return touchedTile
            }
        }
        // try get ground layer
        for ground25D in self.groundLayer.children {
            if (containsCustom(node: ground25D, p: touch.location(in: self.groundLayer))) {
                touchedTile = (ground25D as? Ground)!
                print("Ground touched: " + touchedTile!.debugDescription)
                print("touch: " + touch.location(in: self.characterLayer).debugDescription)
                return touchedTile
            }
        }

        return touchedTile
    }

    func compassDirection(degrees: CGFloat) -> TileDirection {
        var n_degrees = degrees
        if n_degrees < 0 {
            n_degrees += 360
        }

        let directions = [TileDirection.N, TileDirection.NE, TileDirection.E, TileDirection.SE, TileDirection.S, TileDirection.SW, TileDirection.W, TileDirection.NW]
        let index = Int((n_degrees + 22.5) / 45.0) & 7
        let d = directions[index]
        return d
    }

    func highlightCharacterAllowMoves(moveTileIndexList: [CGPoint]) {
        // clean highlights
        self.highlightPathLayer.removeAllChildren()

        for var moveTI in moveTileIndexList {
            let movePoint25D = point2DTo25D(p: pointTileIndexToPoint2D(point: moveTI, tileSize: self.tileSize))
            var isChar = false
            for char in self.characterLayer.children {
                if char.position == movePoint25D {
                    isChar = true
                }
            }
            if !isChar {
                //print("Visualize path: " + move25DPoint.debugDescription)
                visualizePath(movePoint25D: movePoint25D)
            }
        }
    }

    func visualizePath(movePoint25D: CGPoint, test: Bool? = false) {
        // 25D
        let highlightTile = Ground.init(type: TileType.Ground, action: TileAction.Idle, position2D: point25DTo2D(p: movePoint25D), imagePrefix: "iso_")
        highlightTile.position = movePoint25D
        highlightTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        if test! {
            highlightTile.color = SKColor(red: 0, green: 0, blue: 1.0, alpha: 0.25)
        } else {
            highlightTile.color = SKColor(red: 1.0, green: 0, blue: 0, alpha: 0.25)
        }
        highlightTile.colorBlendFactor = 1.0

        self.highlightPathLayer.addChild(highlightTile)
    }

    func highlightMovePoint(move25DPoint: CGPoint) {
        var points = [
            CGPoint(x: -self.tileSize.width, y: -self.tileSize.height / 2)
            , CGPoint(x: 0, y: 0)
            , CGPoint(x: self.tileSize.width, y: -self.tileSize.height / 2)
            , CGPoint(x: 0, y: -self.tileSize.height)
        ]
        let highlighMoveNode = SKShapeNode(points: &points, count: points.count)
        highlighMoveNode.position = move25DPoint
        highlighMoveNode.fillColor = SKColor.green
        self.highlightPathLayer.addChild(highlighMoveNode)
    }

    // сортировка по глубине, чтобы персонажи не оказались "в текстуре"
    func sortDepth() {
        let childrenSortedForDepth = self.characterLayer.children.sorted() {

            let p0 = ($0 as? Tile)!.position2D
            let p1 = ($1 as? Tile)!.position2D

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


    func findPathFrom(from: CGPoint, to: CGPoint) -> [CGPoint]? {
        let traversable = traversableTiles()

        if (Int(to.x) >= 0)
                   && (Int(to.x) < traversable.count)
                   && (Int(-to.y) >= 0)
                   && (Int(-to.y) < traversable.count) {
            let pathFinder = PathFinder(xIni: Int(from.x), yIni: Int(from.y), xFin: Int(to.x), yFin: Int(to.y), lvlData: traversable)
            let myPath = pathFinder.findPath()
            return myPath
        } else {
            return nil
        }
    }


    //         0,0 /\
    //           /    \
    // -32,-16   \    / 32,-16
    //             \/
    //         0,-32
    // y=kx+b
    // k = -1/2, b = 0
    // y = -| 1/2 x |
    // y = | 1/2 x | - 32
    //0, 5

    func containsCustom(node: SKNode, p: CGPoint) -> Bool {
        // 1/2p.x - a.x
        let modY = abs((1 / 2) * (p.x - node.position.x))
        let equalY = node.position.y - p.y

        let top_lines = -modY + equalY
        let bottom_lines = modY - CGFloat(self.tileSize.height) + equalY
        if (top_lines >= 0)
                   && (bottom_lines <= 0) {
            return true
        } else {
            return false
        }
    }
}
