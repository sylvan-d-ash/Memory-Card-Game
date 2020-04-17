//
//  Card.swift
//  Card Game
//
//  Created by Sylvan Ash on 17/04/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

struct Card {
    let id: String
    var isShown: Bool
    var artwork: UIImage

    init(artwork: UIImage) {
        self.id = UUID().uuidString
        self.isShown = false
        self.artwork = artwork
    }
}

extension Card: Equatable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id
    }
}
