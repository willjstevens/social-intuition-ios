//
//  IntuitionService.swift
//  SocialIntuition
//
//  Created by Will Stevens on 2/2/17.
//  Copyright © 2017 Will Stevens. All rights reserved.
//

import Foundation
import UIKit

class IntuitionService {
    var session: Session
    var httpClient: HttpClient
    var newIntuitionSettings: NewIntuitionDto?
    var lastUpdateTimestamp: String?
    
    // NOTE: temp work around until segue bug is fixed
    //      Bug filed: https://bugreport.apple.com/web/?problemID=32746982
    var transferIntuitionDto: IntuitionDto?
    var transferIntuition: Intuition?
    var transferIntuitionCell: IntuitionCell2?
    var transferParentDto: Any?
    var transferLevel: String?
    var transferType: String?
    var transferUsername: String?
    var transferAction: TransferAction?
    var transferFrom: TransferFrom?
    
    init(_ session: Session, _ httpClient: HttpClient) {
        self.session = session
        self.httpClient = httpClient
    }
    
    func resetTransfers() {
        transferIntuitionDto = nil
        transferIntuition = nil
        transferIntuitionCell = nil
        transferParentDto = nil
        transferLevel = "intuition"
        transferType = "likes"
        transferUsername = nil
        transferAction = nil
        transferFrom = nil
    }
    
    func getNewIntuitionSettings(completionHandler: @escaping ((NewIntuitionDto)->())) {
        
        // fetch only if not loaded yet
        if newIntuitionSettings == nil {
            httpClient.get("/intuition/new-intuition-settings", completionHandler: { (response: Response<NewIntuitionDto>) -> () in
                let newIntuitionDto = response.data!
                self.newIntuitionSettings = newIntuitionDto
                completionHandler(newIntuitionDto)
            })
        } else { // otherwise load from cache
            completionHandler(newIntuitionSettings!)
        }
    }
    
    func fetchTopIntuition(completionHandler: @escaping ((Response<IntuitionDto>)->())) {
        // fetch only top intuition
        httpClient.get("/intuition/fetch/top", completionHandler: { (response: Response<IntuitionDto>) -> () in
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func fetchIntuitionsForActivityFeed(start: Int, quantity: Int, completionHandler: @escaping ((ResponseWithArray<IntuitionDto>)->())) {
        let getUrl = "/intuition/fetch/activity?start=\(start)&quantity=\(quantity)"
        // fetch only top intuition
        httpClient.getArray(getUrl, completionHandler: { (response: ResponseWithArray<IntuitionDto>) -> () in
            self.lastUpdateTimestamp = response.lastUpdateTimestamp
//            print(self.lastUpdateTimestamp)
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func fetchIntuitionsForProfileUser(username: String, start: Int, quantity: Int, completionHandler: @escaping ((ResponseWithArray<IntuitionDto>)->())) {
        let getUrl = "/intuition/fetch/profile/\(username)/?start=\(start)&quantity=\(quantity)"
        // fetch only top intuition
        httpClient.getArray(getUrl, completionHandler: { (response: ResponseWithArray<IntuitionDto>) -> () in
            self.lastUpdateTimestamp = response.lastUpdateTimestamp
            //            print(self.lastUpdateTimestamp)
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func fetchIntuitionsSinceLastUpdate(completionHandler: @escaping ((ResponseWithArray<IntuitionDto>)->())) {
        let start = 0
        let quantity = 25 // set this high for fetching from last update
        var getUrl = "/intuition/fetch/activity?start=\(start)&quantity=\(quantity)"
        if let lastUpdateTimestamp = self.lastUpdateTimestamp {
            getUrl += "&lastUpdateTimestamp=\(String(describing: lastUpdateTimestamp))"
        }
        
        // fetch only top intuition
        httpClient.getArray(getUrl, completionHandler: { (response: ResponseWithArray<IntuitionDto>) -> () in
            self.lastUpdateTimestamp = response.lastUpdateTimestamp
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func addIntuition(_ intuition: Intuition, image: UIImage?, fileName: String, postWithUploadCompletionHandler: @escaping ((Response<IntuitionDto>)->())) {
        let request = Request()
        request.data = intuition
        
        // post intuition
        httpClient.postWithUpload("/intuition/add", postBodyObject: request, jsonName: "request", image: image, fileName: fileName, postWithUploadCompletionHandler: { (response: Response<IntuitionDto>) -> () in
            
            // now call the view controller callback
            postWithUploadCompletionHandler(response)
        })
    }
    
    func removeIntuition(_ intuition: Intuition, completionHandler: @escaping ((Response<IntuitionDto>)->())) {
        let request = Request()
        request.data = intuition
        
        // post intuition
        httpClient.post("/intuition/remove", postBodyObject: request, completionHandler: { (response: Response<IntuitionDto>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func addOutcome(_ predictionText: String, intuitionId: String, completionHandler: @escaping ((Response<IntuitionDto>)->())) {
        let request = RequestWithString()
        request.intuitionId = intuitionId
        request.data = predictionText
        
        // post intuition
        httpClient.post("/intuition/predicted-outcome", postBodyObject: request, completionHandler: { (response: Response<IntuitionDto>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func setOutcome(_ outcome: Outcome, intuitionId: String, completionHandler: @escaping ((Response<IntuitionDto>)->())) {
        let request = Request()
        request.intuitionId = intuitionId
        request.data = outcome
        
        // post intuition
        httpClient.post("/intuition/outcome", postBodyObject: request, completionHandler: { (response: Response<IntuitionDto>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func addLike(intuitionId: String, completionHandler: @escaping ((Response<IntuitionDto>)->())) {
        let request = Request()
        request.intuitionId = intuitionId
        request.data = Like()
        
        // post intuition
        httpClient.post("/intuition/like", postBodyObject: request, completionHandler: { (response: Response<IntuitionDto>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func removeLike(_ like: Like, completionHandler: @escaping ((Response<IntuitionDto>)->())) {
        let request = Request()
        request.data = like
        
        // post intuition
        httpClient.post("/intuition/like/remove", postBodyObject: request, completionHandler: { (response: Response<IntuitionDto>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func addComment(_ commentText: String, intuitionId: String, completionHandler: @escaping ((Response<IntuitionDto>)->())) {
        let request = Request()
        request.intuitionId = intuitionId
        let comment = Comment()
        comment.commentText = commentText
        request.data = comment
        
        
        // post intuition
        httpClient.post("/intuition/comment", postBodyObject: request, completionHandler: { (response: Response<IntuitionDto>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func removeComment(_ comment: Comment, intuitionId: String, completionHandler: @escaping ((Response<IntuitionDto>)->())) {
        let request = Request()
        request.intuitionId = intuitionId
        request.data = comment
        
        // post intuition
        httpClient.post("/intuition/comment/remove", postBodyObject: request, completionHandler: { (response: Response<IntuitionDto>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
    func voteForOutcome(_ outcome: Outcome, intuitionId: String, completionHandler: @escaping ((Response<IntuitionDto>)->())) {
        let request = Request()
        request.intuitionId = intuitionId
        request.data = outcome
        
        // post intuition
        httpClient.post("/intuition/predicted-outcome/cohort-vote", postBodyObject: request, completionHandler: { (response: Response<IntuitionDto>) -> () in
            
            // now call the view controller callback
            completionHandler(response)
        })
    }
    
}
