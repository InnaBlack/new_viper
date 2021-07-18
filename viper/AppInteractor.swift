//
//  AppInteractor.swift
//  viper
//
//  Created by  inna on 18/07/2021.
//

import Foundation
import UIKit

// MARK: - AppInteractorProtocol declaration
protocol AppInteractorProtocol: AnyObject {
    var profileNetworkService: ProfileNetworkService { get }
    func start()
    func reStart()
}

// MARK: - AppInteractor implementation

class AppInteractor: NSObject, AppInteractorProtocol {
    
    private let disposeBag = DisposeBag()
    
    private var coreWindow: UIWindow?
    private var coordinator: AppCoordinatorProtocol?
    private var textManager: BaseTextManager?
    var profileNetworkService: ProfileServiceProtocol?
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        
        // Services initialization
        setupServiceLocator()
    }
    
    // MARK: - Public methods
    
    func start() {
        
        coordinator = AppCoordinator.shared
        coordinator?.delegate = self
        let targetViewController = coordinator?.start()

        self.coreWindow = UIWindow(frame: UIScreen.main.bounds)
        self.coreWindow?.rootViewController = targetViewController
        self.coreWindow?.makeKeyAndVisible()
        
        self.textManager =  BaseTextManager()
        let profileNetworkService: ProfileNetworkService? = ServiceLocator.shared.getService()
        self.profileNetworkService = profileNetworkService
    }
    
    private func setupServiceLocator() {
      
        ServiceLocator.shared.addService(service: profileNetworkService as ProfileNetworkService)
    }
}
