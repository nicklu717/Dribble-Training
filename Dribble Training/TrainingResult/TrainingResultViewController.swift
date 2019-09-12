//
//  TrainingResultViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/8.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit
import Photos

class TrainingResultViewController: UIViewController {
    
    var trainingResults: [TrainingResult] = []
    
    @IBOutlet var trainingResultView: TrainingResultView! {
        didSet {
            trainingResultView.delegate = self
        }
    }
}

extension TrainingResultViewController: TrainingResultViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return trainingResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrainingResultTableViewCell",
                                                    for: indexPath) as? TrainingResultTableViewCell
        else {
            print("Invalid Training Result Table View Cell")
            return TrainingResultTableViewCell()
        }
        
        let result = trainingResults[indexPath.row]
        
        cell.dateLabel.text = "\(result.date)"
        cell.modeLabel.text = result.mode
        cell.pointsLabel.text = "\(result.points) pts"
            
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [result.videoLocalID], options: nil)

        PHImageManager.default().requestPlayerItem(
            forVideo: fetchResult.object(at: 0),
            options: nil) { (playerItem, _) in
                
                guard
                    let playerItem = playerItem
                else {
                    print("Player Item Not Exist")
                    return
                }

                let avPlayer = AVPlayer(playerItem: playerItem)
                
                cell.avPlayerLayer.player = avPlayer
                
                let endTime = playerItem.asset.duration
                
                avPlayer.addBoundaryTimeObserver(
                    forTimes: [NSValue(time: endTime)],
                    queue: DispatchQueue.main,
                    using: {
                        
                        cell.avPlayerLayer.player?.seek(to: .zero)
                        
                        cell.playVideoButton.isHidden = false
                })
        }
        
        return cell
    }
}
