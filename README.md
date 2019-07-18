![Social Intuition](https://raw.githubusercontent.com/willjstevens/social-intuition-resources/master/cover-image.png)

Social Intuition iOS
=
Track your predictions about school events, sports, entertainment. 
Capture and track your intuitions. Browse community or private intuitions. Set outcomes and vote on others intuitions. Track your accuracy.

DISCLAIMER #1 - DEPRECATED and INACTIVE
-
SocialIntuition.co has been shutdown and all resources have been fully decommissioned as of July, 2019.

This repository is no longer active. 

This repository is not supported.

DISCLAIMER #2 - LEGAL and LICENSE
-

#### If you choose to fork it, you are subject to the attached license. 

#### If you choose to fork and use it, you are subject and responsible for any security and faulty issues. 
 
#### The repository owner is in **_NO WAY_** responsible or liable for any loss.  

#### The repository owner is in **_NO WAY_** responsible or liable for any assumed damage. 

## The long narrative of Social Intuition
**See the screenshots below for visuals.**

Social Intuition lets you capture and track your intuitions. How accurate are you?

Intuitions are like predictions, paired with outcomes. They may be serious or silly. In Social Intuition you capture and track your intuitions and set the outcome once it occurs. But be honest. This will adjust your accuracy percentage positively or negatively. 

The community also contributes public intuitions for you to browse, vote and watch for the outcome. Add cohorts (or friends) to follow one another. Cohorts will set theirs and you can like/comment, and make a predicted outcome against others. 

You may even capture your own personal or private intuitions without disclosing it to the community. 

## What is in this repository
A running iOS application written in Swift and with Xcode storyboards. This is an _app_-level repository.

It does not include any of the _non_-app resources such as database scripts or images in this README. You will find those in the supporting [Social Intuition Resources](https://github.com/willjstevens/social-intuition-resources) repository. 

## The supporting, resources repository 
The supporting [Social Intuition Resources](https://github.com/willjstevens/social-intuition-resources) repository contains the following _non_-app resources.

 - Artwork (logos, branding) 
 - AWS deployment and build scripts, configuration
 - Database scripts
 - iOS assets
 - Images in this README

## iOS client to the server application services

This iOS client calls API endpoints hosted in the [Social Intuition](https://github.com/willjstevens/social-intuition) server service repository.

This server-side application also hosts endpoints for mobile apps to hit. They hit essentially the same endpoint but with minor device or web session request headers to accommodate different types of clients. Though the internal service calls and logic is the same.


## Technologies
 - Swift
 - Xcode UI storyboards
 - Alamofire HTTP client
 - EVReflection 
 
See the Pods file for a full list. 

## Screenshots and showcase 

### Screenshots
![](https://raw.githubusercontent.com/willjstevens/social-intuition-resources/master/screenshots/ios/app/four-screenshots.png)

### App Store page
![](https://raw.githubusercontent.com/willjstevens/social-intuition-resources/master/screenshots/ios/app/app-store.png)

### Storyboard - Registration
![](https://raw.githubusercontent.com/willjstevens/social-intuition-resources/master/screenshots/ios/xcode/storyboard-1-registration.png)

### Storyboard - Tabbar controller
![](https://raw.githubusercontent.com/willjstevens/social-intuition-resources/master/screenshots/ios/xcode/storyboard-2-tabbar-controller.png)

### Storyboard - Activity Feed
![](https://raw.githubusercontent.com/willjstevens/social-intuition-resources/master/screenshots/ios/xcode/storyboard-3-activity-feed.png)

### Storyboard - Add an Intuition
![](https://raw.githubusercontent.com/willjstevens/social-intuition-resources/master/screenshots/ios/xcode/storyboard-4-add-intuition.png)

### Storyboard - User Profile and Feed
![](https://raw.githubusercontent.com/willjstevens/social-intuition-resources/master/screenshots/ios/xcode/storyboard-5-profile-and-feed.png)

### Storyboard - Notifications
![](https://raw.githubusercontent.com/willjstevens/social-intuition-resources/master/screenshots/ios/xcode/storyboard-6-notifications.png)

### Storyboard - App Walkthrough
![](https://raw.githubusercontent.com/willjstevens/social-intuition-resources/master/screenshots/ios/xcode/storyboard-7-walkthrough.png)

### Code excerpt
![](https://raw.githubusercontent.com/willjstevens/social-intuition-resources/master/screenshots/ios/xcode/code-excerpt-1.png)

