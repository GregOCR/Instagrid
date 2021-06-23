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
    
    private var globalViewOrigin = CGPoint()
    
    private var cleanGridWhenSharedOption = false
    
    
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
    
    @IBAction func logoLongPressGestureGridOption(_ sender: Any) {
        if self.logoLongPressGesture.state == .began {
            var messagePopupText = "OFF"
            if self.cleanGridWhenSharedOption {
                self.cleanGridWhenSharedOption = false
            } else {
                self.cleanGridWhenSharedOption = true
                messagePopupText = "ON"
            }
            self.messagePopup(title: "Clear the Grid after shared", message: messagePopupText , buttonString: "", asAlert: false, delay: 2)
        }
        

    }
    
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
    
    
    private func deviceOrientationIsPortrait() -> Bool {
        var result = true
        let size = UIScreen.main.bounds.size
        if size.width > size.height { result = false }
        return result
    }
    
    private func updateGlobalViewOrigin() {
        self.globalViewOrigin = self.gridGlobalView.frame.origin
    }
    
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

        imageContainers.forEach { $0!.image = nil}
        
        buttons.forEach { $0!.alpha = 1 }
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
            
            buttons[self.pickingImage-1]!.alpha = 0.02
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
    
    private func gridSelection(_ grid: Int) {
        let gridButtonsSet = [self.grid1SelectButton, self.grid2SelectButton, self.grid3SelectButton]
        
        self.updateCheckedGridSelectorFor(grid)
        
        gridButtonsSet.forEach { $0!.isEnabled = true }
        gridButtonsSet[grid-1]!.isEnabled = false
        
        self.updateImagesLocationIntoGrid(number: grid)
    }
    
    private func updateImagesLocationIntoGrid(number: Int) {
        UIView.animate(withDuration: 0.25) {
            self.gridImage1button.frame.size = CGSize(width: 254, height: 124)
            self.gridImage1button.frame.origin.y = 8
            self.gridImage2button.frame.origin.x = 8
            self.gridImage2button.frame.origin.y = 8
            self.gridImage3button.frame.origin.x = 138
            self.gridImage3button.frame.origin.y = 138
            self.gridImage4.frame.size = CGSize(width: 0, height: 0)
            self.gridImage4button.frame.size = CGSize(width: 0, height: 0)
        }
        switch number {
        case 2:
            self.gridType = 3
            UIView.animate(withDuration: 0.25) {
                self.gridImage1button.frame.origin.y = 138
                self.gridImage3button.frame.origin.y = 8
            }
        case 3:
            self.gridType = 4
            UIView.animate(withDuration: 0.25) {
                self.gridImage1button.frame.size = CGSize(width: 124, height: 124)
                self.gridImage2button.frame.origin.x = 138
                self.gridImage3button.frame.origin.x = 8
                self.gridImage4.frame.size = CGSize(width: 124, height: 124)
                self.gridImage4button.frame.size = CGSize(width: 124, height: 124)
            }
        default:
            self.gridType = 3
            UIView.animate(withDuration: 0.25) {
                self.gridImage2button.frame.origin.y = 138
            }
        }
        self.updateImagesPositionAndSize()
    }
    
    // repositionning and resizing images into the grid as selected
    private func updateImagesPositionAndSize() {
        let images = [self.gridImage1, self.gridImage2, self.gridImage3, self.gridImage4]
        let buttons = [self.gridImage1button, self.gridImage2button, self.gridImage3button, self.gridImage4button]
        
        for i in 0...3 {
            UIView.animate(withDuration: 0.25) {
                images[i]!.frame.size = buttons[i]!.frame.size
                images[i]!.frame.origin = buttons[i]!.frame.origin
            }
        }
    }
    
    private func updateCheckedGridSelectorFor(_ grid: Int) {
        let checkedGridSelectors = [self.checkedGridSelector1, self.checkedGridSelector2, self.checkedGridSelector3]
        checkedGridSelectors.forEach { $0!.isHidden = true }
        checkedGridSelectors[grid-1]!.isHidden = false
    }
    
    private func shareTheGrid() {
        if self.checkIfAllImagesArePickedIntoTheGrid() {
            self.goAndAppearAgain(forView: self.gridGlobalView, duration: 1)
            let share = [self.captureTheGrid()]
            let activityViewController = UIActivityViewController(activityItems: share, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.messagePopup(title: "Action request", message: "You need to fill your Instagrid before to share!", buttonString: "OK", asAlert: true, delay: 0)
        }
    }
    
    // animate and let appear a new grid when sharing
    private func goAndAppearAgain(forView view: UIView, duration: Int) {
        // animate the grid
        if self.deviceOrientationIsPortrait() {
            UIView.animate(withDuration: TimeInterval(duration)) {
                view.frame.origin.y = -UIScreen.main.bounds.size.height
            }
        } else {
            UIView.animate(withDuration: TimeInterval(duration)) {
                view.frame.origin.x = -UIScreen.main.bounds.size.width
            }
        }
        // grid appear again with images reset
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(duration)) {
            if self.cleanGridWhenSharedOption {
                self.resetImagesIntoTheGrid()
            }
            view.alpha = 0
            view.frame.origin = self.globalViewOrigin
            UIView.animate(withDuration: TimeInterval(duration*2)) {
                view.alpha = 1
            }
        }
    }
    
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
        
        self.updateGlobalViewOrigin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        // setup the default grid
        self.gridSelection(1)
    }
    
    override func viewDidLayoutSubviews() {
        self.updateGlobalViewOrigin()
        
        if deviceOrientationIsPortrait() {
            self.changeSharingLabelTexts(forFirst: "▲", withAlignement: .center, firSecond: "SWIPE UP TO SHARE")
        } else {
            self.changeSharingLabelTexts(forFirst: "◀︎", withAlignement: .right, firSecond: "SWIPE LEFT TO SHARE")
        }
    }
    
}