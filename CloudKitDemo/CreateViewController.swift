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


class CreateViewController: UITableViewController {

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
    @IBAction func pushButtonPressed() {

        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let recordID = CKRecordID(recordName: Date().description)
        let sbRecord = CKRecord(recordType: "sbItem", recordID: recordID)
        sbRecord["name"] = "sb item" as CKRecordValue
        sbRecord["title"] = "sbItem sbItem" as CKRecordValue
        sbRecord["mobile"] = "123123123" as CKRecordValue

        let reference = CKReference(recordID: recordID, action: .none)

        let dRecord = CKRecord(recordType: "dDemoItem")
        dRecord["item"] = reference
        dRecord["name"] = "sb" as CKRecordValue
        dRecord["title"] = "Da Sha Bi ++" as CKRecordValue
        dRecord["mobile"] = "43420024420" as CKRecordValue

        publicDatabase?.save(sbRecord, completionHandler: { [weak self] (saveRecord, saveError) in
            if let error = saveError {
                print(error)
            } else {
                self?.publicDatabase?.save(dRecord, completionHandler: { [weak self] (saveRecord, saveError) in
                    if let error = saveError {
                        print(error)
                    } else {
                        DispatchQueue.main.async {
                            if let record = saveRecord {
                                print("------------------------")
                                print(record)
                                self?.records.append(record)
                                self?.tableView.reloadData()
                            }
                        }
                    }

                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                })
            }
        })
    }

    @IBAction func composeButtonPressed() {

        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let dRecord = CKRecord(recordType: "dDemoItem")
        dRecord["name"] = "sb" as CKRecordValue
        dRecord["title"] = "Da Sha Bi ++" as CKRecordValue
        dRecord["mobile"] = "43420024420" as CKRecordValue

        let reference = CKReference(recordID: dRecord.recordID, action: .none)

        let subRecord1 = CKRecord(recordType: "subItem")
        subRecord1["date"] = Date().description as CKRecordValue
        subRecord1["father"] = reference

        let subRecord2 = CKRecord(recordType: "subItem")
        subRecord2["date"] = Date().description as CKRecordValue
        subRecord2["father"] = reference

        publicDatabase?.save(subRecord1, completionHandler: { [weak self] (saveRecord, saveError) in
            if let error = saveError {
                print(error)
            } else {
                DispatchQueue.main.async {
                    if let record = saveRecord {
                        print("------------------------")
                        print(record)
                        self?.records.append(record)
                        self?.tableView.reloadData()
                    }
                }

                self?.publicDatabase?.save(subRecord2, completionHandler: { [weak self] (saveRecord, saveError) in
                    if let error = saveError {
                        print(error)
                    } else {
                        DispatchQueue.main.async {
                            if let record = saveRecord {
                                print("------------------------")
                                print(record)
                                self?.records.append(record)
                                self?.tableView.reloadData()
                            }
                        }

                        self?.publicDatabase?.save(dRecord, completionHandler: { [weak self] (saveRecord, saveError) in
                            if let error = saveError {
                                print(error)
                            } else {
                                DispatchQueue.main.async {
                                    if let record = saveRecord {
                                        print("------------------------")
                                        print(record)
                                        self?.records.append(record)
                                        self?.tableView.reloadData()
                                    }
                                }
                            }
                            
                            UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        })
                    }
                })
            }
        })
    }

    @IBAction func customZoneButtonPressed() {

        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        let customZone = CKRecordZone(zoneName: "DemoZone")

        // Save the friendsZone in the private database
        privateDatabase?.save(customZone, completionHandler: { [weak self] (saveZone, savaError) in
            if let error = savaError {
                print(error)
            } else {
                if let zone = saveZone {
                    let record = CKRecord(recordType: "DemoItem", zoneID: zone.zoneID)
                    record["name"] = "sb" as CKRecordValue
                    record["title"] = "Da Sha Bi ++" as CKRecordValue
                    record["mobile"] = "43420024420" as CKRecordValue

                    self?.privateDatabase?.save(record, completionHandler: { [weak self] (saveRecord, saveError) in
                        if let error = saveError {
                            print(error)
                        } else {
                            DispatchQueue.main.async {
                                if let record = saveRecord {
                                    print("------------------------")
                                    print(record)
                                    self?.records.append(record)
                                    self?.tableView.reloadData()
                                }
                            }
                        }
                        
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    })
                }
            }
        })
    }

    @IBAction func addButtonPressed() {

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let record = CKRecord(recordType: "dDemoItem")
        record["name"] = "sb" as CKRecordValue
        record["title"] = "Da Sha Bi ++" as CKRecordValue
        record["mobile"] = "43420024420" as CKRecordValue

        publicDatabase?.save(record, completionHandler: { [weak self] (saveRecord, saveError) in
            if let error = saveError {
                print(error)
            } else {
                DispatchQueue.main.async {
                    if let record = saveRecord {
                        print("------------------------")
                        print(record)
                        self?.records.append(record)
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

    // MARK: - Table View Delegate Methods -
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */

    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */

    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

}
