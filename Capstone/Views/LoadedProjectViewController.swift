//
//  LoadedProjectViewController.swift
//  Capstone
//
//  Created by BVU Student on 3/11/22.
//

import Photos
import PhotosUI
import UIKit
import SQLite

class LoadedProjectViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var title_lbl: UILabel!
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
    @IBOutlet weak var iconName: UITextField!
    @IBOutlet weak var iconType: UITextField!
    @IBOutlet weak var iconLocation: UITextField!
    @IBOutlet weak var selectedIconName: UILabel!
    @IBOutlet weak var selectedIconType: UILabel!
    @IBOutlet weak var selectedIconLocation: UILabel!
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    
    var globalImage:UIImage? = nil
    var allButtons: [UIButton] = []
    
    let manager = LocalFileManager.instance
    public var _projectName: String = ""
    var path: Any!
    var setIcon = true
    var saved = false
    var uploaded = false
    var keyboard = false
    var x = CGFloat()
    var toFloatx = Float()
    var y = CGFloat()
    var toFloaty = Float()
    var colorPoint: String = "blue"
    var database: Connection!
    let iconsTable = Table("icons")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let type = Expression<String>("type")
    let location = Expression<String>("location")
    let color = Expression<String>("color")
    let _x = Expression<String>("x")
    let _y = Expression<String>("y")
    var iconArray = [String]()
    var iconID : Int = 0
    var selectedIconID = 0
    var selectedImage = ""
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeHideKeyboard()
        title_lbl.text = _projectName
        
        let loadedImage = load(fileName: _projectName)
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = loadedImage
        globalImage = imageView.image
        uploaded = true
        Canvas.isHidden = true
        
        do{            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("\(_projectName)/\(_projectName)-icons").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        printListIcons()
    }
    
    // Set the shouldAutorotate to False
    override open var shouldAutorotate: Bool {
       return false
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    private func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent("\(fileName)/\(fileName).png")
 
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    /* Uploads the photogallery and allows user select image and zoom in/out*/
    @IBAction func onClickUploadImage(_ sender: Any) {
        let vc = UIImagePickerController()
        
        // Suggested to use PHPicker
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = false
        present(vc, animated: true)
        saved = false
        uploaded = true

    }
    
    @IBAction func onClickCamera(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.sourceType = .camera;
            vc.allowsEditing = true
            present(vc, animated: true, completion: nil)
            saved = false
            uploaded = true

        }
    }
    
    @IBAction func toCameraRoll(_ sender: Any) {

        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, imageView.isOpaque, 0.0)
        
        self.imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img : UIImage  = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext();

        if (globalImage != nil){
            UIImageWriteToSavedPhotosAlbum(img,self, nil, nil)
        } else {
            print("NIL~")
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        listIcons()

        if (_projectName != "" && saved == false && uploaded == true){
            manager.saveProject(globalImage!, "\(_projectName)")
            saved = true
            
            let alert = UIAlertController(title: "Saving", message: "Project saved", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else if (_projectName != "" && saved == true){
            let alert = UIAlertController(title: "Saving", message: "Project is already saved!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else if (_projectName == ""){
            let alert = UIAlertController(title: "Saving", message: "Name this project before saving!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else if (_projectName != "" && uploaded == false){
            let alert = UIAlertController(title: "Saving", message: "Upload blueprint before saving!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func blue(_ sender: Any) {
        dismissMyKeyboard()
        (sender as AnyObject).setImage( UIImage(systemName: "circle.inset.filled"), for: [])
        Green.setImage(UIImage(systemName: "circle.fill"), for: [])
        Red.setImage(UIImage(systemName: "circle.fill"), for: [])
        Yellow.setImage(UIImage(systemName: "circle.fill"), for: [])
        colorPoint = "blue"
        
    }
    
    @IBAction func green(_ sender: Any) {
        dismissMyKeyboard()
        (sender as AnyObject).setImage( UIImage(systemName: "circle.inset.filled"), for: [])
        Blue.setImage(UIImage(systemName: "circle.fill"), for: [])
        Red.setImage(UIImage(systemName: "circle.fill"), for: [])
        Yellow.setImage(UIImage(systemName: "circle.fill"), for: [])
        colorPoint = "green"
    }
    
    @IBAction func red(_ sender: Any) {
        dismissMyKeyboard()
        (sender as AnyObject).setImage( UIImage(systemName: "circle.inset.filled"), for: [])
        Blue.setImage(UIImage(systemName: "circle.fill"), for: [])
        Green.setImage(UIImage(systemName: "circle.fill"), for: [])
        Yellow.setImage(UIImage(systemName: "circle.fill"), for: [])
        colorPoint = "red"
    }
    
    @IBAction func yellow(_ sender: Any) {
        dismissMyKeyboard()
        (sender as AnyObject).setImage( UIImage(systemName: "circle.inset.filled"), for: [])
        Blue.setImage(UIImage(systemName: "circle.fill"), for: [])
        Green.setImage(UIImage(systemName: "circle.fill"), for: [])
        Red.setImage(UIImage(systemName: "circle.fill"), for: [])
        colorPoint = "yellow"
    }
    

    
    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        keyboard = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissMyKeyboard))
        
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }
    @objc func dismissMyKeyboard(){
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        keyboard = false
        view.endEditing(true)
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            globalImage = image
        }
        if (imageView.image != nil) {
            Canvas.isHidden = true
        }

        dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (keyboard == true){
            dismissMyKeyboard()
        } else {
        for touch in touches {
            if uploaded != false {
                // Set the Center of the Circle
                let circleCenter = touch.location(in: imageView)

            
                // Set a Circle Radius
                let circleWidth = CGFloat(25)
                let circleHeight = circleWidth
                
                if (iconName.text != "" && iconType.text != "" && iconLocation.text != "") {
                    x = circleCenter.x
                    y = circleCenter.y
                    toFloatx = Float(x)
                    toFloaty = Float(y)
                    let success = insertIcon()
                    
                    if (success == true && setIcon == true) {

                        let btnIconID = UIButton(frame: CGRect(x: circleCenter.x-7.5, y: circleCenter.y-7.5, width: circleWidth, height: circleHeight))
                        btnIconID.backgroundColor = .clear
                        if (colorPoint == "blue") {
                            btnIconID.tintColor = UIColor.blue
                        }
                        else if (colorPoint == "green") {
                            btnIconID.tintColor = UIColor.green
                        }
                        else if (colorPoint == "red") {
                            btnIconID.tintColor = UIColor.red
                        }
                        else if (colorPoint == "yellow") {
                            btnIconID.tintColor = UIColor.yellow
                        }

                        let largeConfig = UIImage.SymbolConfiguration(pointSize: 340, weight: .bold, scale: .large)
                               
                        let largeBoldDoc = UIImage(systemName: "circle.fill", withConfiguration: largeConfig)

                        btnIconID.setImage(largeBoldDoc, for: .normal)

                        btnIconID.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

                        iconID = Int(database.lastInsertRowid)
                        
                        btnIconID.tag = iconID

                        imageView.addSubview(btnIconID)

                        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 25))
                        label.center = CGPoint(x: 10, y: 30)
                        label.textAlignment = .center
                        if (colorPoint == "blue"){
                            label.textColor = UIColor.blue
                        }
                        else if (colorPoint == "green"){
                            label.textColor = UIColor.green
                        }
                        else if (colorPoint == "yellow"){
                            label.textColor = UIColor.systemYellow
                        }
                        else if (colorPoint == "red"){
                            label.textColor = UIColor.red
                        }
                        label.shadowColor = UIColor.black
                        label.text = iconName.text

                        btnIconID.addSubview(label)
                        setIcon = false
                    }
                }
                else if (iconName.text == "" || iconType.text == "" || iconLocation.text == "") {
                    if(keyboard == true) {
                        dismissMyKeyboard()
                        keyboard = false
                    }
                    else {
                        let alert = UIAlertController(title: "Alert", message: "Please fill in all field entries before placing icons!", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                        alert.addAction(action)
                        present(alert, animated: true, completion: nil)
                        continue
                    }
                }
            } else {
                let alert = UIAlertController(title: "Alert", message: "Insert blueprint image", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
        }
        saved = false

    }
    
    func createTable() {
        
        let createTable = self.iconsTable.create { table in
            table.column(self.id, primaryKey: true)
            table.column(self.name, unique: true)
            table.column(self.type)
            table.column(self.location)
            table.column(self.color)
        }
        do {
            try self.database.run(createTable)
        } catch {
            print(error)
        }
    }
    
    func insertIcon() -> Bool {
        
        label.text = String(iconID)

        guard let name = iconName.text,
              let type = iconType.text,
              let location = iconLocation.text
              //let color
        else {return false}
        
        let insertIcon = self.iconsTable.insert(self.name <- name, self.type <- type, self.location <- location, self.color <- colorPoint, self._x <- String(describing: toFloatx), self._y <- String(describing: toFloaty))
        
        do {
            try self.database.run(insertIcon)
            setIcon = true
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func listIcons() {
        do {
            let icons = try self.database.prepare(self.iconsTable)
            for icon in icons {
                print("iconID: \(icon[self.id]), name: \(icon[self.name]), type: \(icon[self.type]), location: \(icon[self.location]), color: \(icon[self.color]), x: \(icon[self._x]), y: \(icon[self._y])")
            }
        } catch {
            print(error)
        }
    }
    
    func printListIcons() {
        do {
            let icons = try self.database.prepare(self.iconsTable)
            for icon in icons {

                    let circleWidth = CGFloat(20)
                    let circleHeight = circleWidth
                    
                    colorPoint = icon[self.color]

                        let loadx = Float(icon[self._x])
                        let loady = Float(icon[self._y])
                        x = CGFloat(loadx ?? 0.0)
                        y = CGFloat(loady ?? 0.0)
                        toFloatx = Float(x)
                        toFloaty = Float(y)


                            let btnIconID = UIButton(frame: CGRect(x: x-7.5, y: y-7.5, width: circleWidth, height: circleHeight))
                            btnIconID.backgroundColor = .clear
                            if (colorPoint == "blue") {
                                btnIconID.tintColor = UIColor.blue
                            }
                            else if (colorPoint == "green") {
                                btnIconID.tintColor = UIColor.green
                            }
                            else if (colorPoint == "red") {
                                btnIconID.tintColor = UIColor.red
                            }
                            else if (colorPoint == "yellow") {
                                btnIconID.tintColor = UIColor.yellow
                            }

                            let largeConfig = UIImage.SymbolConfiguration(pointSize: 340, weight: .bold, scale: .large)
                                   
                            let largeBoldDoc = UIImage(systemName: "circle.fill", withConfiguration: largeConfig)

                            btnIconID.setImage(largeBoldDoc, for: .normal)

                            btnIconID.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
 
                            iconID = icon[self.id]

                            btnIconID.tag = icon[self.id]
                            imageView.addSubview(btnIconID)

                            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 25))
                            label.center = CGPoint(x: 10, y: 30)
                            label.textAlignment = .center
                            if (colorPoint == "blue"){
                                label.textColor = UIColor.blue
                            }
                            else if (colorPoint == "green"){
                                label.textColor = UIColor.green
                            }
                            else if (colorPoint == "yellow"){
                                label.textColor = UIColor.systemYellow
                            }
                            else if (colorPoint == "red"){
                                label.textColor = UIColor.red
                            }
                            label.shadowColor = UIColor.black
                
                            label.text = icon[self.name]
 
                            btnIconID.addSubview(label)
                            setIcon = false
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func updateIcon(_ sender: Any) {
        guard let name = iconName.text,
              let type = iconType.text,
              let location = iconLocation.text
        else {return}
        let icon = self.iconsTable.filter(self.name == name)
        let updateIcon = icon.update(self.name <- name, self.type <- type, self.location <- location, self.color <- colorPoint)
        
        do {
            try self.database.run(updateIcon)
        } catch {
            print(error)
        }
    }
    
    @IBAction func deleteIcon(_ sender: Any) {
        let icon = self.iconsTable.filter(self.id == selectedIconID)
        let deleteIcon = icon.delete()
        allButtons = imageView.subviews
                         .compactMap { $0 as? UIButton }
        for btn in allButtons{
            if btn.tag == selectedIconID {
                btn.isHidden = true
                selectedIconName.text = ""
                selectedIconType.text = ""
                selectedIconLocation.text = ""
            }
        }
        
        do {
            try self.database.run(deleteIcon)
            listIcons()
        } catch {
            print(error)
        }
    }
    
    @objc func buttonAction(_ sender: UIButton?) {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 34, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "circle.inset.filled", withConfiguration: largeConfig)
        sender?.setImage(largeBoldDoc, for: .normal)
        selectedIconID = sender!.tag
        label.text = String(selectedIconID)
        allButtons = imageView.subviews
                         .compactMap { $0 as? UIButton }
    
        for btn in allButtons{
            if btn.tag != sender?.tag {
                let largeConfig = UIImage.SymbolConfiguration(pointSize: 34, weight: .bold, scale: .large)
                let largeBoldDoc = UIImage(systemName: "circle.fill", withConfiguration: largeConfig)
                btn.setImage(largeBoldDoc, for: .normal)
            }
        }
        do {
            let icons = try self.database.prepare(self.iconsTable)
            for icon in icons {
                if (icon[self.id] == sender?.tag) {
                    selectedIconName.text = icon[self.name]
                    selectedIconType.text = icon[self.type]
                    selectedIconLocation.text = icon[self.location]
                }
            }
        } catch {
            print(error)
        }
    }
}
