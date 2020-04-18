//
//  GameController.swift
//  Card Game
//
//  Created by Sylvan Ash on 17/04/2020.
//  Copyright © 2020 Sylvan Ash. All rights reserved.
//

import UIKit

class GameController: UIViewController {
    private enum Constants {
        static let offset: CGFloat = 15
        static let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    }

    private var collectionView: UICollectionView!
    private let playButton = UIButton()
    private let timerLabel = UILabel()

    private var presenter: GamePresenter!

    init() {
        super.init(nibName: nil, bundle: nil)
        presenter = GamePresenter(self, apiClient: APIClient())
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gameGrey
        presenter.viewDidLoad()
    }
}

private extension GameController {
    func setupSubviews() {
        view.addSubview(playButton)
        playButton.setTitle("Play", for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)

        view.addSubview(timerLabel)
        timerLabel.text = "0:00"
        timerLabel.textAlignment = .right

        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .gameGrey
        collectionView.dataSource = self
        view.addSubview(collectionView)

        [playButton, timerLabel, collectionView].forEach { $0?.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            playButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            playButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),

            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            timerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            timerLabel.bottomAnchor.constraint(equalTo: playButton.bottomAnchor),

            collectionView.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 15),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
        ])
    }

    @objc
    func playButtonTapped(_ sender: Any) {
        //
    }
}

extension GameController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension GameController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = Int(view.frame.width - (Constants.offset * 2))
        let widthPerItem = availableWidth / 4
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.sectionInsets.left
    }
}

extension GameController: GameViewProtocol {
    func reloadView() {
        collectionView.reloadData()
    }
}

private extension UIColor {
    class var gameGrey: UIColor {
        return UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
    }
}
