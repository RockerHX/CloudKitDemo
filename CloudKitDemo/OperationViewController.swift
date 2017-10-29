//
//  OperationViewController.swift
//  CloudKitDemo
//
//  Created by RockerHX on 2017/7/23.
//  Copyright © 2017年 RockerHX. All rights reserved.
//
//  GitHub: https://github.com/rockerhx
//


import UIKit
import CloudKit
import PromiseKit


class OperationViewController: UITableViewController {

    // MARK: - IBOutlet Property -
    // MARK: - Public Property -
    // MARK: - Private Property -
    var records = [CKRecord]()
    let cloudKitManager = HXCloudKitManager.manager

    // MARK: - View Controller Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    // MARK: - Navigation -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: - Event Methods -
    @IBAction func fetchButtonPressed() {
        // 批量拉取
        records.removeAll()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            cloudKitManager.checkAccountStatus()
        }.then { Void -> Promise<[CKRecord]> in
            var promises = [Promise<CKRecord>]()
            var recordID = CKRecordID(recordName: "2017-10-29 14:47:04 +0000")
            var promise = self.cloudKitManager.publicDatabase.fetch(withRecordID: recordID)
            promises.append(promise)
            recordID = CKRecordID(recordName: "2017-10-29 14:24:17 +0000")
            promise = self.cloudKitManager.publicDatabase.fetch(withRecordID: recordID)
            promises.append(promise)
            recordID = CKRecordID(recordName: "2017-10-29 11:32:07 +0000")
            promise = self.cloudKitManager.publicDatabase.fetch(withRecordID: recordID)
            promises.append(promise)
            return when(fulfilled: promises)
        }.then(on: DispatchQueue.main) { records -> Void in
            print("------------------------")
            print(records)
            self.records.append(contentsOf: records)
            self.tableView.reloadData()
        }.always {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }.catch { error in
            print(error)
        }
    }
    
    // MARK: - Private Methods -
    fileprivate func configure() {
    }

}


// MARK: - Table View Extension -
extension OperationViewController {

    // MARK: - Table View Data Source Methods -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OperationCell", for: indexPath)
        // Configure the cell...
        let record = records[indexPath.row]
        cell.textLabel?.text = record.recordID.recordName
        cell.detailTextLabel?.text = record.creationDate?.description

        return cell
    }

    // MARK: - Table View Delegate Methods -
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
