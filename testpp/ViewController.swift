//
//  ViewController.swift
//  testpp
//
//  Created by Lokeshwaran on 25/03/24.
//

import UIKit
import XMPPFramework
import CocoaAsyncSocket;
import CocoaLumberjack;

class ViewController: UIViewController {

    var xmppController: XMPPController!

    override func viewDidLoad() {

        super.viewDidLoad()
//1
        print("View loaded......")

        do{
            try self.xmppConnect()
        }
        catch {
            print("Failed to connect: \(error)")
        }
    }

    func xmppConnect() throws {
//2
        print("Trying to connect......")
        xmppController = try XMPPController(hostName: "172.16.4.205",
                                                userJIDString: "chat@172.16.4.205",
                                                hostPort: 5223,
                                                password: "statsoladmin")

        xmppController.connect()
        
    }
}


