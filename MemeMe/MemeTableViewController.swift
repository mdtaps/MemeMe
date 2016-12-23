//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Worship Computer on 12/1/16.
//  Copyright © 2016 Mark Tapia. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {

    var memes: [Meme] = []
    var button = MemeButton()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.viewController = self
        navigationItem.rightBarButtonItem = button.createMemeButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memes = appDelegate.memes
        self.tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as? MemeTableViewCell else {
            print("Failed")
            return UITableViewCell()
        }
        
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        cell.topLabel.text = meme.textTop
        cell.bottomLabel.text = meme.textBottom
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let meme = memes[indexPath.row]
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PreviewMeme") as? PreviewViewController {
            
            vc.meme = meme
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
