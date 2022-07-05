//
//  AppCoordinator.swift
//  Wtest
//
//  Created by Yuri on 02/07/2022.
//

import Foundation

import UIKit

// MARK: - Declarations and init
class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    var childCoordinators: [Coordinator] = []
    
    var parentCoordinator: Coordinator?
    
    init() {
        navigationController = UINavigationController()
    }
    
    // MARK: - Functions
    func start() {
        let childCoordinator = ViewCoordinator(navigationController: navigationController)
        childCoordinator.parentCoordinator = self
        add(childCoordinator)
        childCoordinator.start()
    }
}
