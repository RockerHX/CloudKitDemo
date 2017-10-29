//
//  CreateViewController.swift
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


class CreateViewController: UITableViewController {

    // MARK: - IBOutlet Property -
    // MARK: - Public Property -
    // MARK: - Private Property -
    var records = [CKRecord]()
    let cloudKitManager = HXCloudKitManager()

    // MARK: - View Controller Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    // MARK: - Event Methods -
    @IBAction func addButtonPressed() {
        // 新建一个DemoItem
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            cloudKitManager.checkAccountStatus()
        }.then { Void -> Promise<CKRecord> in
            let recordID = CKRecordID(recordName: Date().description)
            let demoRecord = CKRecord(recordType: "DemoItem", recordID: recordID)
            demoRecord["name"] = "demo item" as CKRecordValue
            demoRecord["title"] = "demo title" as CKRecordValue
            demoRecord["mobile"] = "123123123" as CKRecordValue
            return self.cloudKitManager.publicDatabase.save(demoRecord)
        }.then(on: DispatchQueue.main) { record -> Promise<Void> in
            print("------------------------")
            print(record)
            self.records.append(record)
            self.tableView.reloadData()
            return Promise()
        }.catch { error in
            print(error)
        }.always {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    @IBAction func composeButtonPressed() {
        // 新建一个DemoItem和一个DemoSubItem，DemoSubItem的father引用DemoItem
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            cloudKitManager.checkAccountStatus()
        }.then { Void -> Promise<CKRecord> in
            let recordID = CKRecordID(recordName: Date().description)
            let demoRecord = CKRecord(recordType: "DemoItem", recordID: recordID)
            demoRecord["name"] = "demo item" as CKRecordValue
            demoRecord["title"] = "demo title" as CKRecordValue
            demoRecord["mobile"] = "123123123" as CKRecordValue
            return self.cloudKitManager.publicDatabase.save(demoRecord)
        }.then { record -> Promise<CKRecord> in
            let reference = CKReference(recordID: record.recordID, action: .none)
            let subDemoRecord = CKRecord(recordType: "DemoSubItem")
            subDemoRecord["father"] = reference
            subDemoRecord["name"] = "demo sub item" as CKRecordValue
            subDemoRecord["title"] = "demo sub title" as CKRecordValue
            subDemoRecord["mobile"] = "321321321" as CKRecordValue
            return self.cloudKitManager.publicDatabase.save(subDemoRecord)
        }.then(on: DispatchQueue.main) { record -> Promise<Void> in
            print("------------------------")
            print(record)
            self.records.append(record)
            self.tableView.reloadData()
            return Promise()
        }.catch { error in
            print(error)
        }.always {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    @IBAction func customZoneButtonPressed() {
        // 创建自定义DemoZone，并且插入DemoItem
        // 自定义Zone
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        firstly {
            cloudKitManager.checkAccountStatus()
        }.then { Void -> Promise<CKRecordZone> in
            let customZone = CKRecordZone(zoneName: "DemoZone")
            return self.cloudKitManager.privateDatabase.save(customZone)
        }.then { zone -> Promise<CKRecord> in
            let demoRecord = CKRecord(recordType: "DemoItem", zoneID: zone.zoneID)
            demoRecord["name"] = "demo item" as CKRecordValue
            demoRecord["title"] = "demo title" as CKRecordValue
            demoRecord["mobile"] = "123123123" as CKRecordValue
            return self.cloudKitManager.privateDatabase.save(demoRecord)
        }.then(on: DispatchQueue.main) { record -> Promise<Void> in
            print("------------------------")
            print(record)
            self.records.append(record)
            self.tableView.reloadData()
            return Promise()
        }.catch { error in
            print(error)
        }.always {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    // MARK: - Private Methods -
    fileprivate func configure() {
    }

}


// MARK: - Table View Extension -
extension CreateViewController {

    // MARK: - Table View Data Source Methods -
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CreateCell", for: indexPath)
        // Configure the cell...
        let record = records[indexPath.row]
        cell.textLabel?.text = record.recordID.recordName
        cell.detailTextLabel?.text = record.creationDate?.description

        return cell
    }

}
