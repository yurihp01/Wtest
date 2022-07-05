//
//  ViewCoordinator.swift
//  Wtest
//
//  Created by Yuri on 02/07/2022.
//

import UIKit

class ViewCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    init (navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = ViewController.instantiate(storyboardName: .main)
        viewController.coordinator = self
        viewController.viewModel = ViewModel()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    
}
