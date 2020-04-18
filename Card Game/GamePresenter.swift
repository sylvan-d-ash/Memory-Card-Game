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
}

class GamePresenter {
    weak var view: GameViewProtocol!
    private let apiClient: APIClient
    private var cards: [Card] = []
    var numberOfItems: Int { return cards.count }

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
            self.cards = cards
            self.view.reloadView()
        }
    }

    func configure(_ cell: CardCell, at row: Int) {
        guard let card = cards[safe: row] else { return }
        cell.setup(with: card)
    }
}
