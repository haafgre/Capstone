//
//  BlueprintNamingViewController.swift
//  Capstone
//
//  Created by BVU Student on 3/29/22.
//

import UIKit

class BlueprintNamingViewController: UIViewController {

    @IBOutlet weak var blueprintName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "NewProjectView"){
            let vc = segue.destination as! NewProjectViewController
            if (blueprintName.text != "") {
                vc._projectName = self.blueprintName.text!
            } else {
                let alert = UIAlertController(title: "Alert", message: "Name this new project.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(action)
                
                present(alert, animated: true, completion: nil)

            }
   
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
