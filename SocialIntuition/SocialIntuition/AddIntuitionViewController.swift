//
//  AddIntuitionViewController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 4/8/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit
import SwiftSpinner

class AddIntuitionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate
{

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var intuitionText: UITextView!
    @IBOutlet weak var predictedTypeTitle: UILabel!
    @IBOutlet weak var predictedOutcomeType: UISegmentedControl!
    @IBOutlet weak var predictedOutcomeLabel: UILabel!
    @IBOutlet weak var selectPredictedOutcomeButton: UIButton!
    @IBOutlet weak var predictedOutcome: UIPickerView!
    @IBOutlet weak var multipleChoiceStaceView: UIStackView!
    @IBOutlet weak var outcomeChoicesLabel: UILabel!
    @IBOutlet weak var outcomeChoiceAddedLabel: UILabel!
    @IBOutlet weak var outcomeChoiceTextfield: UITextField!
    @IBOutlet weak var addOutcomeChoiceButton: UIButton!
    @IBOutlet weak var visibility: UISegmentedControl!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var scoreIntuition: UISwitch!
    @IBOutlet weak var displayPrediction: UISwitch!
    @IBOutlet weak var allowPredictedOutcomeVoting: UISwitch!
    @IBOutlet weak var allowCohortsToContributePredictedOutcomes: UISwitch!
    @IBOutlet weak var selectActiveWindowButton: UIButton!
    @IBOutlet weak var activeWindowPicker: UIPickerView!
    @IBOutlet weak var addIntuitionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var optionsStackView: UIStackView!
    @IBOutlet weak var scoreIntuitionStackView: UIStackView!
    @IBOutlet weak var displayPredictionStackView: UIStackView!
    @IBOutlet weak var allowPredictedOutcomeStackView: UIStackView!
    @IBOutlet weak var allowCohortsContributionStackView: UIStackView!
    @IBOutlet weak var intuitionRequiredError: UILabel!
    @IBOutlet weak var predictedOutcomeRequiredError: UILabel!
    @IBOutlet weak var activeWindowRequiredError: UILabel!
    
    var appManager = AppManager.appManager
    var newIntuitionSettings: NewIntuitionDto?
    var predictionChoices: [Outcome] = []
    var activeWindows: [ActiveWindow] = []
    var multipleChoicePredictionChoices: [Outcome] = []
    var selectedImage: UIImage?
    
    var intuition: Intuition! = Intuition()
    var submitButtonAttempted: Bool = false
    var isPredictedOutcomeSet: Bool = false
    var isActiveWindowSet: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appManager.intuitionService.getNewIntuitionSettings(completionHandler: { (newIntuitionSettings: NewIntuitionDto) -> ()
            in
            self.newIntuitionSettings = newIntuitionSettings
            self.setDefaults()
        })
        
