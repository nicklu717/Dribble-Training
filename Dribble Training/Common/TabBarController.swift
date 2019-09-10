//
//  TabBarController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/10.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    private let tabs: [Tab] = [.home, .training, .profile]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for tab in tabs {
            
            guard
                let viewController = tab.controller()
            else {
                print("Initial View Controller Not Exist")
                return
            }
            
            addChild(viewController)
        }
    }
    
    private enum Tab {
        
        case home
        
        case classroom
        
        case training
        
        case profile
        
        case team
        
        func controller() -> UIViewController? {
            
            var storyboard: UIStoryboard?
            
            switch self {
                
            case .home: storyboard = .home
                
            case .classroom: storyboard = .classroom
                
            case .training: storyboard = .trainingLobby
                
            case .profile: storyboard = .profile
                
            case .team: storyboard = .team
            }
            
            let controller = storyboard?.instantiateInitialViewController()
            
            controller?.tabBarItem = tabBarItem()
            
            return storyboard?.instantiateInitialViewController()
        }
        
        private func tabBarItem() -> UITabBarItem {
            
            let tabBarItem = UITabBarItem()
            
            // TODO: Set Tab-Bar-Item's Image
            
            return tabBarItem
        }
    }
}
