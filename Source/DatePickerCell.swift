//
//  DVDatePickerTableViewCell.swift
//  DVDatePickerTableViewCellDemo
//
//  Created by Dylan Vann on 2014-10-21.
//  Copyright (c) 2014 Dylan Vann. All rights reserved.
//

import Foundation
import UIKit

/**
*  Inline/Expanding date picker for table views.
*/

/**
 *  Optional protocol called when date is picked
 */

@objc public protocol DatePickerCellDelegate {
    @objc optional func datePickerCell(_ cell: DatePickerCell, didPickDate date: Date?)

    func tableNeedsUpdate(for cell: DatePickerCell)
}

open class DatePickerCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var togglerLabel: UILabel!
    @IBOutlet weak var togglerSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet open var togglerView: UIView!
    @IBOutlet open var datePickerView: UIView!

    /// The cell's delegate.
    open var delegate: DatePickerCellDelegate?

    // Only create one NSDateFormatter to save resources.
    static let dateFormatter = DateFormatter()

    /// The selected date, set to current date/time on initialization.
    open var date: Date = Date() {
        didSet {
            datePicker.date = date
            DatePickerCell.dateFormatter.dateStyle = dateStyle
            DatePickerCell.dateFormatter.timeStyle = timeStyle
            rightLabel.text = DatePickerCell.dateFormatter.string(from: date)
        }
    }

    /// The time style.
    open var timeStyle = DateFormatter.Style.short {
        didSet {
            DatePickerCell.dateFormatter.timeStyle = timeStyle
            rightLabel.text = DatePickerCell.dateFormatter.string(from: date)
        }
    }

    /// The date style.
    open var dateStyle = DateFormatter.Style.medium {
        didSet {
            DatePickerCell.dateFormatter.dateStyle = dateStyle
            rightLabel.text = DatePickerCell.dateFormatter.string(from: date)
        }
    }

    /// Color of the right label. Default is the color of a normal detail label.
    open var rightLabelTextColor = UIColor(hue: 0.639, saturation: 0.041, brightness: 0.576, alpha: 1.0) {
        didSet {
            rightLabel.textColor = rightLabelTextColor
        }
    }

    /// Is the cell expanded?
    open var expanded = false

    /// Is the date currently active?
    open var dateActive: Bool {
        get {
            return togglerSwitch.isOn
        }
        set {
            togglerSwitch.isOn = newValue
            togglerSwitched(togglerSwitch)
        }
    }

    /**
    Creates the DatePickerCell
    
    - parameter style:           A constant indicating a cell style. See UITableViewCellStyle for descriptions of these constants.
    - parameter reuseIdentifier: A string used to identify the cell object if it is to be reused for drawing multiple rows of a table view. Pass nil if the cell object is not to be reused. You should use the same reuse identifier for all cells of the same form.
    
    - returns: An initialized DatePickerCell object or nil if the object could not be created.
    */
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    /**
     Needed for initialization from a storyboard.
     
     - parameter aDecoder: An unarchiver object.
     - returns: An initialized DatePickerCell object or nil if the object could not be created.
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    fileprivate func setup() {
        // Load content view from NIB
        let bundle = Bundle(identifier: "DV.DatePickerCell")
        let cellContentView = bundle?.loadNibNamed("DatePickerCell", owner: self, options: nil)![0] as! UIView

        // Set content view
        self.contentView.addSubview(cellContentView)
        cellContentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", metrics: nil, views: ["view": cellContentView]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", metrics: nil, views: ["view": cellContentView]))

        // Set some visualization attributes
        rightLabel.textColor = rightLabelTextColor

        // Clear seconds and set initial date
        let timeIntervalSinceReferenceDateWithoutSeconds = floor(date.timeIntervalSinceReferenceDate / 60.0) * 60.0
        self.date = Date(timeIntervalSinceReferenceDate: timeIntervalSinceReferenceDateWithoutSeconds)
    }

    @IBAction func togglerSwitched(_ sender: UISwitch) {
        updateVisibilityOfElements()
        delegate?.tableNeedsUpdate(for: self)
    }

    @IBAction func datePicked(_ sender: UIDatePicker) {
        print("Date picked")
    }

    private func animateViewChanges() {
        func performTransition() {
            UIView.transition(with: self.togglerView, duration: 0.2, options: .transitionCrossDissolve, animations: {
                self.togglerSwitch.isHidden = !self.expanded
                self.togglerLabel.isHidden = !self.expanded
            })
//            UIView.transition(with: rightLabel, duration: 0.1, options: .transitionCrossDissolve, animations: {
//                self.rightLabel.textColor = self.expanded ? self.tintColor : self.rightLabelTextColor
//            })
        }

        if !dateActive && expanded {
            // Delay animate if cell will expand and toggler is off (because of low height)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                performTransition()
            }
        } else {
            performTransition()
        }
    }

    private func updateVisibilityOfElements() {
        togglerView.isHidden = !expanded
        datePickerView.isHidden = !expanded || !dateActive
    }

    /**
    Used to notify the DatePickerCell that it was selected. The DatePickerCell will then run its selection animation and expand or collapse.
    - parameter tableView: The table view the DatePickerCell was selected in.
    */
    open func selectedInTableView(_ tableView: UITableView) {
        expanded = !expanded
        animateViewChanges()
        updateVisibilityOfElements()
        delegate?.tableNeedsUpdate(for: self)
    }

    // Action for the datePicker ValueChanged event.
//    func datePicked() {
//        date = datePicker.date
//        // date picked, call delegate method
//        self.delegate?.datePickerCell?(self, didPickDate: date)
//    }
}
