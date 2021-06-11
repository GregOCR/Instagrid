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
    
    @IBAction func resetGridButton(_ sender: Any) {
        self.imagePicked = [0,0,0,0]
        
        let imageContainers = [self.gridImage1, self.gridImage2, self.gridImage3, self.gridImage4]
        imageContainers.forEach { $0!.image = nil}
    }
    
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
    
    private func captureTheGrid() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: gridGlobalView.bounds.size)
        let image = renderer.image { ctx in
            gridGlobalView.drawHierarchy(in: gridGlobalView.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    private func messagePopup(title: String, message: String, buttonString: String, asAlert: Bool, delay: Int) {
        var popupStyle: UIAlertController.Style = .alert
        if asAlert == false {
            popupStyle = .actionSheet
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: popupStyle)
        if delay != 0 {
            present(alert, animated: true)
            {
                sleep(UInt32(delay))
                alert.dismiss(animated: true)
            }
        } else {
            alert.addAction(UIAlertAction(title: buttonString, style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    private func loadImage(number: Int) {
        
        let imageContainers = [self.gridImage1, self.gridImage2, self.gridImage3, self.gridImage4]
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
        
        loadImageInView = imageContainers[number-1]
        actualPickedImage = number
    }
    
    var actualPickedImage = 0
    private var imagePicked = [0,0,0,0]
    
    var gridType = Int()
    
    func checkIfImagesArePickedIntoViews() -> Bool {
        var result = false
        var checkAdditionalImages = 0
        for i in 0...gridType-1 {
            checkAdditionalImages += imagePicked[i]
        }
        if checkAdditionalImages == gridType {
            result = true
        }
        return result
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.loadImageInView.contentMode = .scaleAspectFill
            self.loadImageInView.image = pickedImage
            self.imagePicked[actualPickedImage-1] = 1
        }
        dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateImagesPlacesForGrid(number: Int) {
        switch number {
        case 2:
            self.gridType = 3
            UIView.animate(withDuration: 0.25) {
                self.gridImage1button.frame.size = CGSize(width: 304, height: 148)
                self.gridImage1button.frame.origin.y = 164
                self.gridImage2button.frame.origin.x = 8
                self.gridImage2button.frame.origin.y = 8
                self.gridImage3button.frame.origin.x = 164
                self.gridImage3button.frame.origin.y = 8
                self.gridImage4.frame.size = CGSize(width: 0, height: 0)
                self.gridImage4button.frame.size = CGSize(width: 0, height: 0)
            }
        case 3:
            self.gridType = 4
            UIView.animate(withDuration: 0.25) {
                self.gridImage1button.frame.size = CGSize(width: 148, height: 148)
                self.gridImage1button.frame.origin.y = 8
                self.gridImage2button.frame.origin.x = 164
                self.gridImage2button.frame.origin.y = 8
                self.gridImage3button.frame.origin.x = 8
                self.gridImage3button.frame.origin.y = 164
                self.gridImage4.frame.size = CGSize(width: 148, height: 148)
                self.gridImage4button.frame.size = CGSize(width: 148, height: 148)
            }
        default:
            self.gridType = 3
            UIView.animate(withDuration: 0.25) {
                self.gridImage1button.frame.size = CGSize(width: 304, height: 148)
                self.gridImage1button.frame.origin.y = 8
                self.gridImage2button.frame.origin.x = 8
                self.gridImage2button.frame.origin.y = 164
                self.gridImage3button.frame.origin.x = 164
                self.gridImage3button.frame.origin.y = 164
                self.gridImage4.frame.size = CGSize(width: 0, height: 0)
                self.gridImage4button.frame.size = CGSize(width: 0, height: 0)
            }
        }
        updateImagesPosition()
        showAllGridSelectionButtons(but: number)
    }
    
    // resize and repositionning images as grid caneva
    private func updateImagesPosition() {
        let images = [self.gridImage1, self.gridImage2, self.gridImage3, self.gridImage4]
        let buttons = [self.gridImage1button, self.gridImage2button, self.gridImage3button, self.gridImage4button]
        
        for i in 0...3 {
            UIView.animate(withDuration: 0.25) {
                images[i]!.frame.size = buttons[i]!.frame.size
                images[i]!.frame.origin = buttons[i]!.frame.origin
            }
        }
    }
    
    private func showAllGridSelectionButtons(but button: Int) {
        let allSelectionButtons = [grid1SelectButton, grid2SelectButton, grid3SelectButton]
        
        allSelectionButtons.forEach { $0!.isHidden = false }
        
        allSelectionButtons[button-1]!.isHidden = true
    }
    
    // rotate objects when device direction changes
    override func viewWillLayoutSubviews() {
        let objectsToRotate = [self.instagridLogo, self.swapToShareLabel]
        if self.deviceOrientation.isPortrait == true {
            objectsToRotate.forEach { $0!.transform = .identity }
        } else {
            objectsToRotate.forEach { $0!.transform = CGAffineTransform(rotationAngle: -3.14/2) }
        }
    }
    
    // change the font for a text into an existing label
    private func changeFont(inLabel label: UILabel, forText text: String, withFont fontName: String, inSize fontSize: Int) {
        
        func getRangeOfSubString(subString: String, fromString: String) -> NSRange {
            let sampleLinkRange = fromString.range(of: subString)!
            let startPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.lowerBound)
            let endPos = fromString.distance(from: fromString.startIndex, to: sampleLinkRange.upperBound)
            let linkRange = NSMakeRange(startPos, endPos - startPos)
            return linkRange
        }
        
        let newAttributedText = NSMutableAttributedString(string: label.text!)
        
        newAttributedText.addAttributes([NSAttributedString.Key.font: UIFont(name: fontName, size: CGFloat(fontSize))!], range: getRangeOfSubString(subString: text, fromString: label.text!))
        
        label.attributedText = newAttributedText
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        switch gesture.direction {
        case .up:
            if deviceOrientation.isPortrait || (deviceOrientation.isLandscape == false && deviceOrientation.isPortrait == false) {
                shareTheGrid()
            }
        case .left:
            if deviceOrientation.isLandscape {
                shareTheGrid()
            }
        default:
            break
        }
    }
    
    private func shareTheGrid() {
        if self.checkIfImagesArePickedIntoViews() == true {
            let share = [captureTheGrid()]
            let activityViewController = UIActivityViewController(activityItems: share, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            messagePopup(title: "InstaOups!", message: "Votre InstaGrid ne semble pas complète !", buttonString: "Ahhh oui!", asAlert: true, delay: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.gridGlobalView.addGestureRecognizer(swipeLeft)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeUp.direction = .up
        self.gridGlobalView.addGestureRecognizer(swipeUp)
        
        changeFont(inLabel: self.swapToShareLabel, forText: "Insta", withFont: "ThirstySoftRegular", inSize: 18)
        
        // setup the default grid
        self.grid1SelectButton.isHidden = true
        updateImagesPlacesForGrid(number: 1)
        
        imagePicker.delegate = self
    }
}
