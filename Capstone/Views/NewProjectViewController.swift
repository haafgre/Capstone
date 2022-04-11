//
//  NewProjectViewController.swift
//  Capstone
//
//  Created by BVU Student on 1/26/22.
//

import Photos
import PhotosUI
import UIKit
import SQLite

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
        }*/
}

class NewProjectViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

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
    var iconID : Int = 0
    var selectedIconID = 0
    @IBOutlet weak var selectedIconName: UILabel!
    @IBOutlet weak var selectedIconType: UILabel!
    @IBOutlet weak var selectedIconLocation: UILabel!
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    //label.center = CGPoint(x: 160, y: 285)
    //label.textAlignment = .center
    
    @IBOutlet weak var tree: UIView!
    //public var image: UIImage = UIImage()
    //var image:UIImage? = nil
    var globalImage:UIImage? = nil
    var allButtons: [UIButton] = []
    
    let manager = LocalFileManager.instance
    
    
    //let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    var path: Any!
    
    var setIcon = true
    var saved = false
    var uploaded = false
    var keyboard = false
    public var _projectName: String = ""
    public var annotes : Dictionary<String, Array<Dictionary<String, CGFloat>>> = ["accesspoint": [[:]]]
    public var myArray = [Dictionary<String, CGFloat>]()
    
    
    var colorPoint: String = "blue"
    var database: Connection!
    let iconsTable = Table("icons")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let type = Expression<String>("type")
    let location = Expression<String>("location")
    let color = Expression<String>("color")
    var iconArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeHideKeyboard()
        title_lbl.text = _projectName
        
        do{
            let fManager = FileManager.default
            guard let url = fManager.urls(
                for: .documentDirectory,
                in: .userDomainMask
            ).first else {
                return
            }
            let newFolderUrl = url
                .appendingPathComponent("\(_projectName)")
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
            let fileUrl = documentDirectory.appendingPathComponent("\(_projectName)/\(_projectName)-icons").appendingPathExtension("sqlite3")
            print(fileUrl)
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        createTable()
        
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
/*
        /*UIGraphicsBeginImageContextWithOptions(imageView.frame.size, imageView.isOpaque, 0.0)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageWithLines = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        */
        //let rect : CGRect = CGRect() //Your view size from where you want to make UIImage
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, imageView.isOpaque, 0.0);
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        //let context : CGContextRef = UIGraphicsGetCurrentContext()
        //self.view.layer.renderInContext(context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        // start
        /*UIGraphicsBeginImageContext(imageView.bounds.size);

        let context : CGContext = UIGraphicsGetCurrentContext()!
        //context.translateBy(x: -10, y: -51);    // <-- shift everything up by 40px when drawing.

        self.view.layer.render(in: context)
        let img : UIImage  = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext();*/
        // end

        // NOW you have the image to save
        UIImageWriteToSavedPhotosAlbum(img!, self, nil, nil)
    }
