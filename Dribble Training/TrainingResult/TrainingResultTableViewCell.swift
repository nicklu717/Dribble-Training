//
//  TrainingResultTableViewCell.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/9.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import AVKit

class TrainingResultTableViewCell: UITableViewCell {
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var modeLabel: UILabel!
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var videoView: UIView!
    @IBOutlet var playVideoButton: UIButton!
    
    var isVideoAvailable = true
    
    let avPlayerLayer = AVPlayerLayer()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width * 1/2
        
        avPlayerLayer.frame = videoView.bounds
        
        videoView.layer.addSublayer(avPlayerLayer)
    }
    
    @IBAction func playVideo() {
        
        playVideoButton.isHidden = true
        
        avPlayerLayer.player?.play()
    }
    
    func setupAVPlayer(url: URL) {
        
        let playerItem = AVPlayerItem(url: url)
        
        let avPlayer = AVPlayer(playerItem: playerItem)
        
        avPlayerLayer.player = avPlayer
        
        let endTime = playerItem.asset.duration
        
        avPlayer.addBoundaryTimeObserver(
            forTimes: [NSValue(time: endTime)],
            queue: DispatchQueue.main,
            using: {
                
                self.avPlayerLayer.player?.seek(to: .zero)
                
                self.playVideoButton.isHidden = false
        })
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        if isVideoAvailable {
            
            playVideoButton.isEnabled = true
            playVideoButton.setTitle(nil, for: .normal)
            playVideoButton.setImage(UIImage.asset(.play), for: .normal)
            
        } else {
            
            playVideoButton.isEnabled = false
            playVideoButton.setTitle("Video Not Available", for: .normal)
            playVideoButton.setImage(nil, for: .normal)
        }
    }
}
