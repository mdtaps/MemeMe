//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Worship Computer on 12/1/16.
//  Copyright © 2016 Mark Tapia. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MemeCollectionViewController: UICollectionViewController {

    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //Set up shared model of Memes
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
        
        let item = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(openMemeCreator))
        
        self.navigationItem.rightBarButtonItem = item
    }

    //MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MemeCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.image
        cell.topLabel.text = meme.textTop
        cell.topLabel.text = meme.textBottom
    
        return cell
    }
    
    func openMemeCreator() {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateMeme") as? ViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
