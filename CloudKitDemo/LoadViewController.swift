//
//  SecondViewController.swift
//  CloudKitDemo
//
//  Created by XRD.Andy on 2017/7/19.
//  Copyright © 2017年 RockerHX. All rights reserved.
//




import UIKit
import CloudKit


class LoadViewController: UITableViewController {

    // MARK: - IBOutlet Property -
    // MARK: - Public Property -
    // MARK: - Private Property -
    var records = [CKRecord]()
    var cloudContainer = CKContainer.default()
    var publicDatabase: CKDatabase?
    var privateDatabase: CKDatabase?
    var shareDatabase: CKDatabase?

    // MARK: - View Controller Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        configure()
    }

    // MARK: - Navigation -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }

    // MARK: - Event Methods -
    @IBAction func searchButtonPressed() {
        
        records.removeAll()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let recordID = CKRecordID(recordName: "Demo-ID-Default-Zone")

        publicDatabase?.fetch(withRecordID: recordID, completionHandler: { [weak self] (fetchRecord, fetchError) in
            if let error = fetchError {
                print(error)
            } else {
                if let record = fetchRecord {
                    print("------------------------")
                    print(record)

                    record["mobile"] = Date().description as CKRecordValue

                    self?.publicDatabase?.save(record, completionHandler: { (saveRecord, saveError) in
                        if let error = saveError {
                            print(error)
                        } else {
                            if let sRecord = saveRecord {
                                DispatchQueue.main.async {
                                    print("------------------------")
                                    print(sRecord)
                                    self?.records.append(sRecord)
                                    self?.tableView.reloadData()
                                }
                            }
                        }
                    })
                }
            }

            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }

    @IBAction func playButtonPressed() {

        records.removeAll()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let recordID = CKRecordID(recordName: "36C2AE3A-E242-40CC-88D2-9D22305A276A")

        publicDatabase?.fetch(withRecordID: recordID, completionHandler: { [weak self] (fetchRecord, fetchError) in
            if let error = fetchError {
                print(error)
            } else {
                if let record = fetchRecord {
                    DispatchQueue.main.async {
                        print("------------------------")
                        print(record)
                        self?.records.append(record)
                        self?.tableView.reloadData()
                    }

                    if let reference = record["sbitem"] as? CKReference {
                        self?.publicDatabase?.fetch(withRecordID: reference.recordID, completionHandler: { [weak self] (fetchRecord, fetchError) in
                            if let error = fetchError {
                                print(error)
                            } else {
                                if let record = fetchRecord {
                                    DispatchQueue.main.async {
                                        print("------------------------")
                                        print(record)
                                        self?.records.append(record)
                                        self?.tableView.reloadData()
                                    }
                                }
                            }
                        })
                    }
                        
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        })
    }

    @IBAction func composeButtonPressed() {

        records.removeAll()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let recordID = CKRecordID(recordName: "3CE4A09E-815E-45FE-B344-235AFFF47F49")
//        let reference = CKReference(recordID: recordID, action: .none)
        let predicate = NSPredicate(format: "father = %@", recordID)
        print(predicate)
        let query = CKQuery(recordType: "subItem", predicate: predicate)
        publicDatabase?.perform(query, inZoneWith: nil, completionHandler: { [weak self] (queryRecords, queryError) in
            if let error = queryError {
                print(error)
            } else {
                if let qRecords = queryRecords {
                    DispatchQueue.main.async {
                        print("------------------------")
                        self?.records.append(contentsOf: qRecords)
                        self?.tableView.reloadData()
                    }
                }
            }

            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }

    @IBAction func refreshButtonPressed() {

        records.removeAll()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let predicate = NSPredicate(format: "title = %@", "Da Sha Bi ++")
        let query = CKQuery(recordType: "dDemoItem", predicate: predicate)
        publicDatabase?.perform(query, inZoneWith: nil, completionHandler: { [weak self] (queryRecords, queryError) in
            if let error = queryError {
                print(error)
            } else {
                if let qRecords = queryRecords {
                    DispatchQueue.main.async {
                        print("------------------------")
                        self?.records.append(contentsOf: qRecords)
                        self?.tableView.reloadData()
                    }
                }
            }

            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }

    // MARK: - Private Methods -
    fileprivate func configure() {

        CKContainer.default().accountStatus { (accountStatus, accountError) in

            switch accountStatus {
            case .couldNotDetermine:
                print("accountStatus: couldNotDetermine")
            case .available:
                print("accountStatus: available")
            case .restricted:
                print("accountStatus: restricted")
            case .noAccount:
                print("accountStatus: noAccount")
            }

            if let error = accountError {
                print("error:\(error)")
            } else {
                self.publicDatabase = self.cloudContainer.publicCloudDatabase
                self.privateDatabase = self.cloudContainer.privateCloudDatabase
                self.shareDatabase = self.cloudContainer.sharedCloudDatabase
            }
        }
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
