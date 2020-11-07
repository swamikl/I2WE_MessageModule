//
//  Extensions.swift
//  Messenger
//
//  Created by Swamik Lamichhane on 10/19/20.
//  Copyright © 2020 Swamik Lamichhane. All rights reserved.
// this file is so that we do not have to type long things when getting the width or something similar
//


// with these defined we can go back to the logInViewCOntroller and set the things for the logo
import Foundation
import UIKit

extension UIView {
    
    public var width: CGFloat {
        return self.frame.size.width
    }
    
    public var height: CGFloat {
        return self.frame.size.height
    }
    
    public var top: CGFloat {
        return self.frame.origin.y
    }

    public var bottom: CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }
    
    public var left: CGFloat {
           return self.frame.origin.x
    }

       public var right: CGFloat {
           return self.frame.size.width + self.frame.origin.x
    }

}

extension Notification.Name {
    static let didLogInNotification = Notification.Name("didLogInNotification")
}
