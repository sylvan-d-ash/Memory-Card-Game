//
//  CardCell.swift
//  Card Game
//
//  Created by Sylvan Ash on 19/04/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    private let frontImageView = UIImageView()
    private let backImageView = UIImageView()
    var isShown = false
    var card: Card!

    override func prepareForReuse() {
        super.prepareForReuse()
        frontImageView.image = nil
        frontImageView.isHidden = false
        backImageView.isHidden = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with card: Card) {
        self.card = card
        frontImageView.image = card.artwork
    }

    func toggleCardVisibility(show: Bool, animated: Bool) {
        frontImageView.isHidden = false
        backImageView.isHidden = false
        self.isShown = show

        if animated {
            if show {
                toggleVisibilityWithAnimation(toShow: frontImageView, toHide: backImageView)
            } else {
                toggleVisibilityWithAnimation(toShow: backImageView, toHide: frontImageView)
            }
        } else {
            if show {
                toggleVisibilityNoAnimation(toShow: frontImageView, toHide: backImageView)
            } else {
                toggleVisibilityNoAnimation(toShow: backImageView, toHide: frontImageView)
            }
        }
    }
}

private extension CardCell {
    func setupSubviews() {
        backImageView.image = UIImage(named: "card")
        frontImageView.isHidden = true

        [frontImageView, backImageView].forEach { imageView in
            contentView.addSubview(imageView)
            imageView.layer.cornerRadius = 5
            imageView.layer.masksToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])
        }
    }

    func toggleVisibilityNoAnimation(toShow: UIImageView, toHide: UIImageView) {
        bringSubviewToFront(toShow)
        toHide.isHidden = true
    }

    func toggleVisibilityWithAnimation(toShow: UIImageView, toHide: UIImageView) {
        UIView.transition(from: toHide,
                          to: toShow,
                          duration: 0.5,
                          options: [.transitionFlipFromRight, .showHideTransitionViews],
                          completion: nil
        )
    }
}
