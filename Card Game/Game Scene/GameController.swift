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
        static let sectionInsets = UIEdgeInsets(top: 20.0, left: 0, bottom: 20.0, right: 0)
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

        // on load
        // - display play button
        // on play
        // - show loading indicator
        // - load images from unsplash
        // - hide loading indicator
        // - display collection view
        // on end
        // - show alert
        // - keep collection view visible
        // on cancel
        // - hide collection view
        // on play again
        // - hide collection view
        // - show loading indicator
        // - load images from unsplash
        // - hide loading indicator
        // - display collection view
        //
        // add ons
        // - cache images
        // - cache time taken to finish
        // - game over screen
        // -- display completion times on the screen
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
        timerLabel.isHidden = true
        timerLabel.textAlignment = .right

        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .gameGrey
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "\(CardCell.self)")
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
        collectionView.isHidden = false
        playButton.isHidden = true
        timerLabel.isHidden = false

        counter = 0
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }

    @objc
    func timerUpdate() {
        counter += 1
        timerLabel.text = getTimeDisplayText()
    }

    func getTimeDisplayText() -> String {
        let minutes = counter / 60
        let seconds = counter % 60
        let leadingZero = seconds < 10 ? "0" : ""
        return "\(minutes):\(leadingZero)\(seconds)"
    }
}

extension GameController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CardCell.self)", for: indexPath) as? CardCell else {
            return UICollectionViewCell()
        }
        presenter.configure(cell, at: indexPath.row)
        return cell
    }
}

extension GameController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = Int(view.frame.width - (Constants.offset * 5))
        let widthPerItem = availableWidth / 4
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.offset
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.offset
    }
}

extension GameController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelect(rowAt: indexPath.row)
    }
}

extension GameController: GameViewProtocol {
    func reloadView() {
        collectionView.reloadData()
    }

    func toggleVisibility(forRowsAt indeces: [Int], show: Bool, animated: Bool) {
        for index in indeces {
            guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section:0)) as? CardCell else { continue }
            cell.toggleCardVisibility(show: show, animated: animated)
        }
    }

    func displayGameOverAlert() {
        timer.invalidate()

        let controller = UIAlertController(title: "Game Over!", message: "Play again?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "No", style: .cancel) { _ in
            self.collectionView.isHidden = true
            self.playButton.isHidden = false
            self.timerLabel.isHidden = true
        }
        controller.addAction(cancelAction)

        let playAgainAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.collectionView.isHidden = true
            self.playButton.isHidden = false
            self.timerLabel.isHidden = true
        }
        controller.addAction(playAgainAction)

        present(controller, animated: true, completion: nil)
    }
}

private extension UIColor {
    class var gameGrey: UIColor {
        return UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
    }
}
