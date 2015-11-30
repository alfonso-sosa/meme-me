//
//  ViewController.swift
//  MemeMeTest
//
//  Created by Alfonso Sosa on 08/08/15.
//  Copyright (c) 2015 Alfonso Sosa. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,
                        UIImagePickerControllerDelegate,
                        UINavigationControllerDelegate,
                        UITextFieldDelegate {

    //View that shows the selected/taken picture
    @IBOutlet weak var imagePickerView: UIImageView!
    
    //View to hold the image and text
    @IBOutlet weak var editorView: UIView!
    

    //Textfields
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!

    //Buttons
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    //Toolbars
    @IBOutlet weak var topToolbar: UIToolbar!
    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    //Meme text attributes from app delegate, adds font
    var memeTextAttributes: [String: NSObject] {
        get {
            var textAttributes = (UIApplication.sharedApplication().delegate as! AppDelegate).memeTextAttributes
            textAttributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)
            return textAttributes
        }
    }
    

    //Index in array
    var memeIndex: Int!
    
    //Indicates the view needs to setup a meme
    var setupMeme: Bool!
    
    
    //Code executed after view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        //Aligns text and sets the meme font attributes
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        //Sets the initial values for the textfields
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        //The share button will be initially disabled
        shareButton.enabled = false
    }
    
    //Shows the image picker source (camera or library)
    func showImageSource(source: UIImagePickerControllerSourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        presentViewController(pickerController, animated: true, completion: nil)
    }

    //Shows photo album for selection
    @IBAction func pickAnImage(sender: AnyObject) {
        showImageSource(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    //Shows the user the camera to take a picture
    @IBAction func takeAPhoto(sender: AnyObject) {
        showImageSource(UIImagePickerControllerSourceType.Camera)
    }
    
    //Implements delegate method by showing the selected / taken picture within the designated view.
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //Check for existing image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            //Use the AspectFill content mode by default; otherwise use AspectFit
            imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
            shareButton.enabled = true
        }
        //UIImagePicker is dismissed after selection
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Dismiss the picker if user cancelled
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Invoked when the view will be shown
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Subscribe to keyboard showing / being dismissed
        subscribeToKeyboardNotifications()
        //Enable the camera if it is available.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        //init meme if index was passed in
        if let memeIndex = memeIndex {
            if setupMeme! {
                let meme = memes[memeIndex]
                topTextField!.text = meme.top
                bottomTextField!.text = meme.bottom
                imagePickerView.contentMode = UIViewContentMode.ScaleAspectFit
                imagePickerView!.image = meme.image
                shareButton.enabled = true
                //Flag is used to init IBOutlets only the first time the view is presented
                //otherwise, it would overwrite the new image selected by the user 
                //(viewWillAppear() is invoked after dismissing image selection view)
                setupMeme = false
            }
        }
    }
    
    //Invoked when the view will be removed
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //Keyboard notifications are no longer necessary
        unsubscribeFromKeyboardNotifications()
    }
    
    //Delegate method; when the user begins editing, the text is cleared
    func textFieldDidBeginEditing(textField: UITextField) {
        switch (textField) {
        case topTextField:
            if topTextField.text == "TOP" {
                topTextField.text = ""
            }
        case bottomTextField:
            if (bottomTextField.text == "BOTTOM"){
                bottomTextField.text = ""
            }
        default:
            return
        }
    }
    
    //When the user has finished editing (return pressed) the keyboard is dismissed
    //Empty textfields are restored to their original initial values
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField.text == ""){
            if (textField == topTextField){
                textField.text = "TOP"
            }
            else {
                textField.text = "BOTTOM"
            }
        }
        return true
    }
    
    //Subscribe to keyboard showing or hiding and associating the appropriate methods
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Unsubscribe from keyboard events
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:UIKeyboardWillHideNotification, object: nil)
    }
    
    //Invoked when the keyboard will appear, shifts the view up by the keyboard height
    func keyboardWillShow(notification: NSNotification) {
        if (bottomTextField.isFirstResponder()){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }   
    
    //Invoked when the keyboard is dismissed, shifts the view back down
    func keyboardWillHide(notification: NSNotification) {
        if (bottomTextField.isFirstResponder()){
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    //Returns the keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //Creates and returns Meme object
    func save(memedImage: UIImage) -> Meme {
        if let memeIndex = memeIndex {
            var meme = memes[memeIndex]
            meme.top = topTextField.text!
            meme.bottom = bottomTextField.text!
            meme.image = imagePickerView.image!
            meme.memedImage = memedImage
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes[memeIndex] = meme
            return meme
        }
        else {
            let newMeme = Meme(top: topTextField.text!,
                bottom: bottomTextField.text!,
                image: imagePickerView.image!,
                memedImage: memedImage)
                (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(newMeme)
            return newMeme
        }
    }
    
    //Generates the memed image (selected image + text)
    func generateMemedImage() -> UIImage {
        //hide bars
        topToolbar.hidden = true
        bottomToolbar.hidden = true
        
        //capture image
        UIGraphicsBeginImageContext(imagePickerView.frame.size)
        view.drawViewHierarchyInRect(imagePickerView.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //show bars
        topToolbar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImage
    }

    //Shows de ActivityView
    @IBAction func share(sender: UIBarButtonItem) {
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success {
                self.save(memedImage)
            }
        }
        presentViewController(activityVC, animated: true, completion: nil)
    }
    
    //Invoked by the cancel button, sets everything back to its initial state
    @IBAction func cancel(sender: UIBarButtonItem) {
        imagePickerView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

