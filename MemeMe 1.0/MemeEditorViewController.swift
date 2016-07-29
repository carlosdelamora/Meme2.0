//
//  MemeEditorViewController.swift
//  MemeMe 1.0
//
//  Created by Carlos De la mora on 7/22/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var countTopEdits = 0
    var countBottomEdits = 0
    var meme: MemeModel?

    //all the outles here
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UIToolbar!
    
    //construct the dictionary for the text Attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -5
    ]
    
    //tag the textfields to distingush them 
    
    
    
    
    func setTextField(textField: UITextField){
         topTextField.tag = 0
         bottomTextField.tag = 1
         //set delegate
         textField.delegate = self
         //set the text attributes
         textField.backgroundColor = UIColor.clearColor()
         textField.defaultTextAttributes = memeTextAttributes
         textField.textAlignment = NSTextAlignment.Center
         switch textField.tag{
             case 0:
                 textField.text = "TOP"
             default:
                 textField.text = "BOTTOM"
        }
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setTextField(topTextField)
        setTextField(bottomTextField)
        
        //disable the share Button
        shareButton.enabled = false
    }
    
    //get the hight of the keybord neded to move
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    //selector for the notification to show
    func keyboardWillShow(notification: NSNotification) {
        if view.frame.origin.y == 0 && bottomTextField.isFirstResponder(){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //selector for the notification to Hide
    func keyboardWillHide() {
        if view.frame.origin.y != 0 {
        view.frame.origin.y = 0
        }
    }
    
    
    //We need to add an observer to get a notification to move the view when the keybord shows/hides
    func subscribeToKeyboardNotifications() {
        //notification shows
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow), name: UIKeyboardWillShowNotification, object: nil)
        //notification hide
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    // Unsubscribe form the notifications when the keyboard shows
    func unsubscribeFromKeyboardNotifications() {
        //remove notification show
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        //remove notification hide 
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //check if we have a camara
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        subscribeToKeyboardNotifications()
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    
    func pickAnImageFromSource(source: UIImagePickerControllerSourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        switch source{
            case .Camera:
                pickerController.sourceType = UIImagePickerControllerSourceType.Camera
            default:
                pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    
    
    //present the picker controller to choose a picture form library
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        pickAnImageFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    //Present the controller with the camara to take a picture
    @IBAction func pickAnImageFromCamera (sender: AnyObject) {
        pickAnImageFromSource(UIImagePickerControllerSourceType.Camera)
    }
    
    
    //set the image form the library to display this fun is called form the delegate UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController,  didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            imagePicked.image = image
            shareButton.enabled = true}
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    //the dismiss of the view controller when the Cancel button is pressed. The function is part of conforming with protocol UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //clear the text when beging typing.
    func textFieldDidBeginEditing(textField: UITextField){

        
        //We only allowed the text to clear once
        //We clear top field once
        if topTextField.isFirstResponder() && countTopEdits == 0{
            textField.text = ""
            countTopEdits += 1
        }
        //We cleat bottom field once
        if bottomTextField.isFirstResponder() && countBottomEdits == 0{
            textField.text = ""
            countBottomEdits += 1
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //generate the memed image 
    func generateMemedImage() -> UIImage
    {
        //Hide toolBar
        navBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        toolBar.hidden = false
        navBar.hidden = false
        return memedImage
    }
    
    
    func save(){
        
          meme = MemeModel(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePicked.image!, memedImage: generateMemedImage())
        print("memed saved")
    }
    
    //Hide UInavegation Bar so the battery and carrier is not displayed //DO NOT UNDERSTAND WHY I DO HAVE TO OVERRIDE THIS FUNCTION
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    @IBAction func sendingThePicture(sender: AnyObject) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        //I WANT TO KNOW IF THIS WAS THE PORPER WAY TO USE THE COMPLETION
        controller.completionWithItemsHandler = { (_,completed: Bool,_,_)->Void in if completed{self.save()} else{ print("The image was not saved")} }
        //controller.completionWithItemsHandler(
        self.presentViewController(controller, animated: true, completion: nil)
        
    }
    
    
}


struct MemeModel {
    
    let topText: String
    let bottomText: String
    let originalImage: UIImage
    let memedImage: UIImage
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.originalImage = originalImage
        self.memedImage = memedImage
    }
    
}

