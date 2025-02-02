//
//  InstructionViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/10/3.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

class InstructionViewController: UIViewController, InstructionViewDelegate {
    
    // MARK: - Property Declaration
    
    @IBOutlet var instructionView: InstructionView! {
        
        didSet { instructionView.delegate = self }
    }
    
    var trainingMode: TrainingMode! {
        
        didSet { setupInstructionView() }
    }
    
    private var trainingPage: TrainingViewController!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTrainingPage()
    }
    
    // MARK: - Instance Method
    
    func startTraining() {
        
        trainingPage.setTrainingMode(to: trainingMode)

        present(trainingPage, animated: true, completion: nil)
    }
    
    func dismiss() {
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Method
    
    private func setupInstructionView() {
        
        instructionView.setupVideoPlayerView(withID: trainingMode.videoID)
        
        instructionView.modeLabel.text = trainingMode.rawValue
        
        instructionView.descriptionLabel.text = trainingMode.description
    }
    
    private func setupTrainingPage() {
        
        let viewController = UIStoryboard.training.instantiateInitialViewController()
        
        guard let trainingPage = viewController as? TrainingViewController else { return }
        
        trainingPage.loadViewIfNeeded()
        
        self.trainingPage = trainingPage
    }
}
