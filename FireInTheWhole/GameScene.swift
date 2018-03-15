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

    // TODO куда вынести размер одного тайла?
    let tileSize = (width: 32, height: 32)

    // TODO куда выносить виды?
    let view2D: SKSpriteNode
    let viewIso: SKSpriteNode
    
    // TODO слои?
    let layerIsoGround:SKNode
    let layerIsoObjects:SKNode

    // TODO базовый класс сцены с сервисами?
    let tileService: TileService = TileService()

    var sceneTiles: [[Tile]]
    

    let character: Character = Character.init(properties: TileProperties(type: TileType.Character, direction: TileDirection.E, action: TileAction.Idle), place: Ground.init(properties: TileProperties(type: TileType.Ground, action: TileAction.Idle)))

    override init(size: CGSize) {

        view2D = SKSpriteNode()
        viewIso = SKSpriteNode()
        
        layerIsoGround = SKNode()
        layerIsoObjects = SKNode()

        var wallProps = TileProperties(type: TileType.Wall, direction: TileDirection.N)
        let wallN = Wall.init(properties: wallProps)

        wallProps.direction = TileDirection.W
        let wallW = Wall.init(properties: wallProps)

        wallProps.direction = TileDirection.E
        let wallE = Wall.init(properties: wallProps)

        wallProps.direction = TileDirection.S
        let wallS = Wall.init(properties: wallProps)

        wallProps.direction = TileDirection.NW
        let wallNW = Wall.init(properties: wallProps)

        wallProps.direction = TileDirection.NE
        let wallNE = Wall.init(properties: wallProps)

        wallProps.direction = TileDirection.SW
        let wallSW = Wall.init(properties: wallProps)

        wallProps.direction = TileDirection.SE
        let wallSE = Wall.init(properties: wallProps)

        let groundProps = TileProperties(type: TileType.Ground, action: TileAction.Idle)
        let ground = Ground.init(properties: groundProps)

        sceneTiles = [[wallNW, wallN, wallN, wallN, wallN, wallNE]]
        sceneTiles.append([wallW, ground, ground, ground, ground, wallE])
        sceneTiles.append([wallW, ground, ground, ground, ground, wallE])
        sceneTiles.append([wallW, ground, character, ground, ground, wallE])
        sceneTiles.append([wallW, ground, ground, ground, ground, wallE])
        sceneTiles.append([wallSW, wallS, wallS, wallS, wallS, wallSE])

        super.init(size: size)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }

    override func didMove(to view: SKView) {
        let deviceScale = self.size.width / 667

        view2D.position = CGPoint(x: -self.size.width * 0.45, y: self.size.height * 0.17)
        view2D.xScale = deviceScale
        view2D.yScale = deviceScale
        addChild(view2D)

        viewIso.position = CGPoint(x: self.size.width * 0.12, y: self.size.height * 0.12)
        viewIso.xScale = deviceScale
        viewIso.yScale = deviceScale
        addChild(viewIso)
        
        viewIso.addChild(layerIsoGround)
        viewIso.addChild(layerIsoObjects)

        tileService.placeAllTiles2D(view: view2D, tiles: sceneTiles, tileSize: tileSize)
        tileService.placeAllTilesIso(view: viewIso, tiles: sceneTiles, tileSize: tileSize)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let touchLocation = touch?.location(in: viewIso)

        var touchPos2D = pointIsoTo2D(p: touchLocation!)

        touchPos2D = touchPos2D + CGPoint(x: tileSize.width / 2, y: -tileSize.height / 2)

        let heroPos2D = touchPos2D + CGPoint(x: -tileSize.width / 2, y: -tileSize.height / 2)
        let velocity = 100

        tileService.moveTile(tile: character, pointTo: heroPos2D, speed: velocity)
    }

    override func update(_ currentTime: TimeInterval) {
        character.spriteIso.position = point2DToIso(p: character.sprite2D.position)
    }
}
