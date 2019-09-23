//
//  PostWallViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/21.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class PostWallViewController: UIViewController {
    
    @IBOutlet var postWallView: PostWallView!
    
    private var trainingResultPage: TrainingResultViewController!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTrainingResultPage()
    }
    
    func setupTrainingResultPage() {
        
        let storyboard = UIStoryboard.trainingResult
        
        guard
            let trainingResultViewController = storyboard.instantiateInitialViewController()
                as? TrainingResultViewController
            else {
                print("Training Result View Controller Not Exist")
                return
        }
        
        trainingResultPage = trainingResultViewController
        
        trainingResultPage.loadViewIfNeeded()
        
        FirestoreManager.shared.fetchTrainingResult { result in
            
            switch result {
                
            case .success(let trainingResults):
                
                self.trainingResultPage.trainingResults = trainingResults
                
            case .failure(let error):
                
                print(error)
            }
        }
        
        showTrainingResultPage()
    }
    
    func showTrainingResultPage() {
        
        postWallView.trainingResultPageView.addSubview(trainingResultPage.view)
        
        trainingResultPage.view.frame = postWallView.trainingResultPageView.bounds
        
        addChild(trainingResultPage)
        
        trainingResultPage.didMove(toParent: self)
    }
}
