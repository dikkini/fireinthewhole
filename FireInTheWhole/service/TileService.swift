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

    var view25D: SKSpriteNode

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


        self.view25D = SKSpriteNode()

        self.groundLayer25D = SKNode()
        self.characterLayer25D = SKNode()
        self.objectLayer25D = SKNode()
        self.highlightPathLayer25D = SKNode()

        // setup layers
        self.highlightPathLayer25D.zPosition = 999

        self.generateMap()
    }

    private func generateMap() {
        var tiles: [[Int]] = []
        for i in 0..<self.mapCols {
            var tileRow: [Int] = []
            for j in 0..<self.mapRows {
                let groundName = NSUUID().uuidString

                var position2D = CGPoint(x: (j * self.tileSize.width), y: -(i * tileSize.height))
                var ground = Ground.init(type: TileType.Ground, action: TileAction.Idle, position2D: position2D, imagePrefix: "iso_")
                ground.name = groundName
                ground.position = point2DTo25D(p: CGPoint(x: (j * self.tileSize.width), y: -(i * self.tileSize.height)))
                ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)

                tileRow.append(ground.type.rawValue)

                self.groundLayer25D.addChild(ground)

                if (i == 2 && j == 1) || (i == 4 && j == 3) {
                    let charName = NSUUID().uuidString

                    let char25D = Character.init(type: TileType.Character, action: TileAction.Idle, position2D: position2D, direction: TileDirection.E, imagePrefix: "iso_3d_", canMove: true)
                    char25D.name = charName
                    char25D.position = point2DTo25D(p: CGPoint(x: (j * self.tileSize.width), y: -(i * self.tileSize.height)))
                    char25D.anchorPoint = CGPoint(x: 0.5, y: 0.5)
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

        self.groundLayer25D.zPosition = 1
        self.highlightPathLayer25D.zPosition = 2
        self.objectLayer25D.zPosition = 3
        self.characterLayer25D.zPosition = 4

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

    func getTouchedTile(touch: UITouch) -> Tile? {
        var touchedTile: Tile? = nil

        // try get character layer
        for character25D in self.characterLayer25D.children {
            if character25D.contains(touch.location(in: self.characterLayer25D)) {
                touchedTile = (character25D as? Character)!
                print("Character touched: " + touchedTile!.debugDescription)
                print("touch: " + touch.location(in: self.characterLayer25D).debugDescription)
                return touchedTile
            }
        }
        // try get ground layer
        for ground25D in self.groundLayer25D.children {
            if (containsCustom(node: ground25D, p: touch.location(in: self.groundLayer25D))) {
                touchedTile = (ground25D as? Ground)!
                print("Ground touched: " + touchedTile!.debugDescription)
                print("2D position of touched ground: " + touchedTile!.position2D.debugDescription)
                print("TileIndex of touched ground: " + point2DToPointTileIndex(point: touchedTile!.position2D, tileSize: GameLogic.tileSize).debugDescription)
                print("touch: " + touch.location(in: self.characterLayer25D).debugDescription)
                return touchedTile
            }
        }

        return touchedTile
    }

    func compassDirection(degrees: CGFloat) -> TileDirection {
        var n_degrees = degrees
        if n_degrees < 0 { n_degrees += 360 }

        let directions = [TileDirection.N, TileDirection.NE, TileDirection.E, TileDirection.SE, TileDirection.S, TileDirection.SW, TileDirection.W, TileDirection.NW]
        let index = Int((n_degrees + 22.5) / 45.0) & 7
        let d = directions[index]
        return d
    }

    func highlightCharacterAllowMoves(moveTileIndexList: [CGPoint]) {
        // clean highlights
        self.highlightPathLayer25D.removeAllChildren()

        for var moveTI in moveTileIndexList {
            let move25DPoint = point2DTo25D(p: pointTileIndexToPoint2D(point: moveTI, tileSize: GameLogic.tileSize))
            var isChar = false
            for char in self.characterLayer25D.children {
                if char.position == move25DPoint {
                    isChar = true
                }
            }
            if !isChar {
                //print("Visualize path: " + move25DPoint.debugDescription)
                visualizePath(move25DPoint: move25DPoint)
            }
        }
    }

    func visualizePath(move25DPoint: CGPoint, test: Bool? = false) {
        // 25D
        var highlightTile = Ground.init(type: TileType.Ground, action: TileAction.Idle, position2D: point25DTo2D(p: move25DPoint), imagePrefix: "iso_")
        highlightTile.position = move25DPoint
        highlightTile.anchorPoint = CGPoint(x: 0.5, y: 0.5)

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
        let top_lines = -abs((1 / 2) * (p.x - node.position.x)) + node.position.y - p.y
        let bottom_lines = abs((1 / 2) * (p.x - node.position.x)) - 32 + node.position.y - p.y
//        print("\n!! top:", top_lines, " !!")
//        print("\n!! bot:", bottom_lines, "!!")
//        print("\n!! point:", p, "!!")
//        print("\n!! !!!!!!!!!!!!!\n")
        if (top_lines >= 0)
            && (bottom_lines <= 0) {
            return true
        }
        else {
            return false
        }
    }
}
