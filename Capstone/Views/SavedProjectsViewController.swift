//
//  SavedProjectsViewController.swift
//  Capstone
//
//  Created by BVU Student on 1/26/22.
//

import Foundation
import UIKit

class SavedProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //@IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myTableView: UITableView!
    
    var fileArray = [String]()
    var tryfile = ""
    //var fileArray = ["One", "two"]
    
    override func viewDidLoad()
    {
        
        /* Reads document directory and directory contents (add-on: removes all that are not png) */
        
        do {
            // Get the document directory url
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            //print("documentDirectory", documentDirectory.path)
            // Get the directory contents urls (including subfolders urls)
            let directoryContents = try FileManager.default.contentsOfDirectory(
                at: documentDirectory,
                includingPropertiesForKeys: nil
            )
            //print("directoryContents:", directoryContents.map { $0.localizedName ?? $0.lastPathComponent })
            for url in directoryContents {
                print(url.localizedName ?? url.lastPathComponent)
                //try FileManager.default.removeItem(at: url)
            }
            
            // if you would like to hide the file extension
            for var url in directoryContents {
                url.hasHiddenExtension = true
            }
            for url in directoryContents {
                //print(url.localizedName ?? url.lastPathComponent)
            }

            // if you want to get all png files located at the documents directory:
            let pngs = directoryContents.filter(\.isPNG).map { $0.localizedName ?? $0.lastPathComponent }
            print("pngs:", pngs)
            
        } catch {
            print(error)
        }
        
        
        /* Removes only png's */
        /* let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsUrl,
                                                                       includingPropertiesForKeys: nil,
                                                                       options: .skipsHiddenFiles)
            for fileURL in fileURLs where fileURL.pathExtension == "png" {
                try FileManager.default.removeItem(at: fileURL)
            }
        } catch  { print(error) } */
        
        // /var/mobile/Containers/Data/Application/A1916161-D3BC-4613-8FAA-FE16A0C37DFD/Documents
        let fileMngr = FileManager.default
        //let path = Bundle.main.resourcePath!
        let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        let items = try! fileMngr.contentsOfDirectory(atPath:docs)

        for item in items {
            //print(item)
            let _item  = item.suffix(3)
            if _item == "png" {
                print("Found a png")
            } else {
                fileArray.append(item)
            }
        }
        
        /* Set Array to Alphabetical and Numerical Order */
        fileArray = fileArray.sorted (by: { (first: String, second: String) -> Bool in
            return first.compare(second, options: .numeric) == .orderedAscending
        })
        
        myTableView.dataSource = self
        myTableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        
        content.text = fileArray[indexPath.row]
        content.textProperties.color = .systemBlue
        content.textProperties.font = UIFont.preferredFont(forTextStyle: .body)
        //cell.textLabel!.text = fileArray[indexPath.row]
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width + 10, height: 60))
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width:headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Saved Projects"
        //label.font = .systemFont(ofSize: 28)
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = NSTextAlignment.center
        label.textColor = .yellow
        label.backgroundColor = .gray

        headerView.addSubview(label)
            
        return headerView
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let row = indexPath.row
        self.tryfile = fileArray[row]
        print("User selected: \(fileArray[row])")
    
        /* FIXME: Highlights what gets clicked*/
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.isSelected = true
        //selectedCell.contentView.backgroundColor = UIColor.white
        
    }
    
    
    @IBAction func editBTN(_ sender: Any) {
        self.performSegue(withIdentifier: "LoadedView", sender: self)
    }
    
    @IBAction func deleteBTN(_ sender: Any) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: tryfile, relativeTo: directoryURL)
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("Delete \(tryfile)")
        } catch {
            // Catch any errors
            print(error.localizedDescription)
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "LoadedView"){
            let vc = segue.destination as! LoadedProjectViewController
            vc.selectedImage = self.tryfile
        }
    }
    
}

extension URL {
    var typeIdentifier: String? { (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier }
    var isPNG: Bool { typeIdentifier == "public.png" }
    var localizedName: String? { (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName }
    var hasHiddenExtension: Bool {
        get { (try? resourceValues(forKeys: [.hasHiddenExtensionKey]))?.hasHiddenExtension == true }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.hasHiddenExtension = newValue
            try? setResourceValues(resourceValues)
        }
    }
}
