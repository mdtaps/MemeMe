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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldTop = addTextFieldAttributes(textFieldTop)
        textFieldBottom = addTextFieldAttributes(textFieldBottom)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectImagePicker(gesture:)))
        tap.numberOfTapsRequired = 1
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(resetImage(gesture:)))
        doubleTap.numberOfTapsRequired = 2
        
        tap.require(toFail: doubleTap)
        
        imagePickerView.addGestureRecognizer(tap)
        imagePickerView.addGestureRecognizer(doubleTap)
        
        let item = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(popNavigationController))
        navigationItem.rightBarButtonItem = item
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        libraryButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        subscribeToKeyboardNotifications()
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
    
    @IBAction func resetToDefault(_ sender: UIBarButtonItem) {
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
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
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

    func generateMemedImage() -> UIImage? {
        let toolBarHeight = toolBar.frame.height
        
        toolBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        UIGraphicsBeginImageContext(CGSize(width: self.view.frame.width,
            height: self.view.frame.height - toolBarHeight))
        self.view.drawHierarchy(in: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height - toolBarHeight), afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        toolBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        return memedImage
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
    
    func popNavigationController() {
        navigationController?.popViewController(animated: true)
    }

}
