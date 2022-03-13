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
    
    /* FIXME: Hard coding on selectedImage */
    var selectedImage: String = "idk.png"
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* FIXME: Nothing Loads correctly :') */
        let loadedImage = load(fileName: selectedImage)
        loadedView.image = loadedImage
        loadedView.image = UIImage(named: "test")
        // Do any additional setup after loading the view.
        print("Select: \(String(describing: selectedImage))")
        
    }
    
    // Set the shouldAutorotate to False
    override open var shouldAutorotate: Bool {
       return false
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    private func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        print("FileURL: \(fileURL)")
        do {
            let imageData = try Data(contentsOf: fileURL)
            print("Made it?")
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }

/*        //imageView.image = loadImageFromDocumentDirectory(fileName: selectedImage)
        //print("NO NIL: \(loadImageFromDocumentDirectory(fileName: selectedImage))")
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("project.png")
            loadedView.image = UIImage(contentsOfFile: imageURL.path)
            print(imageURL)
            // Do whatever you want with the image
            //loadedView.image = UIImage(named: "test")
        }
        
        

    }
    
    func loadImageFromDocumentDirectory(fileName: String) -> UIImage? {

            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!;
            let fileURL = documentsUrl.appendingPathComponent("project.png")
            do {
                let imageData = try Data(contentsOf: fileURL)
                return UIImage(data: imageData)
            } catch {}
            return UIImage(named: "test")
        }*/

}
