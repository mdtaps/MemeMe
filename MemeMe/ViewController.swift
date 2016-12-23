//
//  ViewController.swift
//  Meme Me 1.0
//
//  Created by Worship Computer on 9/12/16.
//  Copyright © 2016 Mark Tapia. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate  {
    
    //MARK: Properties
    
    //Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet var memeView: UIView!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    
    var meme = Meme()
    
    var topDidBeginEditing = false
    var bottomDidBeginEditing = false
    
    var clearColor = UIColor(colorLiteralRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    
    var currentKeyboardHeight = CGFloat(0.0)
    
    var imageScale: CGFloat = 1
    
    let optionsAlertView = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup text fields
        textFieldTop = addTextFieldAttributes(textFieldTop)
        textFieldBottom = addTextFieldAttributes(textFieldBottom)
        
        textFieldTop.text = meme.textTop
        textFieldBottom.text = meme.textBottom
        imagePickerView.image = meme.image

        
        //Setup gesture recognizers
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectImagePicker(gesture:)))
        tap.numberOfTapsRequired = 1
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(resetImage(gesture:)))
        doubleTap.numberOfTapsRequired = 2
        
        tap.require(toFail: doubleTap)
        
        imagePickerView.addGestureRecognizer(tap)
        imagePickerView.addGestureRecognizer(doubleTap)
        
        //Setup Alert View
        let saveOption = UIAlertAction(title: "Save", style: .default) { action in
            self.saveMeme()
        }
        
        optionsAlertView.addAction(saveOption)
        
        let clearOption = UIAlertAction(title: "Clear", style: .destructive) { action in
            self.resetToDefault()
        }
        
        optionsAlertView.addAction(clearOption)
        
        let cancelOption = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        optionsAlertView.addAction(cancelOption)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        libraryButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        subscribeToKeyboardNotifications()
        
        let shareItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(cancelMeme))
        
        navigationItem.leftBarButtonItem = shareItem
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelMeme))
        
        navigationItem.rightBarButtonItem = cancelItem
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeToKeyboardNotifications()
    }
    
    //MARK: Set up text field attributes
    func addTextFieldAttributes(_ textField: UITextField) -> UITextField {
        //Define text field font and color
        let textFieldAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : Float(-1.0)] as [String : Any]
        
        //Set top text field attributes
        textField.backgroundColor = self.clearColor
        textField.defaultTextAttributes = textFieldAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.delegate = self
        
        return textField
    }
    
    //MARK: Show Alert
    @IBAction func showOptionAlert() {
        
        present(optionsAlertView, animated: true, completion: nil)
    }

    //MARK: Image Picking Process
    @IBAction func pickImage(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        if sender.title == "Library" {
            pickerController.sourceType = .photoLibrary
        } else {
            pickerController.sourceType = .camera
        }
        
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        } else {
            print("Failed")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func resetToDefault() {
        textFieldTop.text = "TOP"
        textFieldBottom.text = "BOTTOM"
        
        resetImage()
        imagePickerView.image = nil
    }
    
    //MARK: UITextFieldControllerDelegate Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            if topDidBeginEditing == false {
                textField.text = ""
            }
        } else if textField.tag == 2 {
            if bottomDidBeginEditing == false {
                textField.text = ""
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //If any edits are made, mark editted as true
        if textField.tag == 1 {
            topDidBeginEditing = true
        } else if textField.tag == 2 {
            bottomDidBeginEditing = true
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //if no edits have been made upon exiting text field,
        //replace the blank with default text
        if textField.tag == 1 {
            if topDidBeginEditing {
                return
            } else {
                textField.text = "TOP"
            }
        } else if textField.tag == 2 {
            if bottomDidBeginEditing {
                return
            } else {
                textField.text = "BOTTOM"
            }
        }
    }
    
    //MARK: Functions to add and remove keyboard observers
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    //MARK: Keyboard functions
    func keyboardWillShow(notification: NSNotification) {
        guard textFieldBottom.isFirstResponder else {
            return
        }
        
        moveViewBasedOnKeyboardHeight(notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = CGFloat(0.0)
        currentKeyboardHeight = 0.0
    }
    
    func moveViewBasedOnKeyboardHeight(notification: NSNotification) {
        let userInfo = notification.userInfo
        if let keyboardSize = userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let deltaHeight = keyboardSize.cgRectValue.height - self.currentKeyboardHeight
            self.view.frame.origin.y -= deltaHeight
            currentKeyboardHeight = keyboardSize.cgRectValue.height
        }
    }
    
    //MARK: Gesture functions
    @IBAction func scaleImage(gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            imagePickerView.transform = CGAffineTransform(scaleX: gesture.scale * imageScale, y: gesture.scale * imageScale)
        case .ended:
            imageScale *= gesture.scale
        default:
            break
        }
    }
    
    @IBAction func panImage(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            if let imageSuperview = imagePickerView.superview {
                let translation = gesture.translation(in: imageSuperview)
                
                let newX = imagePickerView.center.x + translation.x
                let newY = imagePickerView.center.y + translation.y
                
                imagePickerView.center = CGPoint(x: newX, y: newY)
                gesture.setTranslation(CGPoint(x: 0, y: 0), in: imageSuperview)
            }
        default:
            return
        }
    }
    
    func selectImagePicker(gesture: UITapGestureRecognizer) {
        if textFieldTop.isFirstResponder {
            textFieldTop.resignFirstResponder()
        } else if textFieldBottom.isFirstResponder {
            textFieldBottom.resignFirstResponder()
        }
    }
    
    func resetImage(gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended:
            imagePickerView.center = CGPoint(x: memeView.center.x, y: memeView.center.y)
            
            imagePickerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            imageScale = 1
            
        default:
            return
        }
    }
    
    func resetImage() {
        imagePickerView.center = CGPoint(x: memeView.center.x, y: memeView.center.y)
            
        imagePickerView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        imageScale = 1
    }

    
    //MARK: Sharing and Saving Meme
    @IBAction func shareMeme() {
        if let memedImage = generateMemedImage() {
            let memedImageArray = [memedImage]
            let activityView = UIActivityViewController(
                activityItems: memedImageArray, applicationActivities: nil)
            activityView.completionWithItemsHandler = {
                action, completed, items, error in
                if completed {
                    self.saveMeme()
                }
            }
            
            self.present(activityView, animated: true, completion: nil)
        }
    }
    
    func saveMeme() {
        if let memedImage = generateMemedImage() {
            meme = Meme(textTop: textFieldTop.text!,
                        textBottom: textFieldBottom.text!,
                        image: imagePickerView.image,
                        memedImage: memedImage)
        }
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }

    func generateMemedImage() -> UIImage? {
        let toolBarHeight = toolBar.bounds.height
        var topNavBarHeight: CGFloat = 0.0
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        if let navBar = navigationController?.navigationBar {
            topNavBarHeight = navBar.bounds.height
        }
        
        let size = CGSize(width: view.bounds.width, height: view.bounds.height - toolBarHeight - topNavBarHeight - statusBarHeight)
        
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        
        view.drawHierarchy(in: CGRect(
            x: 0,
            y: 0 - topNavBarHeight - statusBarHeight,
            width: view.bounds.size.width,
            height: view.bounds.size.height), afterScreenUpdates: true)
        
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    //Cancel Meme
    @IBAction func cancelMeme() {
        dismiss(animated: true, completion: nil)
    }
}
