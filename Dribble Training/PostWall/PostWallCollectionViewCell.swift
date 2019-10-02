//
//  PostWallCollectionViewCell.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/10/1.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import UIKit

protocol PostWallCollectionViewCellDelegate: AnyObject {
    
    func showProfile(for id: ID)
    
    func playVideo(with url: URL?) -> Bool
}

class PostWallCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: PostWallCollectionViewCellDelegate?
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var idButton: UIButton!
    @IBOutlet var pointsLabel: UILabel!
    @IBOutlet var modeLabel: UILabel!
    @IBOutlet var screenShotImageView: UIImageView!
    
    var videoURL: URL?
    
    var isVideoAvailable: Bool = true
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        
        profileImageView.image = UIImage.asset(.profile)
        
        screenShotImageView.image = nil
    }
    
    @IBAction func showMemberProfile(_ button: UIButton) {
        
        let id = button.titleLabel?.text ?? ""
        
        delegate?.showProfile(for: id)
    }
    
    @IBAction func playVideo() {
        
        guard let delegate = delegate
            else {
                print("Post Wall Collection View Cell Delegate Not Exist")
                return
        }
        
        isVideoAvailable = delegate.playVideo(with: videoURL)
    }
}
