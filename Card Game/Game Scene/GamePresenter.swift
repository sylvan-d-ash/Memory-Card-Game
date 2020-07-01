//
//  GamePresenter.swift
//  Card Game
//
//  Created by Sylvan Ash on 19/04/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import Foundation

protocol GameViewProtocol: class {
    func reloadView()
    func toggleVisibility(forRowsAt indeces: [Int], show: Bool, animated: Bool)
    func displayGameOverAlert()
}

class GamePresenter {
    weak var view: GameViewProtocol!
    private let apiClient: APIClient
    private var cards: [Card] = []
    private var cardsShown: [Card] = []
    var numberOfItems: Int { return cards.count }
    var isPlaying = false

    init(_ view: GameViewProtocol, apiClient: APIClient) {
        self.view = view
        self.apiClient = apiClient
    }

    func viewDidLoad() {
        apiClient.getCardImages { [weak self] result in
            guard let self = self else { return }
            if case let .failure(error) = result {
                print(error.localizedDescription)
                return
            }
            guard case let .success(cards) = result else { return }
            self.startNewGame(with: cards)
        }
    }

    func configure(_ cell: CardCell, at row: Int) {
        guard let card = cards[safe: row] else { return }
        cell.setup(with: card)
    }

    func didSelect(rowAt index: Int) {
        guard let selectedCard = cards[safe: index] else { return }

        if selectedCard.isShown {
            cardsShown.removeLast()
            selectedCard.isShown = false
            view.toggleVisibility(forRowsAt: [index], show: false, animated: true)
            return
        }

        selectedCard.isShown = true
        view.toggleVisibility(forRowsAt: [index], show: true, animated: true)

        if isShowingUnmatchedCard() {
            let unmatchedCard = cardsShown.removeLast()
            if selectedCard == unmatchedCard {
                cardsShown.append(unmatchedCard)
                cardsShown.append(selectedCard)
            } else {
                let unmatchedCardIndex = cards.firstIndex(of: unmatchedCard)
                selectedCard.isShown = false
                unmatchedCard.isShown = false

                let delay = DispatchTime.now() + 1.0
                DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
                    self?.view.toggleVisibility(forRowsAt: [unmatchedCardIndex!, index], show: false, animated: true)
                }
            }
        } else {
            cardsShown.append(selectedCard)
        }

        guard cardsShown.count == cards.count else { return }
        endGame()
    }
}

private extension GamePresenter {
    func startNewGame(with cards: [Card]) {
        self.cards = cards.shuffled()
        isPlaying = true
        view.reloadView()
    }

    func restartGame() {
        isPlaying = false
        cards = []
        cardsShown = []
    }

    func isShowingUnmatchedCard() -> Bool {
        return cardsShown.count % 2 != 0
    }

    func endGame() {
        view.displayGameOverAlert()
    }
}
