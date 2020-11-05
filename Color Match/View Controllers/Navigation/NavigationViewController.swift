//
//  NavigationViewController.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/18/20.
//

import UIKit

class NavigationViewController: UINavigationController {
    
    override var viewControllers: [UIViewController] {
        didSet {
            print("Set")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
        
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
