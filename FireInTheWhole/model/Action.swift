//
//  Action.swift
//  FireInTheWhole
//
//  Created by dikkini on 15/03/2018.
//  Copyright © 2018 Artur Karapetov. All rights reserved.
//

enum Action: Int {
    case Idle, Move
    
    var description:String {
        switch self {
        case .Idle:return "Idle"
        case .Move:return "Move"
        }
    }
}
