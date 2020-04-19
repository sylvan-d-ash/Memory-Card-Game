//
//  Card.swift
//  Card Game
//
//  Created by Sylvan Ash on 17/04/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class Card {
    let id: String
    var isShown: Bool
    var artwork: UIImage

    init(artwork: UIImage) {
        self.id = UUID().uuidString
        self.isShown = false
        self.artwork = artwork
    }

    private init(id: String, isShown: Bool, artwork: UIImage) {
        self.id = id
        self.isShown = isShown
        self.artwork = artwork
    }

    func copy() -> Card {
        return Card(id: id, isShown: isShown, artwork: artwork)
    }
}

extension Card: Equatable {
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.id == rhs.id && lhs.isShown == rhs.isShown
    }
}
