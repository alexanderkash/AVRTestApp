//
//  TopGamesViewController.swift
//  ARVTestApp
//
//  Created by Alexander Kogalovsky on 21.12.22.
//

import UIKit
import SnapKit

final class TopGamesViewController: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    private let cellAspectRatio = 1.5
    private var games = [Game]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadGames()
    }
        
    private func setupViews() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationController?
            .navigationBar
            .largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?
            .navigationBar
            .titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        title = "Top Games"
        view.addSubview(collectionView)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .black
        collectionView.register(GameCell.self,
                                forCellWithReuseIdentifier: GameCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func loadGames() {
        ContentLoader.shared.loadGames { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let topGames):
                self.games = topGames
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func show(streams: [Stream]) {
        let vc = StreamsViewController(streams: streams)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension TopGamesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return games.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let game = games[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.reuseIdentifier,
                                                      for: indexPath) as! GameCell
        cell.display(game: game, aspectRatio: cellAspectRatio)
        return cell
    }
}

extension TopGamesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width / 2.1
        let height = width * cellAspectRatio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let game = games[indexPath.item]
        ContentLoader.shared.loadStreams(gameId: game.id) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let streams):
                self.show(streams: streams)
            case .failure(let error):
                print(error)
            }
        }
    }
}
