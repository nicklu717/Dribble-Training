//
//  TrainingView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/3.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import SpriteKit

protocol TrainingViewDelegate: AnyObject {
    
    func startScreenRecording()
    
    func stopScreenRecording()
}

class TraingingView: SKView {
    
    // MARK: - Property Declaration
    
    var trainingScene: TrainingScene?
    
    weak var replayDelegate: TrainingViewDelegate? {
        didSet {
            initialize()
        }
    }
    
    // Points
    var pointsLabel: UILabel! {
        
        didSet {
            
            pointsLabel.text = "00"
            pointsLabel.textColor = UIColor(white: 0.8, alpha: 1)
            pointsLabel.font = UIFont(name: "Helvetica Neue", size: 55)
            
            pointsLabel.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
            
            pointsLabel.layer.cornerRadius = 10
            pointsLabel.clipsToBounds = true
            
            addSubview(pointsLabel)
            
            pointsLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                pointsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
                pointsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25)
            ])
        }
    }
    
    private var points: Int! {
        didSet {
            pointsLabel.text = String(format: "%02d", points)
        }
    }
    
    // Timer
    var timerLabel: UILabel! {
        
        didSet {
            
            timerLabel.text = "00:00"
            timerLabel.textColor = UIColor(white: 0.8, alpha: 1)
            timerLabel.font = UIFont(name: "Helvetica Neue", size: 55)
            
            timerLabel.backgroundColor = UIColor(white: 0.2, alpha: 0.8)
            
            timerLabel.layer.cornerRadius = 10
            timerLabel.clipsToBounds = true
            
            addSubview(timerLabel)
            
            timerLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                timerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -55),
                timerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 25)
            ])
        }
    }
    
    var timer: Timer?
    
    private var minute: Int!
    
    private var second: Int! {
        didSet {
            timerLabel.text = String(format: "%02d:%02d", minute, second)
        }
    }
    
    // Start
    var startButton: UIButton! {
        
        didSet {
            
            startButton.setTitle("START", for: .normal)
            startButton.setTitleColor(UIColor(white: 0.8, alpha: 1), for: .normal)
            startButton.titleLabel?.font = UIFont.systemFont(ofSize: 55)
            
            startButton.backgroundColor = UIColor(white: 0.2, alpha: 1)
            
            startButton.layer.cornerRadius = 10
            startButton.clipsToBounds = true
            
            startButton.addTarget(self,
                                  action: #selector(startTraining),
                                  for: .touchUpInside)
            
            addSubview(startButton)
            
            startButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                startButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                startButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
            ])
        }
    }
    
    // MARK: - Instance Method
    
    func setTimer(minute: Int = 0, second: Int = 10) {
        
        self.minute = minute
        self.second = second
        
        self.points = 0
    }
    
    // MARK: - Private Method
    
    private func initialize() {
        
        backgroundColor = .clear
        
        pointsLabel = UILabel()
        
        startButton = UIButton()
        
        timerLabel = UILabel()
        
        setTimer()
    }
    
    func setUpTrainingScene() {
        
        trainingScene = TrainingScene()
        
        guard let trainingScene = trainingScene else { return }
        
        trainingScene.scaleMode = .resizeFill
        trainingScene.backgroundColor = .clear
        
        trainingScene.ballNode.name = "ball"
        trainingScene.ballNode.position = CGPoint(x: -100, y: -100)
        trainingScene.ballNode.fillColor = .red
        trainingScene.addChild(trainingScene.ballNode)
        
        trainingScene.coinNode.name = "coin"
        trainingScene.coinNode.size = CGSize(width: 50, height: 50)
        trainingScene.addChild(trainingScene.coinNode)
        
        presentScene(trainingScene)
    }
    
    @objc private func startTraining() {
        
        startButton.isHidden = true
        
        replayDelegate?.startScreenRecording()
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(countdown),
                                     userInfo: nil,
                                     repeats: true)
        
        trainingScene?.setTargetCoin()
    }
    
    @objc private func countdown() {
        
        if second <= 0 {
            
            if minute > 0 {
                
                minute -= 1
                second = 60
                
            } else {
                
                endTraining()
                return
            }
        }
        
        second -= 1
    }
    
    private func endTraining() {
        
        print("Time's Up")
        
        timer?.invalidate()
        
        replayDelegate?.stopScreenRecording()
    }
}
