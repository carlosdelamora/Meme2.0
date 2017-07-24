//
//  MemeEditorViewController.swift
//  MemeMe 2.0
//
//  Created by Carlos De la mora on 7/22/16.
//  Copyright © 2016 Carlos De la mora. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    //all the outles here
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var countTopEdits = 0
    var countBottomEdits = 0
    var meme: MemeModel?
    //construct the dictionary for the text Attributes
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -5
    ] as [String : Any]

    func setTextField(_ textField: UITextField){
        //tag the textfields to distingush them
         topTextField.tag = 0
         bottomTextField.tag = 1
         //set delegate
         textField.delegate = self
         //set the text attributes
         textField.backgroundColor = UIColor.clear
         textField.defaultTextAttributes = memeTextAttributes
         textField.textAlignment = NSTextAlignment.center
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
        shareButton.isEnabled = false
        
        //disable cancel button
        //cancelButton.enabled = false
        
    }

    //get the hight of the keybord neded to move
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    //selector for the notification to show
    func keyboardWillShow(_ notification: Notification) {
        if view.frame.origin.y == 0 && bottomTextField.isFirstResponder{
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //selector for the notification to Hide
    func keyboardWillHide() {
        if view.frame.origin.y != 0 {
        view.frame.origin.y = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //check if we have a camara
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //We need to add an observer to get a notification to move the view when the keybord shows/hides
    func subscribeToKeyboardNotifications() {
        //notification shows
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //notification hide
         NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Unsubscribe form the notifications when the keyboard shows
    func unsubscribeFromKeyboardNotifications() {
        //remove notification show
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //remove notification hide 
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func pickAnImageFromSource(_ source: UIImagePickerControllerSourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        pickerController.sourceType = source
        //switch source{
        //    case .Camera:
        //        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        //    default:
        //        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //}
        
        present(pickerController, animated: true, completion: nil)
    }
    
    //present the picker controller to choose a picture form library
    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        pickAnImageFromSource(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    //Present the controller with the camara to take a picture
    @IBAction func pickAnImageFromCamera (_ sender: AnyObject) {
        pickAnImageFromSource(UIImagePickerControllerSourceType.camera)
    }
    
    //set the image form the library to display this func is called form the delegate UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController,  didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            imagePicked.image = image
            shareButton.isEnabled = true}
        self.dismiss(animated: true, completion: nil)
    }

    //the dismiss of the view controller when the Cancel button is pressed. The function is part of conforming with protocol UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //clear the text when beging typing.
    func textFieldDidBeginEditing(_ textField: UITextField){
        //We only allowed the text to clear once
        //We clear top field once
        if topTextField.isFirstResponder && countTopEdits == 0{
            textField.text = ""
            countTopEdits += 1
        }
        //We clear bottom field once
        if bottomTextField.isFirstResponder && countBottomEdits == 0{
            textField.text = ""
            countBottomEdits += 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //generate the memed image 
    func generateMemedImage() -> UIImage
    {
        //Hide toolBar
        navBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toolBar.isHidden = false
        navBar.isHidden = false
        return memedImage
    }
    
    
    func save(){
        meme = MemeModel(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePicked.image!, memedImage: generateMemedImage())
        print("memed saved")
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        if let meme = meme{
        appDelegate.memes.append(meme)
        }
        
    }
    
    //Hide UInavegation Bar so the battery and carrier is not displayed 
    override var prefersStatusBarHidden : Bool {
        return true
    }

    @IBAction func sendingThePicture(_ sender: AnyObject) {
        let memedImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        //completion handeler
        controller.completionWithItemsHandler = {
            (_,completed: Bool,_,_)->Void
            in if completed{
                self.save()
                self.navigationController?.popToRootViewController(animated: true)
            } else{ print("The image was not saved")}
        }
        
        //controller.completionWithItemsHandler
        self.present(controller, animated: true, completion: nil)
        
    }
    
    //cancel the selection of the picture go back to the TavBarController
    @IBAction func cancelButton(_ sender: AnyObject) {
        navigationController?.popToRootViewController(animated: true)

    }
    
}




