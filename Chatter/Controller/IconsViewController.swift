//
//  IconsViewController.swift
//  Chatter
//
//  Created by Devodriq Roberts on 9/21/18.
//  Copyright © 2018 Devodriq Roberts. All rights reserved.
//

import UIKit

class IconsViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var iconSegControl: UISegmentedControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Variable
    var avatarType: IconCollectionViewCell.AvatarType = .dark
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    

    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segControlToggled(_ sender: Any) {
        if iconSegControl.selectedSegmentIndex == 1 {
            avatarType = .light
        } else {
            avatarType = .dark
        }
        collectionView.reloadData()
    }
    
    
    
}

extension IconsViewController: UICollectionViewDataSource {
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarType == .dark {
            UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
        } else {
            UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.item)")
        }
        self.dismiss(animated: true, completion: nil)
    }
}

extension IconsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCell", for: indexPath) as? IconCollectionViewCell else {return UICollectionViewCell()}
        
        cell.configureCell(index: indexPath.item, type: avatarType)
        
        
        return cell
    }
}

extension IconsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numberOfColumns: CGFloat = 3
        
        if UIScreen.main.bounds.width > 320 {
            numberOfColumns = 4
        }
        
        let spaceBtwCells: CGFloat = 10
        let padding: CGFloat = 40
        let cellDim: CGFloat = ((collectionView.bounds.width - padding) - (numberOfColumns - 1) * spaceBtwCells) / numberOfColumns
        
        return CGSize(width: cellDim, height: cellDim)
        
    }
}

















