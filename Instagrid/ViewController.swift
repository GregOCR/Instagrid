//
//  ViewController.swift
//  Instagrid
//
//  Created by Greg on 07/06/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var instagridLogo: UILabel!
    @IBOutlet weak var swapToShareLabel: UILabel!
    
    @IBOutlet weak var gridGlobalView: UIView!
    
    @IBOutlet weak var grid1SelectButton: UIButton!
    @IBOutlet weak var grid2SelectButton: UIButton!
    @IBOutlet weak var grid3SelectButton: UIButton!
    
    @IBOutlet weak var gridImage1button: UIButton!
    @IBOutlet weak var gridImage2button: UIButton!
    @IBOutlet weak var gridImage3button: UIButton!
    @IBOutlet weak var gridImage4button: UIButton!
    
    @IBOutlet weak var gridImage1: UIImageView!
    @IBOutlet weak var gridImage2: UIImageView!
    @IBOutlet weak var gridImage3: UIImageView!
    @IBOutlet weak var gridImage4: UIImageView!
    
    private var deviceOrientation: UIDeviceOrientation {
        get {
            return UIDevice.current.orientation
        }
    }
    
    private let imagePicker = UIImagePickerController()
    private var loadImageInView: UIImageView!
    
    @IBAction func grid1Selection(_ sender: Any) {
        updateImagesPlacesForGrid(number: 1)
    }
    
    @IBAction func grid2Selection(_ sender: Any) {
        updateImagesPlacesForGrid(number: 2)
    }
    
    @IBAction func grid3Selection(_ sender: Any) {
        updateImagesPlacesForGrid(number: 3)
    }
    
    @IBAction func gridImage1Button(_ sender: Any) {
        loadImage(number: 1)
    }
    @IBAction func gridImage2Button(_ sender: Any) {
        loadImage(number: 2)
    }
    @IBAction func gridImage3Button(_ sender: Any) {
        loadImage(number: 3)
    }
    @IBAction func gridImage4Button(_ sender: Any) {
        loadImage(number: 4)
    }
    
    private func loadImage(number: Int) {
        
        let imageContainers = [self.gridImage1, self.gridImage2, self.gridImage3, self.gridImage4]
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
        loadImageInView = imageContainers[number-1]
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.loadImageInView.contentMode = .scaleAspectFill
            self.loadImageInView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateImagesPlacesForGrid(number: Int) {
        switch number {
        case 2:
            self.gridImage1button.frame.size = CGSize(width: 304, height: 148)
            self.gridImage1button.frame.origin.y = 164
            self.gridImage2button.frame.origin.x = 8
            self.gridImage2button.frame.origin.y = 8
            self.gridImage3button.frame.origin.x = 164
            self.gridImage3button.frame.origin.y = 8
            self.gridImage4button.isHidden = true
            self.gridImage4.isHidden = true
        case 3:
            self.gridImage1button.frame.size = CGSize(width: 148, height: 148)
            self.gridImage1button.frame.origin.y = 8
            self.gridImage2button.frame.origin.x = 164
            self.gridImage2button.frame.origin.y = 8
            self.gridImage3button.frame.origin.x = 8
            self.gridImage3button.frame.origin.y = 164
            self.gridImage4button.isHidden = false
            self.gridImage4.isHidden = false
        default:
            self.gridImage1button.frame.size = CGSize(width: 304, height: 148)
            self.gridImage1button.frame.origin.y = 8
            self.gridImage2button.frame.origin.x = 8
            self.gridImage2button.frame.origin.y = 164
            self.gridImage3button.frame.origin.x = 164
            self.gridImage3button.frame.origin.y = 164
            self.gridImage4button.isHidden = true
            self.gridImage4.isHidden = true
        }
        updateImagesPosition()
        showAllGridSelectionButtons(but: number)
    }
    
    // resize and repositionning images as grid caneva
    private func updateImagesPosition() {
        let images = [self.gridImage1, self.gridImage2, self.gridImage3, self.gridImage4]
        let buttons = [self.gridImage1button, self.gridImage2button, self.gridImage3button, self.gridImage4button]
        
        for i in 0...3 {
            images[i]!.frame.size = buttons[i]!.frame.size
            images[i]!.frame.origin = buttons[i]!.frame.origin
        }
    }
    
    private func showAllGridSelectionButtons(but button: Int) {
        let allSelectionButtons = [grid1SelectButton, grid2SelectButton, grid3SelectButton]
        
        allSelectionButtons.forEach { $0!.isHidden = false }
        
        allSelectionButtons[button-1]!.isHidden = true
    }
    
    // rotate objects when device direction changes
    //    override func viewWillLayoutSubviews() {
    //        let objectsToRotate = [self.instagridLogo, self.swapToShareLabel]
    //        if self.deviceOrientation.isPortrait == true {
    //            objectsToRotate.forEach { $0!.transform = .identity }
    //        } else {
    //            objectsToRotate.forEach { $0!.transform = CGAffineTransform(rotationAngle: -3.14/2) }
    //            self.swapToShareLabel.frame.size = CGSize(width: 15, height: 320)
    //        }
    //    }
    
    override func viewDidLoad() {
        self.grid1SelectButton.isHidden = true
        updateImagesPlacesForGrid(number: 1)
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        
    }
    
    
}

