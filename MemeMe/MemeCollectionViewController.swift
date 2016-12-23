//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Worship Computer on 12/1/16.
//  Copyright © 2016 Mark Tapia. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {

    var memes: [Meme]!
    var preview: PreviewViewController?
    var button = MemeButton()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private var cellHeight: CGFloat {
        get {
            return (view.frame.size.height - (2 * space)) / 3.0
        }
    }
    
    private var cellWidth: CGFloat {
        get {
            return (view.frame.size.width - (2 * space)) / 3.0
        }
    }
    
    private let space: CGFloat = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.viewController = self
        navigationItem.rightBarButtonItem = button.createMemeButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Set up shared model of Memes
        memes = appDelegate.memes
        self.collectionView?.reloadData()
    }
    
    func setupLayout() {
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
    }

    //MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? MemeCollectionViewCell else {
            print("Failed")
            return UICollectionViewCell()
        }
        
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let meme = memes[indexPath.row]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PreviewMeme") as? PreviewViewController {
            
            vc.meme = meme
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
