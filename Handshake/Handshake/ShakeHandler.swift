//
//  ShakeHandler.swift
//  Handshake
//
//  Created by Justin Jia on 2/27/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//

// MARK: ShakeHandlerDelegate

func receivedPerson(person: Person) {
    print(person) // This is the person object received.
}


import Foundation
import MultipeerConnectivity
import PGMappingKit

protocol ShakeHandlerDelegate: class {
    func receivedPerson(person: Person)
    func shakeTimeout()
}

class ShakeHandler: NSObject, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {

    weak var delegate: ShakeHandlerDelegate?

    let serviceType = "hand-shake"
    let peerID = MCPeerID(displayName: UIDevice.currentDevice().name)

    var mapping: PGMappingDescription!
    var foundPerson = false

    var context: NSManagedObjectContext?

    let session: MCSession

    var advertiser: MCNearbyServiceAdvertiser?
    var browser: MCNearbyServiceBrowser?

    init(delegate: ShakeHandlerDelegate) {
        self.delegate = delegate
        session = MCSession(peer: peerID)
    }

    func prepareToSend(person: Person, inside context: NSManagedObjectContext) {

        var keys: [NSObject: AnyObject] = [:]

        if !NSUserDefaults.standardUserDefaults().boolForKey("firstNameOff") {
            keys["firstName"] = "firstName"
        }

        if !NSUserDefaults.standardUserDefaults().boolForKey("lastNameOff") {
            keys["lastName"] = "lastName"
        }

        if !NSUserDefaults.standardUserDefaults().boolForKey("emailOff") {
            keys["email"] = "email"
        }

        if !NSUserDefaults.standardUserDefaults().boolForKey("phoneNumberOff") {
            keys["phoneNumber"] = "phoneNumber"
        }

        if !NSUserDefaults.standardUserDefaults().boolForKey("companyOff") {
            keys["company"] = "company"
        }

        if !NSUserDefaults.standardUserDefaults().boolForKey("facebookUrlOff") {
            keys["facebookUrl"] = "facebookUrl"
        }

        if !NSUserDefaults.standardUserDefaults().boolForKey("linkedinUrlOff") {
            keys["linkedinUrl"] = "linkedinUrl"
        }

        mapping = PGMappingDescription(localName: "Person", remoteName: "Person", localIDKey: "imageUrl", remoteIDKey: "imageUrl", mapping: keys)

        self.context = context

        let properties = PGNetworkHandler().dataFromObject(person, mapping: mapping)

        for element in properties {
            if !(element.value is String) {
                properties.removeObjectForKey(element.key)
            }
        }

        guard let info = NSDictionary(dictionary: properties) as? [String : String] else {
            print("Person contains non-string attributes.")
            return
        }

        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: info, serviceType: serviceType)
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)

        advertiser!.delegate = self
        browser!.delegate = self
    }

    func send() {
        advertiser!.startAdvertisingPeer()
        browser!.startBrowsingForPeers()

        let timer = NSTimer(timeInterval: 5, target: self, selector: "timeout:", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }

    // MARK Timer

    func timeout(timer: NSTimer) {
        if !foundPerson {
            advertiser!.stopAdvertisingPeer()
            browser!.stopBrowsingForPeers()
            foundPerson = false
            delegate?.shakeTimeout()
        }
    }

    // MARK: MCNearbyServiceAdvertiserDelegate

    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        advertiser.stopAdvertisingPeer()

        invitationHandler(false, session)
    }

    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        print("Can't start advertising. \(error)")
    }

    // MARK: MCNearbyServiceBrowserDelegate

    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        var error: NSError?
        if let person = context?.save(info, description: mapping, error: &error) as? Person {
            delegate?.receivedPerson(person)
        } else {
            print("Can't save received person. \(error)")
        }
        foundPerson = true
        browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 10)
        browser.stopBrowsingForPeers()
    }

    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) { }

    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        print("Can't start borwsing. \(error)")
    }

}