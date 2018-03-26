//
//  GameScene.swift
//  FireInTheWhole
//
//  Created by dikkini on 14/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//
import Foundation
import SpriteKit
import GameplayKit

class GameScene: SKScene {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // TODO куда выносить виды?
    let view2D: SKSpriteNode
    let view25D: SKSpriteNode

    // TODO слои?
    var groundLayer2D: SKNode
    var characterLayer2D: SKNode
    var objectLayer2D: SKNode
    var highlightPathLayer2D: SKNode
    var groundLayer25D: SKNode
    var characterLayer25D: SKNode
    var objectLayer25D: SKNode
    var highlightPathLayer25D: SKNode

    let tileService: TileService

    override init(size: CGSize) {

        view2D = SKSpriteNode()
        view25D = SKSpriteNode()

        // TODO базовый класс сцены с сервисами?
        tileService = TileService()

        let map = tileService.createMap()

        self.groundLayer2D = map.groundLayer2D
        self.characterLayer2D = map.characterLayer2D
        self.objectLayer2D = map.objectLayer2D
        self.highlightPathLayer2D = map.highlightPathLayer2D

        self.groundLayer25D = map.groundLayer25D
        self.characterLayer25D = map.characterLayer25D
        self.objectLayer25D = map.objectLayer25D
        self.highlightPathLayer25D = map.highlightPathLayer25D

        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    override func didMove(to view: SKView) {
        // background
        let background = SKSpriteNode(imageNamed: "background.png")
        background.position = CGPoint(x: 0, y: 0)
        background.size.width = self.size.width
        background.size.height = self.size.height
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.zPosition = -999
        self.addChild(background)

        let deviceScale = self.size.width / 667

        self.groundLayer2D.zPosition = 1
        self.highlightPathLayer2D.zPosition = 2
        self.objectLayer2D.zPosition = 3
        self.characterLayer2D.zPosition = 4

        self.groundLayer25D.zPosition = 1
        self.highlightPathLayer25D.zPosition = 2
        self.objectLayer25D.zPosition = 3
        self.characterLayer25D.zPosition = 4

        self.view2D.position = CGPoint(x: -self.size.width * 0.48, y: self.size.height * 0.43)
        let view2DScale = CGFloat(0.4)
        self.view2D.xScale = deviceScale * view2DScale
        self.view2D.yScale = deviceScale * view2DScale

        self.view2D.addChild(self.groundLayer2D)
        self.view2D.addChild(self.objectLayer2D)
        self.view2D.addChild(self.characterLayer2D)
        self.view2D.addChild(self.highlightPathLayer2D)
        self.addChild(self.view2D)

        self.view25D.position = CGPoint(x: self.size.width * -0.1, y: self.size.height * 0.1)
        self.view25D.xScale = deviceScale
        self.view25D.yScale = deviceScale

        self.view25D.addChild(self.groundLayer25D)
        self.view25D.addChild(self.objectLayer25D)
        self.view25D.addChild(self.characterLayer25D)
        self.view25D.addChild(self.highlightPathLayer25D)
        self.addChild(self.view25D)
    }

    var selectedCharacter25D: Character? = nil
    var selectedCharacter2D: Character? = nil
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }

        let selectedIsoTile = self.getTouchedTile(touch: touch)
        if selectedIsoTile is Character {
            self.selectedCharacter25D = selectedIsoTile as? Character
            // ищем character на 2D плоскости
            let charName = self.selectedCharacter25D!.name!
            self.selectedCharacter2D = self.characterLayer2D.childNode(withName: charName) as? Character

            let moves = self.selectedCharacter2D?.getPossibleMoveTileIndexList(tileSize: GameLogic.tileSize, mapCols: GameLogic.mapCols, mapRows: GameLogic.mapRows)

            self.highlightCharacterAllowMoves(moveTileIndexList: moves!)
        } else if selectedIsoTile is Ground && self.selectedCharacter25D !== nil { // персонаж выбран и выбрана земля для хода
            let groundTile = (selectedIsoTile as? Ground)!
        
            let tileLocation = self.tileService.calculateTileLocationOnLayer(tileIsoName: groundTile.name!, layer2D: groundLayer2D)
            self.move(tile25D: self.selectedCharacter25D!, tile2D: self.selectedCharacter2D!, location: tileLocation)
        }
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
            let moveDirection = self.tileService.compassDirection(degrees: degrees)
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

    func getTouchedLocation(layer: SKNode, touch: UITouch) -> CGPoint {
        // get touch location
        let touchLocation = touch.location(in: layer)
        var touchPos2D = point25DTo2D(p: touchLocation)
        touchPos2D = touchPos2D + CGPoint(x: GameLogic.tileSize.width / 2, y: -GameLogic.tileSize.height / 2)
        let touchPosIso = point2DToPointTileIndex(point: touchPos2D, tileSize: GameLogic.tileSize)

        return touchPosIso
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

// TOOD опции?
    let nthFrame = 6
    var nthFrameCount = 0
    override func update(_ currentTime: TimeInterval) {
        self.nthFrameCount += 1
        if (self.nthFrameCount == self.nthFrame) {
            self.nthFrameCount = 0
            self.updateOnNthFrame()
        }
    }

    func updateOnNthFrame() {
        self.sortDepth()
    }

}
