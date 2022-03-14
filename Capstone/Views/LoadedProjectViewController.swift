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
}
