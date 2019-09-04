//
//  MoveTrackerView.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/4.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import AVFoundation
import SpriteKit

protocol MoveTrackerViewDelegate: TrainingViewDelegate,
                                SKPhysicsContactDelegate,
                                AVCaptureVideoDataOutputSampleBufferDelegate {}

class MoveTrackerView: UIView {
    
    weak var delegate: MoveTrackerViewDelegate? {
        
        didSet {
            
            cameraView.videoOutputDelegate = self.delegate
            
            trainingView.replayDelegate = self.delegate
            
            trainingView.contactDelegate = self.delegate
        }
    }
    
    @IBOutlet var cameraView: CameraView!
    
    @IBOutlet var trainingView: TraingingView!
}
