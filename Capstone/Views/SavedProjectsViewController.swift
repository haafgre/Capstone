//
//  SavedProjectsViewController.swift
//  Capstone
//
//  Created by BVU Student on 1/26/22.
//

import Foundation
import UIKit

class SavedProjectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var editBTN: UIButton!
    @IBOutlet weak var myTableView: UITableView!
    
    var hidecell = false
    var fileArray = [String]()
    var allCells: [UITableViewCell] = []
    var tryfileEdit = ""
    var tryfileDelete = ""
    
    override func viewDidLoad()
    {

        editBTN.isEnabled = false
        
        let fileMngr = FileManager.default
        let docs = fileMngr.urls(for: .documentDirectory, in: .userDomainMask)[0].path
        let items = try! fileMngr.contentsOfDirectory(atPath:docs)

        for item in items {
            //print(item)
            fileArray.append(item)
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
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width + 10, height: 60))
        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width:headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Saved Projects"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = NSTextAlignment.center
        label.textColor = .black
        label.backgroundColor = .systemOrange
        headerView.addSubview(label)
            
        return headerView
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let row = indexPath.row
        self.tryfileEdit = fileArray[row]
    
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        
        allCells = myTableView.subviews
                         .compactMap { $0 as? UITableViewCell }
        selectedCell.isHighlighted = true
        editBTN.backgroundColor = UIColor.systemBlue
        editBTN.isEnabled = true
        for cell in allCells{
            if cell != selectedCell {
                cell.isHighlighted = false
            }
        }

        if (hidecell == true){
            selectedCell.isHidden = true
            let point = myTableView.convert(CGPoint.zero, to: tableView)
            guard let indexpath = myTableView.indexPathForRow(at: point) else {return}
            fileArray.remove(at: indexpath.row)
            myTableView.beginUpdates()
            myTableView.deleteRows(at: [IndexPath(row: indexpath.row, section: 0)], with: .automatic)
            myTableView.endUpdates()
            hidecell = false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         
         if editingStyle == .delete {
             tryfileDelete = fileArray[indexPath.row]
             deleteBTN()
             fileArray.remove(at: indexPath.row)
             myTableView.deleteRows(at: [indexPath], with: .automatic)
         }
     }

    
    
    @IBAction func editBTN(_ sender: Any) {
        self.performSegue(withIdentifier: "LoadedView", sender: self)
    }
    
    func deleteBTN() {
        hidecell = true
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = URL(fileURLWithPath: tryfileDelete, relativeTo: directoryURL)
        
        if (tryfileDelete != ""){
            do {
                
                try FileManager.default.removeItem(at: fileURL)
            } catch {
                // Catch any errors
                print(error.localizedDescription)
            }
        } else {
            let alert = UIAlertController(title: "Deleting", message: "No project selected yet", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        hidecell = false
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "LoadedView"){
            let vc = segue.destination as! LoadedProjectViewController
            vc._projectName = self.tryfileEdit
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
