//
//  Functions.swift
//  TestMK
//
//  Created by Dima Gubatenko on 13.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import CRToast

func showText(_ string: String, time: TimeInterval = 2, onTap: (() -> Void)? = nil, completionBlock: (() -> Void)? = nil) {
    let interaction = CRToastInteractionResponder(interactionType: .all, automaticallyDismiss: true) { _ in
        onTap?()
    }
    var options: [String : Any] = [kCRToastTextKey : string,
                                   kCRToastTextAlignmentKey : NSNumber(value: NSTextAlignment.center.rawValue),
                                   kCRToastBackgroundColorKey : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                                   kCRToastTextColorKey : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                                   kCRToastAnimationInTypeKey : NSNumber(value: CRToastAnimationType.gravity.rawValue),
                                   kCRToastAnimationOutTypeKey : NSNumber(value: CRToastAnimationType.gravity.rawValue),
                                   kCRToastAnimationInDirectionKey : NSNumber(value: CRToastAnimationDirection.left.rawValue),
                                   kCRToastAnimationOutDirectionKey : NSNumber(value: CRToastAnimationDirection.right.rawValue),
                                   kCRToastNotificationTypeKey : NSNumber(value: CRToastType.navigationBar.rawValue),
                                   kCRToastNotificationPresentationTypeKey : NSNumber(value: CRToastPresentationType.cover.rawValue),
                                   kCRToastTimeIntervalKey: NSNumber(value: time)]
    if let interaction = interaction {
        options[kCRToastInteractionRespondersKey] = [interaction]
    }
    CRToastManager.showNotification(options: options, completionBlock: completionBlock)
}

func log(_ items: Any...) {
    #if DEBUG
        print(items)
    #endif
}
