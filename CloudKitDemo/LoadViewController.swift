//
//  SecondViewController.swift
//  CloudKitDemo
//
//  Created by XRD.Andy on 2017/7/19.
//  Copyright © 2017年 RockerHX. All rights reserved.
//
//  GitHub: https://github.com/rockerhx
//


import UIKit
import CloudKit
import PromiseKit


class LoadViewController: UITableViewController {

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

    // MARK: - Event Methods -
    @IBAction func searchButtonPressed() {
        // 通过特定的recordName拉取CKRecord
        records.removeAll()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            cloudKitManager.checkAccountStatus()
        }.then { Void -> Promise<CKRecord> in
            let recordID = CKRecordID(recordName: "2017-10-29 09:57:57 +0000")
            return self.cloudKitManager.publicDatabase.fetch(withRecordID: recordID)
        }.then { record -> Promise<CKRecord> in
            record["mobile"] = Date().description as CKRecordValue
            return self.cloudKitManager.publicDatabase.save(record)
        }.then(on: DispatchQueue.main) { record -> Void in
            print("------------------------")
            print(record)
            self.records.append(record)
            self.tableView.reloadData()
        }.always {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }.catch { error in
            print(error)
        }
    }

    @IBAction func composeButtonPressed() {
        // CKReference筛选查询
        records.removeAll()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            cloudKitManager.checkAccountStatus()
        }.then { Void -> Promise<[CKRecord]> in
            let recordID = CKRecordID(recordName: "2017-10-29 11:32:07 +0000")
            let predicate = NSPredicate(format: "father = %@", recordID)
            print(predicate)
            let query = CKQuery(recordType: "DemoSubItem", predicate: predicate)
            return self.cloudKitManager.publicDatabase.perform(query)
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

    @IBAction func refreshButtonPressed() {
        // 普通属性筛选查询
        records.removeAll()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            cloudKitManager.checkAccountStatus()
            }.then { Void -> Promise<[CKRecord]> in
                let predicate = NSPredicate(format: "mobile = %@", "321321321")
                let query = CKQuery(recordType: "DemoSubItem", predicate: predicate)
                print(predicate)
                return self.cloudKitManager.publicDatabase.perform(query)
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
extension LoadViewController {

    // MARK: - Table View Data Source Methods -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoadCell", for: indexPath)
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
