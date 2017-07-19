//
//  ViewController.swift
//  SegFault11
//
//  Created by Dylan Vann on 2014-10-25.
//  Copyright (c) 2014 Dylan Vann. All rights reserved.
//

import UIKit
import DatePickerCell

class ViewController: UITableViewController {

    var cells: NSArray = []

    override func viewDidLoad() {
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44

        // The DatePickerCell.
        let datePickerCell = DatePickerCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        datePickerCell.delegate = self

//        datePickerCell.date = Date()

        // Cells is a 2D array containing sections and rows.
        cells = [[datePickerCell]]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView(tableView, cellForRowAt: indexPath) as! DatePickerCell
        cell.selectedInTableView(self.tableView)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (cells[section] as AnyObject).count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = cells[indexPath.section] as! NSArray
        return section[indexPath.row] as! UITableViewCell
    }
}

extension ViewController: DatePickerCellDelegate {

    func tableNeedsUpdate(for cell: DatePickerCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

}
