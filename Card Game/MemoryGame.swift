//
//  MemoryGame.swift
//  Card Game
//
//  Created by Sylvan Ash on 17/04/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

class MemoryGame {
    var cards: [Card] = []
    var cardsShown: [Card] = []
    var isPlaying: Bool = false

    func shuffle(_ cards: [Card]) -> [Card] {
        return cards.shuffled()
    }

    func newGame(with cards: [Card]) -> [Card] {
        isPlaying = true
        self.cards = cards.shuffled()
        return self.cards
    }

    func restartGame() {
        isPlaying = false
        cards = []
        cardsShown = []
    }

    func card(at index: Int) -> Card? {
        return cards[safe: index]
    }

    func unmatchedCardShown() -> Bool {
        return cardsShown.count % 2 != 0
    }
}
