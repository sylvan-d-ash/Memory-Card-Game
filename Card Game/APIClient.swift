//
//  APIClient.swift
//  Card Game
//
//  Created by Sylvan Ash on 19/04/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class APIClient {
    private enum URLHosts {
        static let baseURL = "https://source.unsplash.com/"
        static let random = "random/"
        static let category = "category/"
    }

    private static let defaultCardImages: [UIImage] = [
        UIImage(named: "1")!,
        UIImage(named: "2")!,
        UIImage(named: "3")!,
        UIImage(named: "4")!,
        UIImage(named: "5")!,
        UIImage(named: "6")!,
        UIImage(named: "7")!,
        UIImage(named: "8")!
    ];

    func getCardImages(completion: @escaping(Result<[Card], Error>) -> Void) {
        // TODO: fetch artwork urls from Unsplash.com

        DispatchQueue.main.async {
            var cards: [Card] = []
            for image in APIClient.defaultCardImages {
                let card = Card(artwork: image)
                cards.append(card)
                cards.append(card.copy())
            }

            completion(.success(cards))
        }
    }
}
