//
//  Switch.swift
//  TestDB
//
//  Created by Dima Gubatenko on 27.07.17.
//  Copyright © 2017 Dima Gubatenko. All rights reserved.
//

import UIKit
import QuartzCore

public enum SwitchPosition {
    case right
    case left
}

public protocol SwitchDelegate : class {
    func switchValueShouldChange(_ currentState: SwitchPosition) -> Bool
    func switchValueDidChange(_ currentState: SwitchPosition)
}

open class Switch: UIView {

    open var leftLabel = UILabel(frame: .zero)
    open var rightLabel = UILabel(frame: .zero)
    open var leftText = "" {
        didSet {
            leftLabel.text = leftText
            leftLabel.sizeToFit()
        }
    }
    open var rightText = "" {
        didSet {
            rightLabel.text = rightText
            rightLabel.sizeToFit()
        }
    }
    open var rightBadge = UILabel(frame: .zero)
    open var leftBadge = UILabel(frame: .zero)
    open var rightBadgeCount = 0 {
        didSet {
            rightBadge.isHidden = rightBadgeCount == 0
            rightBadge.text = "\(rightBadgeCount)"
            rightBadge.sizeToFit()
            setNeedsLayout()
        }
    }
    open var leftBadgeCount = 0 {
        didSet {
            leftBadge.isHidden = leftBadgeCount == 0
            leftBadge.text = "\(leftBadgeCount)"
            leftBadge.sizeToFit()
            setNeedsLayout()
        }
    }
    open var rightBadgeHeight: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }
    open var leftBadgeHeight: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }

    open weak var delegate: SwitchDelegate?

    private var switchRect: CALayer
    private var leftContainer: UIView!
    private var rightContainer: UIView!
    private var state = SwitchPosition.left

    override public init(frame: CGRect) {
        switchRect = CALayer()
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        switchRect = CALayer()
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        let size = bounds.size
        switchRect.backgroundColor = UIColor.white.cgColor
        layer.addSublayer(switchRect)
        leftBadge.layer.masksToBounds = true
        leftBadge.isUserInteractionEnabled = false
        leftContainer = UIView(frame: CGRect(x: 0.0, y: 0.0, width: size.width / 2, height: size.height))
        leftContainer.addSubview(leftBadge)
        leftContainer.isUserInteractionEnabled = false
        leftBadge.textAlignment = .center
        leftContainer.addSubview(leftLabel)
        leftLabel.textAlignment = .center
        leftLabel.isUserInteractionEnabled = false
        addSubview(leftContainer)
        rightBadge.layer.masksToBounds = true
        rightBadge.textAlignment = .center
        rightBadge.isUserInteractionEnabled = false
        rightContainer = UIView(frame: CGRect(x: size.width / 2, y: 0, width: size.width / 2, height: size.height))
        rightContainer.addSubview(rightLabel)
        rightContainer.isUserInteractionEnabled = false
        rightLabel.isUserInteractionEnabled = false
        rightContainer.addSubview(rightBadge)
        rightLabel.textAlignment = .center
        addSubview(rightContainer)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clicked))
        addGestureRecognizer(tapGesture)
    }

    open override func layoutSubviews() {
        let size = bounds.size
        switchRect.frame = CGRect(x: 0, y: 0, width: size.width / 2, height: size.height)
        switchRect.cornerRadius = switchRect.frame.height / 2
        leftContainer.frame = CGRect(x: 0.0, y: 0.0, width: size.width / 2, height: size.height)
        rightContainer.frame = CGRect(x: size.width / 2, y: 0, width: size.width / 2, height: size.height)
        leftLabel.center = CGPoint(x: leftContainer.bounds.midX, y: leftContainer.bounds.midY)
        rightLabel.center = CGPoint(x: rightContainer.bounds.midX, y: rightContainer.bounds.midY)
        rightBadge.frame = CGRect(x: rightLabel.frame.origin.x + rightLabel.frame.width, y: rightLabel.frame.origin.y, width: rightBadgeHeight, height: rightBadgeHeight)
        rightBadge.layer.cornerRadius = rightBadge.frame.height / 2
        leftBadge.frame = CGRect(x: leftLabel.frame.origin.x + leftLabel.frame.width, y: leftLabel.frame.origin.y, width: leftBadgeHeight, height: leftBadgeHeight)
        leftBadge.layer.cornerRadius = leftBadge.frame.height / 2
    }

    func clicked(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        if let delegate = delegate, !delegate.switchValueShouldChange(state) {
            return
        }
        if location.x < frame.width / 2 {
            state = .left
        } else {
            state = .right
        }
        updateSwitchRect()
        delegate?.switchValueDidChange(state)
    }

    private func updateSwitchRect() {
        let size = bounds.size
        if state == .left {
            switchRect.frame = CGRect(x: 0, y: 0, width: size.width / 2, height: size.height)
        } else {
            switchRect.frame = CGRect(x: size.width / 2, y: 0, width: size.width / 2, height: size.height)
        }
    }
}
