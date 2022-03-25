//
//  NewProjectViewController.swift
//  Capstone
//
//  Created by BVU Student on 1/26/22.
//

import Photos
import PhotosUI
import UIKit

class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    /* FIXME: Change func name to saveProject */
    func saveImage(_ image: UIImage, _ imageName: String,_ annotations: Dictionary<String, Array<Dictionary<String, CGFloat>>> ) {

        let fManager = FileManager.default
        guard let url = fManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            return
        }
        
        let newFolderUrl = url
            .appendingPathComponent("\(imageName)")
        do {
            try fManager.createDirectory(
                at: newFolderUrl,
                withIntermediateDirectories: true,
                attributes: [:]
            )
        }
        catch {
            print(error)
        }
        
        let bluePrint = image.pngData()

        let path = documentDirectoryPath("\(imageName)")
        do {
            try
            bluePrint?.write(to: path!)
            // write to file
            print("Success")
        } catch let error {
            print("Error saving. \(error)")
        }
    }
    func documentDirectoryPath(_ imageName : String) -> URL? {
        let path = FileManager.default.urls(for: .documentDirectory,
                                               in: .userDomainMask).first?.appendingPathComponent("/\(imageName)/\(imageName).png")
        return path
    }
        
        /* FIXME: Writing to .txt file of annotes */
 /*       let fname : String = "\(imageName).txt"
        let fileName = getPathFor(imageName: fname)
        do {
            try annotations.writeToURL(fileName!)
        } catch {
            print("Error saving, \(error)")
        }
        
        /* FIXME: Writing to document directory of png image */
        let blueprintImage = image.pngData()
        let dictionary = annotations
        //print("Debug: \(imageName)")
        let path = getPathFor(imageName: "\(imageName).png")
        
        do {
            try
            blueprintImage?.write(to: path!)
            try! dictionary.writeToURL(path!)
            print("dictionary: \(dictionary)")
            print("Success")
        } catch let error {
            print("Error saving. \(error)")
            
        }
    }
    func getPathFor(imageName: String) -> URL? {
        guard
            let path = FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(imageName)") else {
                    print("Error getting path")
                    return nil
                }
        return path
    }*/
}

class NewProjectViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var canvasView: CanvasView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var projectSave: UIButton!
    @IBOutlet weak var projectName: UITextField!
    @IBOutlet weak var projectNameHeader: UILabel!
    @IBOutlet weak var Blue: UIButton!
    @IBOutlet weak var Green: UIButton!
    @IBOutlet weak var Red: UIButton!
    @IBOutlet weak var Yellow: UIButton!
    @IBOutlet weak var UploadImage: UIButton!
    @IBOutlet weak var OpenCamera: UIButton!
    @IBOutlet weak var UploadingImageStack: UIStackView!
    @IBOutlet weak var Canvas: CanvasView!
    
    //public var image: UIImage = UIImage()
    //var image:UIImage? = nil
    var globalImage:UIImage? = nil
    
    let manager = LocalFileManager.instance
     
    //let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    var path: Any!
    
    var saved = false
    var uploaded = false
    public var _projectName: String = ""
    public var annotes : Dictionary<String, Array<Dictionary<String, CGFloat>>> = ["accesspoint": [[:]]]
    public var myArray = [Dictionary<String, CGFloat>]()
    
    var colorPoint: String = "blue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        //projectName.delegate = self
        
    }
    
    // Set the shouldAutorotate to False
    override open var shouldAutorotate: Bool {
       return false
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    /* Uploads the photogallery and allows user select image and zoom in/out*/
    @IBAction func onClickUploadImage(_ sender: Any) {
        _projectName = projectName.text!
        
        //if (_projectName != "") {
            let vc = UIImagePickerController()
        
            // Suggested to use PHPicker
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            present(vc, animated: true)
            saved = false
            uploaded = true
            UploadingImageStack.isHidden = true
            Canvas.isHidden = true
            //(sender as! UIButton).isHidden = true
        //}
        //else {
        //    print("Name the project first before uploading an image")
        //}
    }
    
    @IBAction func onClickCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            _projectName = projectName.text!
            //if (_projectName != "") {
                let vc = UIImagePickerController()
                vc.delegate = self
                vc.sourceType = .camera;
                vc.allowsEditing = true
                present(vc, animated: true, completion: nil)
                saved = false
                uploaded = true
                UploadingImageStack.isHidden = true
                Canvas.isHidden = true
                //(sender as! UIButton).isHidden = true
            //}
            //else{
            //    print("Name the project first before uploading an image")
            //}
        }
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        _projectName = projectName.text!
        //projectNameHeader.text = _projectName
        _projectName = _projectName.trimmingCharacters(in: .whitespaces)
        
        if (_projectName != "" && saved == false && uploaded == true){
            print("Annotes: \(annotes)")
            manager.saveImage(globalImage!, "\(_projectName)", annotes)
            print(_projectName)
            saved = true
        }
        else if (_projectName != "" && saved == true){
            print("Project is already saved!")
        }
        else if (_projectName == ""){
            print("Name this project!")
        }
    }
    
    @IBAction func blue(_ sender: Any) {
        //print("Clicked blue")
        (sender as AnyObject).setImage( UIImage(systemName: "circle.inset.filled"), for: [])
        Green.setImage(UIImage(systemName: "circle.fill"), for: [])
        Red.setImage(UIImage(systemName: "circle.fill"), for: [])
        Yellow.setImage(UIImage(systemName: "circle.fill"), for: [])
        colorPoint = "blue"
        
    }
    
    @IBAction func green(_ sender: Any) {
        //print("Clicked green")
        (sender as AnyObject).setImage( UIImage(systemName: "circle.inset.filled"), for: [])
        Blue.setImage(UIImage(systemName: "circle.fill"), for: [])
        Red.setImage(UIImage(systemName: "circle.fill"), for: [])
        Yellow.setImage(UIImage(systemName: "circle.fill"), for: [])
        colorPoint = "green"
    }
    
    @IBAction func red(_ sender: Any) {
        //print("Clicked red")
        (sender as AnyObject).setImage( UIImage(systemName: "circle.inset.filled"), for: [])
        Blue.setImage(UIImage(systemName: "circle.fill"), for: [])
        Green.setImage(UIImage(systemName: "circle.fill"), for: [])
        Yellow.setImage(UIImage(systemName: "circle.fill"), for: [])
        colorPoint = "red"
    }
    
    @IBAction func yellow(_ sender: Any) {
        //print("Clicked yellow")
        (sender as AnyObject).setImage( UIImage(systemName: "circle.inset.filled"), for: [])
        Blue.setImage(UIImage(systemName: "circle.fill"), for: [])
        Green.setImage(UIImage(systemName: "circle.fill"), for: [])
        Red.setImage(UIImage(systemName: "circle.fill"), for: [])
        colorPoint = "yellow"
    }
    

    
    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissMyKeyboard))
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }
    @objc func dismissMyKeyboard(){
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        view.endEditing(true)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            //manager.saveImage(image, "\(_projectName)", annotes)
            globalImage = image
        }
        //manager.saveImage(image!, "\(_projectName)", annotes)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            if uploaded != false {
            // Set the Center of the Circle
            let circleCenter = touch.location(in: view)
            let dict = ["x": circleCenter.x, "y": circleCenter.y]
            
            myArray.append(dict)
            
            annotes = ["accesspoint": myArray]
            
            print("Annotes: ", annotes)
            
            // Set a Circle Radius
            let circleWidth = CGFloat(15)
            let circleHeight = circleWidth
                
            // Create a new CircleView
            // 3
                //var cardSegmentedControl = CardSegmentedControl()

                // here, change its property value
                //cardSegmentedControl.selectedIndex = 1
                //CircleView().selectedColor = colorPoint
                print(colorPoint)
                let circleView = CircleView(selectedColor: colorPoint,frame: CGRect(x: circleCenter.x, y: circleCenter.y, width: circleWidth, height: circleHeight))
            view.addSubview(circleView)
            }
            
        }
        saved = false
        print("{touch}")
    }
}


extension Dictionary where Key: Encodable, Value: Encodable {
    func writeToURL(_ url: URL) throws {
        // archive data
        let data = try PropertyListEncoder().encode(self)
        try data.write(to: url)
    }
}
