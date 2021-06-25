//
//  ViewController.swift
//  Instagrid
//
//  Created by Greg on 07/06/2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var instagridLogo: UILabel!
    
    @IBOutlet weak var arrowToShareLabel: UILabel!
    @IBOutlet weak var swipeToShareLabel: UILabel!
    
    @IBOutlet weak var gridBlankImage: UIImageView!
    @IBOutlet weak var gridGlobalView: UIView!
    
    @IBOutlet weak var grid1SelectButton: UIButton!
    @IBOutlet weak var grid2SelectButton: UIButton!
    @IBOutlet weak var grid3SelectButton: UIButton!
    
    @IBOutlet weak var checkedGridSelector1: UIImageView!
    @IBOutlet weak var checkedGridSelector2: UIImageView!
    @IBOutlet weak var checkedGridSelector3: UIImageView!
    
    @IBOutlet weak var gridImage1button: UIButton!
    @IBOutlet weak var gridImage2button: UIButton!
    @IBOutlet weak var gridImage3button: UIButton!
    @IBOutlet weak var gridImage4button: UIButton!
    
    @IBOutlet weak var gridImage1: UIImageView!
    @IBOutlet weak var gridImage2: UIImageView!
    @IBOutlet weak var gridImage3: UIImageView!
    @IBOutlet weak var gridImage4: UIImageView!
    
    @IBOutlet var logoLongPressGesture: UILongPressGestureRecognizer!
    
    
    private let imagePicker = UIImagePickerController()
    
    private var loadImageInView: UIImageView!
    
    private var pickingImage = 0
    private var imagePicked = [0,0,0,0]
    
    private var gridType = Int()
        
    private var cleanGridWhenSharedOption = true
    
    
    @IBAction func resetGridButton(_ sender: Any) {
        self.resetImagesIntoTheGrid()
        self.messagePopup(title: "Grid option", message: "Successfully cleared!", buttonString: "", asAlert: true, delay: 1)
    }
    
    @IBAction func grid1Selection(_ sender: Any) {
        self.gridSelection(1)
    }
    @IBAction func grid2Selection(_ sender: Any) {
        self.gridSelection(2)
    }
    @IBAction func grid3Selection(_ sender: Any) {
        self.gridSelection(3)
    }
    
    @IBAction func gridImage1Button(_ sender: Any) {
        self.loadImage(1)
    }
    @IBAction func gridImage2Button(_ sender: Any) {
        self.loadImage(2)
    }
    @IBAction func gridImage3Button(_ sender: Any) {
        self.loadImage(3)
    }
    @IBAction func gridImage4Button(_ sender: Any) {
        self.loadImage(4)
    }
    
    // switching the clear after shared grid option when long press the logo
    @IBAction func logoLongPressGestureGridOption(_ sender: Any) {
        if self.logoLongPressGesture.state == .began {
            var messagePopupText = ["🚫 OFF", "WILL NOT"]
            if self.cleanGridWhenSharedOption {
                self.cleanGridWhenSharedOption = false
            } else {
                self.cleanGridWhenSharedOption = true
                messagePopupText = ["✅ ON", "WILL"]
            }
            self.messagePopup(title: "Option \(messagePopupText[0])", message: "Grid \(messagePopupText[1]) be cleared after shared" , buttonString: "", asAlert: true, delay: 2)
        }
    }
    
    // managing the right gesture for the grid when swiped up / left depending the device orientation
    @objc func swipeGridGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if self.deviceOrientationIsPortrait() {
            if gesture.direction == .up {
                self.shareTheGrid()
            }
        } else {
            if gesture.direction == .left {
                self.shareTheGrid()
            }
        }
    }
    
    // bool if the device is in portrait orientation
    private func deviceOrientationIsPortrait() -> Bool {
        var result = true
        let size = UIScreen.main.bounds.size
        if size.width > size.height { result = false }
        return result
    }
        
    // create a message popup on the device
    private func messagePopup(title: String, message: String, buttonString: String, asAlert: Bool, delay: Int) {
        var popupStyle: UIAlertController.Style = .alert
        if asAlert == false {
            popupStyle = .actionSheet
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: popupStyle)
        if delay != 0 {
            present(alert, animated: true) {
                sleep(UInt32(delay))
                alert.dismiss(animated: true)
            }
        } else {
            alert.addAction(UIAlertAction(title: buttonString, style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    private func resetImagesIntoTheGrid() {
        // reset the imageSet inspector
        self.imagePicked = [0,0,0,0]
        
        let imageContainers = [self.gridImage1, self.gridImage2, self.gridImage3, self.gridImage4]
        let buttons = [self.gridImage1button, self.gridImage2button, self.gridImage3button, self.gridImage4button]
        
        imageContainers.forEach { $0?.image = nil }
        
        buttons.forEach { $0?.alpha = 1 }
    }
    
    private func loadImage(_ number: Int) {
        let imageContainers = [self.gridImage1, self.gridImage2, self.gridImage3, self.gridImage4]
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        
        present(self.imagePicker, animated: true, completion: nil)
        
        self.loadImageInView = imageContainers[number-1]
        self.pickingImage = number
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let buttons = [self.gridImage1button, self.gridImage2button, self.gridImage3button, self.gridImage4button]
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.loadImageInView.contentMode = .scaleAspectFill
            self.loadImageInView.image = pickedImage
            self.imagePicked[pickingImage-1] = 1
            
            buttons[self.pickingImage-1]?.alpha = 0.02
        }
        dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func checkIfAllImagesArePickedIntoTheGrid() -> Bool {
        var result = false
        var checkAdditionalImages = 0
        for i in 0...self.gridType-1 {
            checkAdditionalImages += self.imagePicked[i]
        }
        if checkAdditionalImages == self.gridType {
            result = true
        }
        return result
    }
    
    private func captureTheGrid() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.gridGlobalView.bounds.size)
        let image = renderer.image { ctx in
            self.gridGlobalView.drawHierarchy(in: self.gridGlobalView.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
    // select the clicked grid and show it in the main view
    private func gridSelection(_ grid: Int) {
        let gridButtonsSet = [self.grid1SelectButton, self.grid2SelectButton, self.grid3SelectButton]
        
        self.updateCheckedGridSelectorFor(grid)
        
        gridButtonsSet.forEach { $0?.isEnabled = true }
        gridButtonsSet[grid-1]?.isEnabled = false
        
        self.updateImagesLocationIntoGrid(number: grid)
    }
    
    private func defineSize(forViews views: [UIView], withWidth width: Int, withHeight height: Int) {
        views.forEach { $0.frame.size = CGSize(width: width, height: height) }
    }
    
    private func defineOriginX(forViews views: [UIView], withX xOrigin: CGFloat) {
        views.forEach { $0.frame.origin.x = xOrigin }
    }
    
    private func defineOriginY(forViews views: [UIView], withY yOrigin: CGFloat) {
        views.forEach { $0.frame.origin.y = yOrigin }
    }
    
    // updating the location and size of images button depending the selected grid
    private func updateImagesLocationIntoGrid(number: Int) {
        UIView.animate(withDuration: 0.25) {
            self.defineOriginX(forViews: [self.gridImage2button], withX: 8)
            self.defineOriginX(forViews: [self.gridImage3button], withX: 138)
            self.defineOriginY(forViews: [self.gridImage1button, self.gridImage2button], withY: 8)
            self.defineOriginY(forViews: [self.gridImage3button], withY: 138)
            self.defineSize(forViews: [self.gridImage1button], withWidth: 254, withHeight: 124)
            self.defineSize(forViews: [self.gridImage4button], withWidth: 0, withHeight: 0)
            
            switch number {
            case 2:
                self.gridType = 3
                self.defineOriginY(forViews: [self.gridImage1button], withY: 138)
                self.defineOriginY(forViews: [self.gridImage3button], withY: 8)
            case 3:
                self.gridType = 4
                self.defineSize(forViews: [self.gridImage1button, self.gridImage4button], withWidth: 124, withHeight: 124)
                self.defineOriginX(forViews: [self.gridImage2button], withX: 138)
                self.defineOriginX(forViews: [self.gridImage3button], withX: 8)
            default:
                self.gridType = 3
                self.defineOriginY(forViews: [self.gridImage2button], withY: 138)
            }
        }
        self.updateImagesPositionAndSize()
    }
    
    // updating the location and size of images as images buttons are
    private func updateImagesPositionAndSize() {
        let images = [self.gridImage1, self.gridImage2, self.gridImage3, self.gridImage4]
        let buttons = [self.gridImage1button, self.gridImage2button, self.gridImage3button, self.gridImage4button]
        
        for i in 0...3 {
            UIView.animate(withDuration: 0.25) {
                images[i]?.frame.size = (buttons[i]?.frame.size) ?? CGSize()
                images[i]?.frame.origin = (buttons[i]?.frame.origin) ?? CGPoint()
            }
        }
    }
    
    // switching the selected grid icon depending the selected grid
    private func updateCheckedGridSelectorFor(_ grid: Int) {
        let checkedGridSelectors = [self.checkedGridSelector1, self.checkedGridSelector2, self.checkedGridSelector3]
        checkedGridSelectors.forEach { $0?.isHidden = true }
        checkedGridSelectors[grid-1]?.isHidden = false
    }
    
    private func shareTheGrid() {
        if self.checkIfAllImagesArePickedIntoTheGrid() {
            UIView.animate(withDuration: TimeInterval(1)) {
                if self.deviceOrientationIsPortrait() {
                    self.gridGlobalView.frame.origin.y = -UIScreen.main.bounds.size.height
                } else {
                    self.gridGlobalView.frame.origin.x = -UIScreen.main.bounds.size.width
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(1)) {
                let share = [self.captureTheGrid()]
                let activityViewController = UIActivityViewController(activityItems: share, applicationActivities: nil)
                activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
                    UIView.animate(withDuration: TimeInterval(1)) {
                        if self.cleanGridWhenSharedOption {
                            self.resetImagesIntoTheGrid()
                        }
                        self.gridGlobalView.frame.origin = self.gridBlankImage.frame.origin
                    }
                }
                activityViewController.popoverPresentationController?.sourceView = self.view
                self.present(activityViewController, animated: true, completion: nil)
            }
        } else { // vibrating and messaging when the grid is not filled
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.messagePopup(title: "Action request", message: "You need to fill your Instagrid before to share!", buttonString: "OK", asAlert: true, delay: 0)
        }
    }
    
    // change the text and alignment of the grid text
    private func changeSharingLabelTexts(forFirst text1: String, withAlignement alignText1: NSTextAlignment, firSecond text2: String) {
        self.arrowToShareLabel.text = text1
        self.arrowToShareLabel.textAlignment = alignText1
        self.swipeToShareLabel.text = text2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let swipeLeftGrid = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGridGesture))
        swipeLeftGrid.direction = .left
        self.gridGlobalView.addGestureRecognizer(swipeLeftGrid)
        
        let swipeUpGrid = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeGridGesture))
        swipeUpGrid.direction = .up
        self.gridGlobalView.addGestureRecognizer(swipeUpGrid)
        
        self.imagePicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // setup the default grid
        self.gridSelection(1)
    }
    
    override func viewDidLayoutSubviews() {
        if deviceOrientationIsPortrait() {
            self.changeSharingLabelTexts(forFirst: "▲", withAlignement: .center, firSecond: "SWIPE UP TO SHARE")
        } else {
            self.changeSharingLabelTexts(forFirst: "◀︎", withAlignement: .right, firSecond: "SWIPE LEFT TO SHARE")
        }
    }
    
}
