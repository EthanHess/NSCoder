//
//  ViewController.swift
//  PhotoApp
//
//  Created by Ethan Hess on 3/30/16.
//  Copyright © 2016 Ethan Hess. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //Storyboard properties
    @IBOutlet var captionTextField: UITextField!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var containerView: UIView!
    //Properties
    
    var postArray = [Post]()
    
    var chosenImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if let postData = NSUserDefaults.standardUserDefaults().objectForKey("postArrayKey") {
            
            postArray = NSKeyedUnarchiver.unarchiveObjectWithData(postData as! NSData) as! [Post]
        }
        
    }
    
    //Table view datasource methods
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : PostTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! PostTableViewCell
        
        let post = postArray[indexPath.row]
        
        cell.photoImageView.image = UIImage(data: post.imageData!)
        
        cell.descriptionLabel.text = post.caption
        
        return cell        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 200
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postArray.count
    }
    
    @IBAction func addPost(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        chosenImage = image
        addButton.setBackgroundImage(chosenImage, forState: UIControlState.Normal)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func savePost(sender: AnyObject) {
        
        let data = UIImageJPEGRepresentation(chosenImage!, 100)
        
        let post = Post(caption: captionTextField.text, imageData: data!)
        
        postArray.append(post)
        
        let archiveData = NSKeyedArchiver.archivedDataWithRootObject(postArray)
        
        NSUserDefaults.standardUserDefaults().setObject(archiveData, forKey: "postArrayKey")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        tableView.reloadData()
        
        captionTextField.text = ""
        addButton.setBackgroundImage(nil, forState: UIControlState.Normal)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            postArray.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            let archiveData = NSKeyedArchiver.archivedDataWithRootObject(postArray)
            
            NSUserDefaults.standardUserDefaults().setObject(archiveData, forKey: "postArrayKey")
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
//        UIView.animateWithDuration(5) { () -> Void in
        
            self.containerView.center = CGPointMake(self.containerView.frame.origin.x, self.containerView.frame.origin.y + 200)
            
            self.tableView.center = CGPointMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y + 200)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

