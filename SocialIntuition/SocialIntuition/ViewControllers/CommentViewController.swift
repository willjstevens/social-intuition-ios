//
//  CommentViewController.swift
//  SocialIntuition
//
//  Created by Will Stevens on 6/9/17.
//  Copyright © 2017 Social Intuition. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constraintToBottom: NSLayoutConstraint!
    
    private var intuitionService: IntuitionService = AppManager.appManager.intuitionService
    private var currentIntuitionDto: IntuitionDto?
    private var currentIntuitionCell: IntuitionCell2?
    private var currentLevel: String?
    private var commentDtos: [CommentDto]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 75
        tableView.rowHeight = UITableView.automaticDimension
        
        // chop off other rows in table
        self.tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.isTranslucent = false
        
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        sendButton.layer.cornerRadius = 2
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        // fetch it now
        setTransfers()
        setView()
        reset()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        // cleanup
        intuitionService.resetTransfers()
    }
    
    func setTransfers() {
        currentIntuitionDto = intuitionService.transferIntuitionDto
        currentIntuitionCell = intuitionService.transferIntuitionCell
        currentLevel = intuitionService.transferLevel
        
        if currentLevel == "intuition" {
            commentDtos = currentIntuitionDto?.commentDtos
        } else if currentLevel == "outcome" {
            commentDtos = currentIntuitionDto?.outcomeDto?.commentDtos
        }
    }
    
    func setView() {
        let commentCount = commentDtos!.count
        if commentCount == 0 {
            self.title = "Comment"
        } else if commentCount == 1 {
            self.title = "1 Comment"
        } else if commentCount >= 2 {
            self.title = "\(commentCount) Comments"
        }
    }
    
    func reset() {
        self.commentTextField.text = ""
        self.sendButton.isEnabled = false
        sendButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
    }
    
    func reloadAfterDelete(intuitionDto: IntuitionDto) {
        self.currentIntuitionCell?.loadIntuitionDto(intuitionDto)
        self.setTransfers()
        self.tableView.reloadData()
    }
    
    @objc func textFieldDidChange() {
        if let commentText = commentTextField.text, !commentText.isEmpty {
            sendButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
            sendButton.isEnabled = true
            return
        }
        sendButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        sendButton.isEnabled = false
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintToBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func sendButton_TouchUpInside(_ sender: Any) {
        let intuitionId = currentIntuitionDto?.intuition?.id
        intuitionService.addComment(commentTextField.text!, intuitionId: intuitionId!, completionHandler:  { (response: Response<IntuitionDto>) in
            let intuitionDto = response.data!
            self.currentIntuitionCell?.loadIntuitionDto(intuitionDto)
            self.reset()
            self.setTransfers()
            self.tableView.reloadData()
            self.view.endEditing(true)
        })
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (intuitionService.transferIntuitionDto?.commentDtos?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        let commentDto = commentDtos![indexPath.row]
        cell.loadComment(commentDto: commentDto, intuitionDto: currentIntuitionDto!, commentViewController: self)
        return cell
    }
}
