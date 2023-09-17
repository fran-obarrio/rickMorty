//
//  CharacterListViewController.swift
//  Rick & Morty
//
//  Created by Francisco Obarrio on 15/09/2023.
//

import UIKit
import SDWebImage

protocol delegateTapFavorite: AnyObject {
    func tapFavorite(rowID: Int)
}


class CharacterListViewController: UIViewController, delegateTapFavorite {
    
    var viewModel: CharacterListViewModel?
    var coordinator: AppCoordinator?
    
    private var lottieAnimation: LottieAnimationsManager = LottieAnimationsManager()
    private var currentPage = 1
    private var isFetching = false
    private var isFirstTimeLoading = true
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.alpha = 0
        return cv
    }()
    
    
    init(viewModel: CharacterListViewModel, coordinator: AppCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.coordinator = coordinator
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white 
        setupUI()
        setupLottieAnimation()
        fetchCharacters()
    }
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CustomCharacterCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        
    }
    
    private func setupLottieAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
            guard let self = self else { return }
            self.lottieAnimation = LottieAnimationsManager()
            self.lottieAnimation.setup(
                view: self.view,
                animation: .lottieMortyCrying,
                loop: true,
                isMainLoader: true,
                backgroundColor: .clear,
                contentMode: .scaleAspectFit)
            self.lottieAnimation.play()
        }
    }
    
    private func fetchCharacters() {
        isFetching = true
        
        viewModel?.fetchCharacters(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isFetching = false
                switch result {
                case .success(_):
                    self.refreshData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        currentPage += 1
    }
    
    private func refreshData() {
        self.collectionView.reloadData()
        if self.isFirstTimeLoading {
            self.removeAnimation()
        }
    }
    
    private func removeAnimation() {
        isFirstTimeLoading = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            self.lottieAnimation.stop()
            self.lottieAnimation.removeAnimationView()
            self.view.bringSubviewToFront(self.collectionView)
            self.startFadeIn()
        }
    }
    
    private func startFadeIn() {
        self.collectionView.alpha = 1
        self.hideAllCells()
        self.doAnimFadeIn()
    }
    
    private func hideAllCells() {
        let cells = self.collectionView.visibleCells
        if cells.count > 0 {
            for cell in cells {
                cell.alpha = 0
            }
        }
    }
    
    private func doAnimFadeIn() {
        var index = 0
        let cells = self.collectionView.visibleCells
        if cells.count > 0 {
            for cell in cells {
                UIView.animate(withDuration: 0.15, delay: 0.15 * Double(index), options: [], animations: {
                    cell.alpha = 1
                }, completion: nil)
                index+=1
            }
        }
        
    }
    
    func tapFavorite(rowID: Int) {
        guard let character = viewModel?.characters[rowID] else { return }
        viewModel?.toggleFavorite(character: character)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
            guard let self = self else { return }
            self.collectionView.reloadItems(at: [IndexPath(item: rowID, section: 0)])
        }
    }
    
}

extension CharacterListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.characters.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? CustomCharacterCell else {
            return UICollectionViewCell()
        }
        cell.accessibilityIdentifier = "CharacterCell_\(indexPath.item)"
        
        if let character = viewModel?.characters[indexPath.item] {
            cell.character = character
            cell.favoriteButton.isSelected = viewModel?.favoritesService.isFavorite(characterId: character.id) ?? false
        }
        cell.tag = indexPath.item
        cell.delegate = self
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10  // setting padding as desired
        let collectionViewSize = collectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/2, height: 210)  // Assuming each cell has a height of 150
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let character = viewModel?.characters[indexPath.row] {
            coordinator?.didSelect(character: character)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let characterCount = viewModel?.characters.count {
            if indexPath.item == characterCount - 1 && !isFetching {
                fetchCharacters()
            }
        }
    }
    
}