        // Do any additional setup after loading the view.
        initializeView()
        resetView()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap() {
        intuitionText.resignFirstResponder() // loosing focus
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if intuitionText.isFirstResponder && touch.view != intuitionText {
                intuitionText.resignFirstResponder()
            }
        }
        super.touchesBegan(touches, with: event)
    }
    

    private func initializeView() {
        intuitionText.delegate = self
        predictedOutcome.dataSource = self
        predictedOutcome.delegate = self
        activeWindowPicker.dataSource = self
        activeWindowPicker.delegate = self
        
        intuitionText.layer.borderWidth = 0.6
        intuitionText.layer.cornerRadius = 1
        intuitionText.layer.borderColor = UIColor.lightGray.cgColor
        intuitionText.returnKeyType = UIReturnKeyType.done
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleSelectPhoto))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
        
        optionsButton.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.right
    }
    
    private func resetView() {
        intuitionText.text = ""
        submitButtonAttempted = false
        isPredictedOutcomeSet = false
        isActiveWindowSet = false
        
        predictedOutcome.isHidden = true
        activeWindowPicker.isHidden = true
        
        selectPredictedOutcomeButton.setTitle("Select", for: .normal)
        selectActiveWindowButton.setTitle("Select", for: .normal)
        
        resetMessageFields()
        hideOptionsStack()
        
        intuition = Intuition()
    }
    
    private func setDefaults() {
        let settings = newIntuitionSettings!
        
        predictedOutcomeType.selectedSegmentIndex = PredictionType.toIndex(settings.defaultPredictionType!)
        visibility.selectedSegmentIndex = Visibility.toIndex(settings.defaultVisibility!)
        imageView.image = #imageLiteral(resourceName: "Placeholder-image")
        selectedImage = nil
        multipleChoicePredictionChoices.removeAll()
        setPredictionType()
        
        scoreIntuition.setOn(settings.scoreIntuition!, animated: false)
        displayPrediction.setOn(settings.displayPrediction!, animated: false)
        allowPredictedOutcomeVoting.setOn(settings.allowPredictedOutcomeVoting!, animated: false)
        allowCohortsToContributePredictedOutcomes.setOn(settings.allowCohortsToContributePredictedOutcomes!, animated: false)
    }
    
    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    private func validate() -> Bool {
        var isValid: Bool = false
        disableSubmit()
        resetMessageFields()
        
        let isIntuitionTextValid = !intuitionText.text.isEmpty
        
        if isIntuitionTextValid && isPredictedOutcomeSet && isActiveWindowSet {
            isValid = true
            enableSubmit()
        } else {
            if !isIntuitionTextValid {
                intuitionRequiredError.isHidden = false
            }
            if !isPredictedOutcomeSet {
                predictedOutcomeRequiredError.isHidden = false
            }
            if !isActiveWindowSet {
                activeWindowRequiredError.isHidden = false
            }
        }
        
        return isValid
    }
    
    
    @IBAction func submitAddIntuition(_ sender: Any) {
        submitButtonAttempted = true
        
        let isValid = validate()
        
        if isValid {
            SwiftSpinner.show("Intuition posting...")
            
            intuition.intuitionText = intuitionText.text
            intuition.predictionType = PredictionType.toKey(predictedOutcomeType.selectedSegmentIndex)
            intuition.visibility = Visibility.toKey(visibility.selectedSegmentIndex)
            setPotentialOutcomes()
            
            // options
            intuition.scoreIntuition = scoreIntuition.isOn
            intuition.displayPrediction = displayPrediction.isOn
            intuition.allowPredictedOutcomeVoting = allowPredictedOutcomeVoting.isOn
            intuition.allowCohortsToContributePredictedOutcomes = allowCohortsToContributePredictedOutcomes.isOn
            
            var submittedImg: UIImage? = nil
            if let img = selectedImage {
                submittedImg = img
            }
            let intuitionService = appManager.intuitionService
            intuitionService.addIntuition(intuition, image: submittedImg, fileName: "ios.jpg", postWithUploadCompletionHandler: { (response: Response<IntuitionDto>) -> ()
                in
                
                self.resetView()
                self.setDefaults()
                
                SwiftSpinner.hide()
                
                // tab to news feed and display new intuition (with highlighting effect)
                // transfer intuition over then tab over to activity feed
                intuitionService.transferIntuitionDto = response.data
                intuitionService.transferIntuition = response.data?.intuition!
                intuitionService.transferAction = .ScrollToForIntuition
                intuitionService.transferFrom = .AddIntuition
                self.appManager.applicationService.navigateTo(tabBarTab: .ActivityFeedTab)
            })
        }
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        resetView()
    }
    
    
    private func resetMessageFields() {
        intuitionRequiredError.isHidden = true
        predictedOutcomeRequiredError.isHidden = true
        activeWindowRequiredError.isHidden = true
        outcomeChoiceAddedLabel.isHidden = true
    }
    
    
    @IBAction func selectPredictedOutcome(_ sender: Any) {
        let predictedOutcomeHidden = predictedOutcome.alpha == 0.0
        if predictedOutcomeHidden {
            self.animate(subject: showPredictedOutcome)
        } else {
            self.animate(subject: hidePredictedOutcome)
        }
    }
    
    @IBAction func selectActiveWindow(_ sender: Any) {
        let activeWindowPickerHidden = activeWindowPicker.alpha == 0.0
        if activeWindowPickerHidden {
            self.animate(subject: showActiveWindowPicker)
            scrollView.scrollToView(view: optionsStackView, animated: true)
        } else {
            self.animate(subject: hideActiveWindowPicker)
        }
    }
    
    @IBAction func optionsButton_touchUpInside(_ sender: Any) {
        let areOptionsHidden = optionsStackView.alpha == 0.0
        if areOptionsHidden {
            showOptionsStack()
            scrollView.scrollToView(view: predictedTypeTitle, animated: true)
        } else {
            hideOptionsStack()
            scrollView.scrollToTop(animated: true)
        }
    }
    
    @IBAction func predictionTypeChanged(_ sender: Any) {
        setPredictionType()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if submitButtonAttempted {
            _ = validate()
        }
        
//        textView.endEditing(true)
    }

    
    // hides text views
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    private func setPredictionType() {
        hideAddOutcomeChoicesStack()
        allowCohortsContributionStackView.isHidden = true
        selectPredictedOutcomeButton.setTitle("Select", for: .normal)
        intuition.predictedOutcome = nil
        let selectedIndex = predictedOutcomeType.selectedSegmentIndex
        if selectedIndex == 0 {
            predictedTypeTitle.text = "Prediction Type - True / False"
        } else if selectedIndex == 1 {
            predictedTypeTitle.text = "Prediction Type - Yes / No"
        } else if selectedIndex == 2 {
            predictedTypeTitle.text = "Prediction Type - Multiple Choice"
            showAddOutcomeChoicesStack()
            animate {
                self.multipleChoiceStaceView.alpha = 1
                self.multipleChoiceStaceView.isHidden = false
            }
        }
    }
    
    private func setPotentialOutcomes() {
        let selectedIndex = predictedOutcomeType.selectedSegmentIndex
        if selectedIndex == 0 {
            if let settings = newIntuitionSettings {
                intuition.potentialOutcomes = settings.predictionChoicesTrueFalse!
            }
        } else if selectedIndex == 1 {
            if let settings = newIntuitionSettings {
                intuition.potentialOutcomes = settings.predictionChoicesYesNo!
            }
        } else if selectedIndex == 2 {
            intuition.potentialOutcomes = multipleChoicePredictionChoices
        }
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        var numOfRows = 0
        if let settings = newIntuitionSettings {
            if pickerView == predictedOutcome {
                let selectedIndex = predictedOutcomeType.selectedSegmentIndex
                if selectedIndex == 0 {
                    numOfRows = settings.predictionChoicesTrueFalse!.count
                } else if selectedIndex == 1 {
                    numOfRows = settings.predictionChoicesYesNo!.count
                } else if selectedIndex == 2 {
                    numOfRows = multipleChoicePredictionChoices.count
                }
            } else if pickerView == activeWindowPicker {
                numOfRows = settings.activeWindows!.count
            }
        }
        return numOfRows
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = view as? UILabel
        if label == nil {
            label = UILabel()
        }
        
        var title = "Uninitialized"
        let settings = newIntuitionSettings!
        if pickerView == predictedOutcome {
            let selectedIndex = predictedOutcomeType.selectedSegmentIndex
            if selectedIndex == 0 {
                title = settings.predictionChoicesTrueFalse![row].predictionText!
            } else if selectedIndex == 1 {
                title = settings.predictionChoicesYesNo![row].predictionText!
            } else if selectedIndex == 2 {
                title = multipleChoicePredictionChoices[row].predictionText!
            }
        } else if pickerView == activeWindowPicker {
            title = settings.activeWindows![row].code!
        }
        
        let nsTitle = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.regular)])
        label?.attributedText = nsTitle
        label?.textAlignment = .center
        return label!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 26.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let settings = newIntuitionSettings!
        if pickerView == predictedOutcome {
            let selectedIndex = predictedOutcomeType.selectedSegmentIndex
            if selectedIndex == 0 {
                intuition.predictedOutcome = settings.predictionChoicesTrueFalse![row]
            } else if selectedIndex == 1 {
                intuition.predictedOutcome = settings.predictionChoicesYesNo![row]
            } else if selectedIndex == 2 {
                intuition.predictedOutcome = multipleChoicePredictionChoices[row]
            }
            self.animate(subject: hidePredictedOutcome)
        self.selectPredictedOutcomeButton.setTitle(intuition.predictedOutcome!.predictionText, for: .normal)
            self.selectPredictedOutcomeButton.setTitleColor(.darkGray, for: UIControl.State.normal)
            self.isPredictedOutcomeSet = true
        } else if pickerView == activeWindowPicker {
            let activeWindow = settings.activeWindows![row]
            intuition.activeWindow = activeWindow.text! // this is really the code - things got inversed somehow...
            self.animate(subject: hideActiveWindowPicker)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.hideOptionsStack()
                self.scrollView.scrollToTop(animated: true)
            }
            
            self.selectActiveWindowButton.setTitle(activeWindow.code!, for: .normal)
            self.selectActiveWindowButton.setTitleColor(.darkGray, for: UIControl.State.normal)
            self.isActiveWindowSet = true
        }
        
        if submitButtonAttempted {
            _ = validate()
        }
    }
    
    @IBAction func addOutcome_touchUpInside(_ sender: Any) {
        let outcome = Outcome()
        outcome.predictionText = outcomeChoiceTextfield.text
        multipleChoicePredictionChoices.append(outcome)
        outcomeChoiceTextfield.text = ""
        
        self.animate {
            self.outcomeChoiceAddedLabel.alpha = 1
            self.outcomeChoiceAddedLabel.isHidden = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.animate {
                self.outcomeChoiceAddedLabel.alpha = 0
                self.outcomeChoiceAddedLabel.isHidden = true
            }
        }
    }
    
    private func animate(subject: @escaping () -> () ) {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            subject()
        }, completion: {_ in
        })
    }
    
    private func animateWithDelay(delay: TimeInterval, subject: @escaping () -> () ) {
        UIView.animate(withDuration: 0.25, delay: delay, options: UIView.AnimationOptions.curveEaseOut, animations: {
            subject()
        }, completion: {_ in
        })
    }
    
    private func showOptionsStackDependencies() {
        self.scoreIntuitionStackView.isHidden = false
        self.displayPredictionStackView.isHidden = false
        self.allowPredictedOutcomeStackView.isHidden = false
        if PredictionType.toIndex("multiple-choice") == predictedOutcomeType.selectedSegmentIndex {
            self.allowCohortsContributionStackView.isHidden = false
        }
//        self.optionsSpacer.isHidden = false
    }
    
    private func showOptionsStack() {
        showOptionsStackDependencies()
        
        self.optionsStackView.alpha = 1
        self.optionsStackView.isHidden = false
        self.optionsStackView.layoutIfNeeded()
    }
    
    private func hideOptionsStackDependencies() {
        self.scoreIntuitionStackView.isHidden = true
        self.displayPredictionStackView.isHidden = true
        self.allowPredictedOutcomeStackView.isHidden = true
        self.allowCohortsContributionStackView.isHidden = true
//        self.optionsSpacer.isHidden = true
    }
    
    private func hideOptionsStack() {
        hideOptionsStackDependencies()
        
        self.optionsStackView.alpha = 0.0
        self.optionsStackView.isHidden = true
        self.optionsStackView.layoutIfNeeded()
    }
    
    private func hideAddOutcomeChoicesStack() {
        outcomeChoicesLabel.isHidden = true
        outcomeChoiceAddedLabel.isHidden = true
        outcomeChoiceTextfield.isHidden = true
        addOutcomeChoiceButton.isHidden = true
    
        multipleChoiceStaceView.alpha = 0.0
        multipleChoiceStaceView.isHidden = true
        multipleChoiceStaceView.layoutIfNeeded()
    }
    
    private func showAddOutcomeChoicesStack() {
        outcomeChoicesLabel.isHidden = false
        outcomeChoiceAddedLabel.isHidden = false
        outcomeChoiceTextfield.isHidden = false
        addOutcomeChoiceButton.isHidden = false
        
        multipleChoiceStaceView.alpha = 1.0
        multipleChoiceStaceView.isHidden = false
        multipleChoiceStaceView.layoutIfNeeded()
    }
    
    private func showPredictedOutcome() {
        self.predictedOutcome.alpha = 1
        self.predictedOutcome.isHidden = false
        self.predictedOutcome.layoutIfNeeded()
    }
    
    private func hidePredictedOutcome() {
        self.predictedOutcome.alpha = 0.0
        self.predictedOutcome.isHidden = true
        self.predictedOutcome.layoutIfNeeded()
    }
    
    private func showActiveWindowPicker() {
        self.activeWindowPicker.alpha = 1
        self.activeWindowPicker.isHidden = false
        self.activeWindowPicker.layoutIfNeeded()
    }
    
    private func hideActiveWindowPicker() {
        self.activeWindowPicker.alpha = 0.0
        self.activeWindowPicker.isHidden = true
        self.activeWindowPicker.layoutIfNeeded()
    }
    
    private func enableSubmit() {
        addIntuitionButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        addIntuitionButton.isEnabled = true
    }
    
    private func disableSubmit() {
        addIntuitionButton.setTitleColor(UIColor.lightText, for: UIControl.State.normal)
        addIntuitionButton.isEnabled = false
    }
    

}

extension AddIntuitionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imageView.image = image
            selectedImage = image
        }
        dismiss(animated: true, completion: nil)
    }
}

// from solution: http://stackoverflow.com/questions/39018017/programmatically-scroll-a-uiscrollview-to-the-top-of-a-child-uiview-subview-in
extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view: UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.setContentOffset(CGPoint(x: 0, y: (childStartPoint.y)), animated: animated)        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }
    
//    // Bonus: Scroll to bottom
//    func scrollToBottom() {
//        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
//        if(bottomOffset.y > 0) {
//            setContentOffset(bottomOffset, animated: true)
//        }
//    }
    
}

