//
//  LoadedProjectViewController.swift
//  Capstone
//
//  Created by BVU Student on 3/11/22.
//

import Photos
import PhotosUI
import UIKit

class LoadedProjectViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var loadedView: UIImageView!
    
    
    var saved = false
    var uploaded = true
    
    public var _projectName: String = ""
    public var annotes : Dictionary<String, Array<Dictionary<String, CGFloat>>> = ["accesspoint": [[:]]]
    public var myArray = [Dictionary<String, CGFloat>]()
    
    /* FIXME: Hard coding on selectedImage */
    var selectedImage = ""
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* FIXME: Nothing Loads correctly :') */
        let loadedImage = load(fileName: selectedImage)
        loadedView.contentMode = .scaleAspectFit
        loadedView.image = loadedImage
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
            //    let circleView = CircleView(selectedColor: ,frame: CGRect(x: circleCenter.x, y: circleCenter.y, width: circleWidth, height: circleHeight))
            //view.addSubview(circleView)
            }
        }
        saved = false
        print("touch")
    }
}
