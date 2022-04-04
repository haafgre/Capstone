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

    @IBOutlet weak var loadedView: UIImageView!
    @IBOutlet weak var projectSave: UIButton!
    @IBOutlet weak var iconName: UITextField!
    @IBOutlet weak var iconType: UITextField!
    @IBOutlet weak var iconLocation: UITextField!
    @IBOutlet weak var Blue: UIButton!
    @IBOutlet weak var Green: UIButton!
    @IBOutlet weak var Red: UIButton!
    @IBOutlet weak var Yellow: UIButton!

    
    var globalImage:UIImage? = nil
    let manager = LocalFileManager.instance
    
    var saved = false
    var uploaded = true
    var setIcon = true
    var keyboard = false
    
    //public var _projectName: String = ""
    var colorPoint: String = "blue"
    public var annotes : Dictionary<String, Array<Dictionary<String, CGFloat>>> = ["accesspoint": [[:]]]
    public var myArray = [Dictionary<String, CGFloat>]()

    var database: Connection!
    let iconsTable = Table("icons")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let type = Expression<String>("type")
    let location = Expression<String>("location")
    let color = Expression<String>("color")
    var iconArray = [String]()
    
    /* FIXME: Hard coding on selectedImage */
    var selectedImage = ""
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        
        let loadedImage = load(fileName: selectedImage)
        loadedView.contentMode = .scaleAspectFit
        loadedView.image = loadedImage
        
        do{
            let fManager = FileManager.default
            guard let url = fManager.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first else {
                return
            }
            let newFolderUrl = url
                .appendingPathComponent("\(selectedImage)")
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
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("\(selectedImage)/\(selectedImage)-icons").appendingPathExtension("sqlite3")
            print(fileUrl)
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
        //createTable()
        //loadedView.image = UIImage(named: "test")
        // Do any additional setup after loading the view.
        //print("Select: \(String(describing: selectedImage))")
        
    }
    
    // Set the shouldAutorotate to False
    override open var shouldAutorotate: Bool {
       return false
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
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
        view.endEditing(true)
    }
    
    private func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent("\(fileName)/\(fileName).png")
        //print("FileURL: \(fileURL)")
        do {
            let imageData = try Data(contentsOf: fileURL)
            //print("Made it?")
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        listIcons()
        
        if (selectedImage != "" && saved == false && uploaded == true){
            print("Annotes: \(annotes)")
            manager.saveImage(globalImage!, "\(selectedImage)", annotes)
            print(selectedImage)
            saved = true
            
            let alert = UIAlertController(title: "Saving", message: "Project saved", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else if (selectedImage != "" && saved == true){
            let alert = UIAlertController(title: "Saving", message: "Project is already saved!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else if (selectedImage == ""){
            let alert = UIAlertController(title: "Saving", message: "Name this project before saving!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else if (selectedImage != "" && uploaded == false){
            let alert = UIAlertController(title: "Saving", message: "Upload blueprint before saving!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissMyKeyboard()
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
                
                if (iconName.text != "" && iconType.text != "" && iconLocation.text != "") {
                    let success = insertIcon()
                    if (success == true && setIcon == true) {
                        let circleView = CircleView(selectedColor: colorPoint,frame: CGRect(x: circleCenter.x-7.5, y: circleCenter.y-7.5, width: circleWidth, height: circleHeight))
                        view.addSubview(circleView)
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
                    }
                }
            } else {
                let alert = UIAlertController(title: "Alert", message: "Insert blueprint image", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
        }
        saved = false
        print("{touch}")
    }
    
    func createTable() {
//        print("CREATED TABLE")
        
        let createTable = self.iconsTable.create { table in
            table.column(self.id, primaryKey: true)
            table.column(self.name, unique: true)
            table.column(self.type)
            table.column(self.location)
            table.column(self.color)
        }
        do {
            try self.database.run(createTable)
            print("TABLE GOT CREATED")
        } catch {
            print(error)
        }
    }
    
    func insertIcon() -> Bool {
        print("Inserting")
        guard let name = iconName.text,
              let type = iconType.text,
              let location = iconLocation.text
              //let color
        else {return false}
        let insertIcon = self.iconsTable.insert(self.name <- name, self.type <- type, self.location <- location, self.color <- colorPoint)
        
        do {
            try self.database.run(insertIcon)
            print("INSERTED ICON DATA")
            setIcon = true
            return true
        } catch {
            print(error)
            let alert = UIAlertController(title: "Alert", message: "You already used that name for that type, try using a different name or 'Update Icon' if you made changes.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            return false
        }
    }
    
    func listIcons() {
        print("Listing")
        
        do {
            let icons = try self.database.prepare(self.iconsTable)
            for icon in icons {
                print("iconID: \(icon[self.id]), name: \(icon[self.name]), type: \(icon[self.type]), location: \(icon[self.location]), color: \(icon[self.color])")
            }
        } catch {
            print(error)
        }
    }
    
    @IBAction func updateIcon(_ sender: Any) {
        print("Updating")
        guard let name = iconName.text,
              let type = iconType.text,
              let location = iconLocation.text
              //let color
        else {return}
        let icon = self.iconsTable.filter(self.name == name)
        let updateIcon = icon.update(self.name <- name, self.type <- type, self.location <- location, self.color <- colorPoint)
        
        do {
            try self.database.run(updateIcon)
            print("UPDATED ICON DATA")
        } catch {
            print(error)
        }
    }
    
    @IBAction func deleteIcon(_ sender: Any) {
        print("Deleting")
        guard let name = iconName.text
            else {return}
        let icon = self.iconsTable.filter(self.name == name)
        let deleteIcon = icon.delete()
        
        do {
            try self.database.run(deleteIcon)
            print("DELETED ICON DATA")
        } catch {
            print(error)
        }
        
    }
}