*/
        //let rect : CGRect = CGRect(x: 10, y: 51, width: imageView.image!.size.width, height: imageView.image!.size.height)
        //let rect : CGRect = CGRect()
        //UIGraphicsBeginImageContext(rect.size);

        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, imageView.isOpaque, 0.0)
        //context.translateBy(x: -10, y: -51);    // <-- shift everything up by 40px when drawing.

        //self.view.layer.render(in: context)
        
        self.imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img : UIImage  = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext();

        if (globalImage != nil){
            UIImageWriteToSavedPhotosAlbum(img,self, nil, nil)
            //UIImageWriteToSavedPhotosAlbum(globalImage!, nil, nil, nil);
            /*print("Saved to camera roll.")*/
        } else {
            print("NIL~")
        }
    }

    @IBAction func saveButtonPressed(_ sender: UIButton) {
        listIcons()
        
        if (_projectName != "" && saved == false && uploaded == true){
            /*print("Annotes: \(annotes)")*/
            manager.saveImage(globalImage!, "\(_projectName)", annotes)
            /*print(_projectName)*/
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
        //print("Clicked blue")
        dismissMyKeyboard()
        (sender as AnyObject).setImage( UIImage(systemName: "circle.inset.filled"), for: [])
        Green.setImage(UIImage(systemName: "circle.fill"), for: [])
        Red.setImage(UIImage(systemName: "circle.fill"), for: [])
        Yellow.setImage(UIImage(systemName: "circle.fill"), for: [])
        colorPoint = "blue"
        
    }
    
    @IBAction func green(_ sender: Any) {
        //print("Clicked green")
        dismissMyKeyboard()
        (sender as AnyObject).setImage( UIImage(systemName: "circle.inset.filled"), for: [])
        Blue.setImage(UIImage(systemName: "circle.fill"), for: [])
        Red.setImage(UIImage(systemName: "circle.fill"), for: [])
        Yellow.setImage(UIImage(systemName: "circle.fill"), for: [])
        colorPoint = "green"
    }
    
    @IBAction func red(_ sender: Any) {
        //print("Clicked red")
        dismissMyKeyboard()
        (sender as AnyObject).setImage( UIImage(systemName: "circle.inset.filled"), for: [])
        Blue.setImage(UIImage(systemName: "circle.fill"), for: [])
        Green.setImage(UIImage(systemName: "circle.fill"), for: [])
        Yellow.setImage(UIImage(systemName: "circle.fill"), for: [])
        colorPoint = "red"
    }
    
    @IBAction func yellow(_ sender: Any) {
        //print("Clicked yellow")
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
            //UploadingImageStack.isHidden = true
        }

        dismiss(animated: true, completion: nil)
    }/*
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            //manager.saveImage(image, "\(_projectName)", annotes)
            globalImage = image
            picker.dismiss(animated: true, completion: nil)

        }
        //manager.saveImage(image!, "\(_projectName)", annotes)
        if (imageView.image != nil) {
            Canvas.isHidden = true
        }
        //picker.dismiss(animated: true, completion: nil)
    }*/
    
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
                let dict = ["x": circleCenter.x, "y": circleCenter.y]
            
                myArray.append(dict)
            
                annotes = ["accesspoint": myArray]
            
                /*print("Annotes: ", annotes)*/
            
                // Set a Circle Radius
                let circleWidth = CGFloat(25)
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
                        //let circleView = CircleView(selectedColor: colorPoint,frame: CGRect(x: circleCenter.x-7.5, y: circleCenter.y-7.5, width: circleWidth, height: circleHeight))
                        //var strIconID = String(IconID)
                        //var btnIconID =
                        let btnIconID = UIButton(frame: CGRect(x: circleCenter.x-7.5, y: circleCenter.y-7.5, width: circleWidth, height: circleHeight))
                        btnIconID.backgroundColor = .clear
                        if (colorPoint == "blue") {
                            btnIconID.tintColor = UIColor.blue //fillColor = UIColor.blue.cgColor
                        }
                        else if (colorPoint == "green") {
                            btnIconID.tintColor = UIColor.green //fillColor = UIColor.green.cgColor
                        }
                        else if (colorPoint == "red") {
                            btnIconID.tintColor = UIColor.red //fillColor = UIColor.red.cgColor
                        }
                        else if (colorPoint == "yellow") {
                            btnIconID.tintColor = UIColor.yellow //fillColor = UIColor.yellow.cgColor
                        }
                        //btnIconID.setTitle("Test Button", for: .normal)
                        let largeConfig = UIImage.SymbolConfiguration(pointSize: 340, weight: .bold, scale: .large)
                               
                        let largeBoldDoc = UIImage(systemName: "circle.fill", withConfiguration: largeConfig)

                        //button.setImage(largeBoldDoc, for: .normal)
                        btnIconID.setImage(largeBoldDoc, for: .normal)
                        //btnIconID.setBackgroundImage(UIImage(systemName: "circle.inset.filled"), for: .highlighted)
                        //btnIconID.setImage(UIImage(systemName: "circle.fill"), for: [])
                        btnIconID.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                        
                        
                        // FIXME: BUGGY ... not buttons anymore?
                        print("allButtons: \(allButtons.count)")
                        //btnIconID.tag = allButtons.count //iconID
                        print("CREATED ICON WITH TAG ID -> \(iconID) ")
                        /*var icon : SQLite.Row
                        do {
                            let icons = try self.database.prepare(self.iconsTable)
                            for icon in icons {
                                print("iconID: \(icon[self.id]), name: \(icon[self.name]), type: \(icon[self.type]), location: \(icon[self.location]), color: \(icon[self.color])")
                            }
                        } catch {
                            print(error)
                        }*/
                        iconID = Int(database.lastInsertRowid)
                        print("HERE -> \(database.lastInsertRowid)")
                        btnIconID.tag = iconID
                        imageView.addSubview(btnIconID)
                        //print("allButtons after: \(allButtons.count)")
                        //print("ID NUM: \(btnIconID.tag)")
                        //if(allButtons.isEmpty){
                        //     print("EMPTY")
                        //}

                        //iconID = iconID + 1*/
                        
                        
                        //let label = UILabel(frame: CGRect(x: circleCenter.x, y: circleCenter.y, width: 250, height: 25))
                        //label.center = CGPoint(x: circleCenter.x, y: circleCenter.y+25)
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
                        //circleView.isUserInteractionEnabled = true
                        //circleView.isHighlighted = true
                        
                        //circleView.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
                        //label.isUserInteractionEnabled = true
                        //imageView.addSubview(circleView)
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
        /*let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.center = CGPoint(x: 160, y: 285)
        label.textAlignment = .center*/
        label.text = String(iconID)
        //self.view.addSubview(label)
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
            /*iconID = iconID + 1*/
            return true
        } catch {
            print(error)
            /*let alert = UIAlertController(title: "Alert", message: "You already used that name for that type, try using a different name or 'Update Icon' if you made changes.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)*/
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
        print("Deleting data for iconID: SELECTEDID -> \(selectedIconID) ICONID -> \(iconID) SELFID -> \(self.id)")
        //guard let _id =
        //    else {return}
        let icon = self.iconsTable.filter(self.id == selectedIconID)
        let deleteIcon = icon.delete()
        allButtons = imageView.subviews
                         .compactMap { $0 as? UIButton }
        for btn in allButtons{
            if btn.tag == selectedIconID {
                btn.isHidden = true
                /*iconID = iconID - 1*/
                /*selectedIconID = 0*/
                selectedIconName.text = ""
                selectedIconType.text = ""
                selectedIconLocation.text = ""
            }
        }
        
        do {
            try self.database.run(deleteIcon)
            print("DELETED ICON DATA, NOW RESETING SELECTEDID: \(selectedIconID) ICONID -> \(iconID)")
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
        print("YOU SELECTEDICONID -> \(selectedIconID) ICONID -> \(iconID)")
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
                //print("iconID: \(icon[self.id]), name: \(icon[self.name]), type: \(icon[self.type]), location: \(icon[self.location]), color: \(icon[self.color])")
            }
        } catch {
            print(error)
        }
    }
}


extension Dictionary where Key: Encodable, Value: Encodable {
    func writeToURL(_ url: URL) throws {
        // archive data
        let data = try PropertyListEncoder().encode(self)
        try data.write(to: url)
    }
}

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        //guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
}

/*extension UIImageView {

    var imageRect: CGRect {
        guard let imageSize = self.image?.size else { return self.frame }

        let scale = UIScreen.main.scale

        let imageWidth = (imageSize.width / scale).rounded()
        let frameWidth = self.frame.width.rounded()

        let imageHeight = (imageSize.height / scale).rounded()
        let frameHeight = self.frame.height.rounded()

        let ratio = max(frameWidth / imageWidth, frameHeight / imageHeight)
        let newSize = CGSize(width: imageWidth * ratio, height: imageHeight * ratio)
        let newOrigin = CGPoint(x: self.center.x - (newSize.width / 2), y: self.center.y - (newSize.height / 2))
        return CGRect(origin: newOrigin, size: newSize)
    }

}*/
