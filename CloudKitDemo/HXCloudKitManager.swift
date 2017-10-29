//
//  HXCloudKitManager.swift
//  CloudKitDemo
//
//  Created by XRD.Andy on 2017/7/19.
//  Copyright © 2017年 RockerHX. All rights reserved.
//


import CloudKit
import PromiseKit


class HXCloudKitManager: NSObject {

    static let manager = HXCloudKitManager()

    // MARK: - Public Property -
    let cloudContainer = CKContainer.default()

    private(set) var publicDatabase: CKDatabase!
    private(set) var privateDatabase: CKDatabase!
    private(set) var shareDatabase: CKDatabase!

    // MARK: - Initialize Methods -
    override init() {
        super.init()

        _ = checkAccountStatus()
    }

    // MARK: - Public Methods -
    public func checkAccountStatus() -> Promise<Void> {
        return CKContainer.default().accountStatus().then { status -> Promise<Void> in

            var errorTip = ""
            switch status {
            case .couldNotDetermine:
                errorTip = "accountStatus: couldNotDetermine"
            case .available:
                print("accountStatus: available")
            case .restricted:
                errorTip = "accountStatus: restricted"
            case .noAccount:
                errorTip = "accountStatus: noAccount"
            }

            if status == .available {
                return Promise()
            } else {
                return Promise<Void> { _, reject in
                    reject(NSError(domain: errorTip, code: -1, userInfo: nil))
                }
            }

        }.then { Void -> Promise<Void> in
            self.publicDatabase = self.cloudContainer.publicCloudDatabase
            self.privateDatabase = self.cloudContainer.privateCloudDatabase
            if #available(iOS 10.0, *) {
                self.shareDatabase = self.cloudContainer.sharedCloudDatabase
            } else {
                // Fallback on earlier versions
            }
            return Promise()
        }
    }

}
