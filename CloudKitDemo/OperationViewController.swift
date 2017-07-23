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


class OperationViewController: UITableViewController {

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
    @IBAction func fetchButtonPressed() {

        records.removeAll()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let fetchRecordsOperation = CKFetchRecordsOperation(recordIDs: [CKRecordID(recordName: "Demo-ID-Default-Zone"),
                                                                        CKRecordID(recordName: "Demo-ID-Default-Zone1")])
        fetchRecordsOperation.perRecordCompletionBlock = { [weak self] (perRecord, perRecordID, perError) in
            print("Per")
            if let error = perError {
                print(error)
            } else {
                if let record = perRecord, let recordID = perRecordID {
                    print("------------------------")
                    print(record)
                    print(recordID)
                    DispatchQueue.main.async {
                        self?.records.append(record)
                        self?.tableView.reloadData()
                    }
                }
            }
        }

        fetchRecordsOperation.fetchRecordsCompletionBlock = { [weak self] (fetchRecordsByRecordID, fetchError) in
            print("Fetch")
            if let error = fetchError {
                print(error)
            } else {
                if let recordsByRecordID = fetchRecordsByRecordID {
                    for (recordID, record) in recordsByRecordID {
                        print("------------------------")
                        print(recordID)
                        DispatchQueue.main.async {
                            self?.records.append(record)
                            self?.tableView.reloadData()
                        }
                    }
                }
            }

            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }

        fetchRecordsOperation.database = publicDatabase
        fetchRecordsOperation.start()
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
