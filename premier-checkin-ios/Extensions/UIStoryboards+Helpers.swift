//
//  UIStoryboards+Helpers.swift
//  premier-checkin-ios
//
//  Created by Elie El Khoury on 10/5/18.
//  Copyright © 2018 Elie El Khoury. All rights reserved.
//

import UIKit

public enum StoryboardIdentifier: String {
    case Main = "Main"
    case Support = "Support"
}

public enum ViewControllerStoryboardIdentifier: String {
    case Checkin = "CheckinViewController"
    case Event = "EventViewController"
    case EventNVC = "EventNavigationViewController"
    case Loading = "LoadingViewController"
    case WebView = "WebViewController"
    case WebNVC = "WebNavigationViewController"
    case AboutNVC = "AboutNavigationViewController"
    case AboutView = "AboutViewController"
}

extension UIStoryboard {
    
    class var Main: UIStoryboard {
        struct Static {
            static let instance: UIStoryboard = UIStoryboard(name: StoryboardIdentifier.Main.rawValue, bundle: nil)
        }
        return Static.instance
    }
    
    class var Support: UIStoryboard {
        struct Static {
            static let instance: UIStoryboard = UIStoryboard(name: StoryboardIdentifier.Support.rawValue, bundle: nil)
        }
        return Static.instance
    }
}

struct Segue {
    
    struct Loading {
        static let toEventNVC = "LoadingToEventNavigationVC"
        static let toCheckinNVC = "LoadingToCheckinNavigationVC"
    }

    struct Event {
        static let toCheckinNVC = "EventCodeToCheckinNavigationVC"
    }
    
    struct Checkin {
        static let toQRScannerVC = "CheckinToQRScannerVC"
        static let toDuplicatesVC = "CheckinToDuplicatesVC"
        static let toGroupCheckinVC = "CheckinToGroupCheckinVC"
        static let toSpecialGroupCheckinVC = "CheckinToSpecialGroupCheckinVC"
        static let toParticipantCheckinVC = "CheckinToParticipantCheckinVC"
    }
    
    struct Duplicates {
        static let toParticipantCheckinVC = "DuplicatesToParticipantCheckinVC"
        static let toGroupCheckinVC = "DuplicatesToGroupCheckinVC"
    }
    
    struct QRScanner {
        static let toParticipantCheckinVC = "QRToParticipantCheckinVC"
        static let toGroupCheckinVC = "QRToGroupCheckinVC"
        static let toSpecialGroupCheckinVC = "QRToSpecialGroupCheckinVC"
    }
}

