//
//  ColorViewController.swift
//  Color Match
//
//  Created by Sylvan Martin on 10/17/20.
//

import UIKit

class ColorViewController: UIViewController {
    
    // MARK: - Properties
    
    /// The color to analyze
    var color: UIColor = .white
    
    /// The RGB making up the color
    var rgb: [Double] = [0, 0, 0]
    
    /// The mix of pigments for the color
    var pigments: [ColorReplicator.Paint : Double] = [
        .red            : 0,
        .yellow         : 0,
        .yellowOchre    : 0,
        .lightBlue      : 0,
        .darkBlue       : 0,
        .sepiaBrown     : 0,
        .burntUmber     : 0,
        .white          : 0
    ]
    
    
    // MARK: - Visual Properties
    
    /// Color View
    @IBOutlet weak var colorView: UIView!
    
    /// Red Label
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var redBar: UIProgressView!
    
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var greenBar: UIProgressView!
    
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var blueBar: UIProgressView!
    

    @IBOutlet weak var saveButton: UIButton!
    
    /*
     * Properties for displaying the pigment mixture
     */
    @IBOutlet weak var redPigmentLabel: UIProgressView!
    @IBOutlet weak var yellowPigmentLabel: UIProgressView!
    @IBOutlet weak var yellowOchrePigmentLabel: UIProgressView!
    @IBOutlet weak var lightBluePigmentLabel: UIProgressView!
    @IBOutlet weak var darkBluePigmentLabel: UIProgressView!
    @IBOutlet weak var sepiaBrownPigmentLabel: UIProgressView!
    @IBOutlet weak var burntUmberPigmentLabel: UIProgressView!
    @IBOutlet weak var whitePigmentLabel: UIProgressView!
    
    var pigmentBars: [ColorReplicator.Paint : UIProgressView]!
    
    var colorBars:  [UIProgressView] = []
    var labels:     [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pigmentBars = [
            .red: redPigmentLabel,
            .yellow: yellowPigmentLabel,
            .yellowOchre: yellowOchrePigmentLabel,
            .lightBlue: lightBluePigmentLabel,
            .darkBlue: darkBluePigmentLabel,
            .sepiaBrown: sepiaBrownPigmentLabel,
            .burntUmber: burntUmberPigmentLabel,
            .white: whitePigmentLabel
        ]
        
        pigmentBars.forEach { $0.value.progress = 0 }

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        colorView.backgroundColor = color
        var (red, green, blue): (CGFloat, CGFloat, CGFloat) = (0, 0, 0)
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        rgb = [red, green, blue].map { Double($0) }
        colorBars = [redBar, greenBar, blueBar]
        
        labels = [redLabel, greenLabel, blueLabel]
        
        // set up visuals
        
        // set up bars
        for i in 0...2 {
            labels[i].text = String(format: "%.2f", rgb[i])
            colorBars[i].progress = Float(rgb[i])
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("Replicating...")
        
        let replicator = ColorReplicator()
        
        replicator.calculateMixture(rgb: convert(rgb: rgb), shouldCalculateWatercolor: false, colors: &pigments)
        
        // display the pigment mixture
        
        
        
        for key in pigments.keys {
            pigmentBars[key]?.setProgress(Float(pigments[key]!), animated: true)
        }
        
    }
    
    // MARK: Interface Actions
    
    /**
     * Called when the save button is pressed
     */
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Save Color", message: "What is this color's name?", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Color Name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [self] _ in
            // make sure the user actually typed a name
            if alertController.textFields?.first?.text == "" || alertController.textFields?.first?.text == nil {
                displayAlert(sender: self, title: "No Name Given", description: "Please enter a name for the color before you save it")
            }
            
            // make sure we have already calculated the pigments
            if pigments == nil {
                displayAlert(sender: self, title: "Pigments not Calculated", description: "Please wait until the pigment mixture has been calculated before saving the color")
            }
            
            // save the color
            let name = alertController.textFields?.first!.text
            let color = (rgb: (red: rgb[0], green: rgb[1], blue: rgb[2]), pigments: pigments)
            ColorLibraryObject.add(name: name!, color: color)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addActions(actions: saveAction, cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        

    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }

}
