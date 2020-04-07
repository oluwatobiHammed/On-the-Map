//
//  StudentsTableDataSourse.swift
//  OnTheMap
//
//  Created by Oladipupo Oluwatobi on 28/03/2020.
//  Copyright © 2020 Oladipupo Oluwatobi. All rights reserved.
//

import UIKit

final class StudentsTableDataSource: NSObject, UITableViewDataSource {
    var studentsLocations = [StudentLocation]()
    
    init(studentsLocations: [StudentLocation]) {
        self.studentsLocations = studentsLocations
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StudentsTableCell.identifier, for: indexPath) as! StudentsTableCell
        cell.studentName.text = studentsLocations[indexPath.row].firstName + " " + studentsLocations[indexPath.row].lastName
        cell.studentLink.text = studentsLocations[indexPath.row].link
        return cell
    }
}
