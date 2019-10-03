//
//  PostWallViewController.swift
//  Dribble Training
//
//  Created by 陸瑋恩 on 2019/9/21.
//  Copyright © 2019 陸瑋恩. All rights reserved.
//

import AVKit

class PostWallViewController: UIViewController {
    
    // MARK: - Property Declaration
    
    @IBOutlet var postWallView: PostWallView! {
        didSet {
            postWallView.delegate = self
        }
    }
    
    private var trainingResults: [TrainingResult] = [] {
        didSet {
            postWallView.reloadCollectionView()
        }
    }
    
    let playerViewController = AVPlayerViewController()
    
    var profilePage: ProfileViewController!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        fetchTrainingResult()
        
        setupProfilePage()
    }
    
    // MARK: - Instance Method
    
    func fetchTrainingResult() {
        
        FirestoreManager.shared.fetchTrainingResult { result in
            
            switch result {
                
            case .success(let trainingResults):
                
                var filteredTrainingResults: [TrainingResult] = []
                
                let blockList = AuthManager.shared.currentUser.blockList
                    
                for trainingResult in trainingResults {
                        
                    if !blockList.contains(trainingResult.id) {
                        
                        filteredTrainingResults.append(trainingResult)
                    }
                }
                
                self.trainingResults = filteredTrainingResults
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
    // MARK: - Private Method
    
    private func setupProfilePage() {
        
        let profileStoryboard = UIStoryboard.profile
        
        let viewController = profileStoryboard.instantiateViewController(identifier: ProfileViewController.id)
        
        guard let profilePage = viewController as? ProfileViewController
            else {
                print("Profile Page Initializing Failure")
                return
        }
        
        self.profilePage = profilePage
    }
}

extension PostWallViewController: PostWallViewDelegate {
    
    func numberOfItemsInSection(_ section: Int) -> Int {
        
        return trainingResults.count
    }
    
    func cellForItemAt(_ indexPath: IndexPath,
                       for collectionView: UICollectionView) -> UICollectionViewCell {
        
        let resultCollectionViewCell =
            collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.id,
                                               for: indexPath)
        
        guard let cell = resultCollectionViewCell as? ResultCollectionViewCell
            else {
                print("Result Collection View Cell Casting Failure")
                return resultCollectionViewCell
        }
        
        let result = trainingResults[indexPath.row]
        
        cell.delegate = self
        
        cell.idButton.setTitle(result.id, for: .normal)
        
        cell.pointsLabel.text = String(result.points)
        
        cell.modeLabel.text = result.mode
        
        cell.screenShotImageView.setImage(withURLString: result.screenShot)
        
        cell.videoURL = URL(string: result.videoURL)
        
        StorageManager.shared.getProfilePicture(forID: result.id) { result in
            
            switch result {
                
            case .success(let url):
                
                cell.profileImageView.setImage(withURLString: url.absoluteString,
                                               placeholder: UIImage.asset(.profile))
                
            case .failure(let error):
                
                print(error)
            }
        }
        
        return cell
    }
}

extension PostWallViewController: ResultCollectionViewCellDelegate {
    
    func showProfile(for id: ID) {
        
        if id == AuthManager.shared.currentUser.id { return }
        
        FirestoreManager.shared.fetchMemberData(forID: id) { result in

            switch result {

            case .success(let member):
                
                guard let member = member
                    else {
                        print("Member Data Not Exist")
                        return
                }
                
                self.profilePage.member = member
                
                self.show(self.profilePage, sender: nil)

            case .failure(let error):

                print(error)
            }
        }
    }
    
    func playVideo(with url: URL?) -> Bool {
        
        guard let url = url
            else {
                print("Invalid Video URL")
                return false
        }
        
        playerViewController.player = AVPlayer(url: url)
        
        present(playerViewController, animated: true, completion: nil)
        
        return true
    }
}
