//
//  AppCoordinator.swift
//  Rick & Morty
//
//  Created by Francisco Obarrio on 15/09/2023.
//

import Foundation
import UIKit

class AppCoordinator: NSObject {
    var childCoordinators: [AppCoordinator] = []
    var navigationController: BaseNavigationViewController?
    
    
    func start() {
        let viewModel = CharacterListViewModel()
        let vc = CharacterListViewController(viewModel: viewModel, coordinator: self)
        
        navigationController = BaseNavigationViewController(rootViewController: vc)
        navigationController?.showAsRoot()        
    }
    
    
    func didSelect(character: Character) {
        let viewModel = CharacterDetailViewModel(character: character)
        let detailVC = CharacterDetailViewController(viewModel: viewModel, coordinator: self)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

