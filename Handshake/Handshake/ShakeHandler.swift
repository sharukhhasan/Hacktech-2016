//
//  ShakeHandler.swift
//  Handshake
//
//  Created by Justin Jia on 2/27/16.
//  Copyright © 2016 TintPoint. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import PGMappingKit

protocol ShakeHandlerDelegate: class {
    func receivedPerson(person: Person)
}

class ShakeHandler: NSObject, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {

    weak var delegate: ShakeHandlerDelegate?

    let serviceType = "Handshake"
    let peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
    let personDescription = PGMappingDescription(localName: "Person", remoteName: "Person", localIDKey: "name", remoteIDKey: "name", mapping: ["firstName": "firstName", "lastName": "lastName", "email": "email"])

    var timeInterval: NSTimeInterval?
    var context: NSManagedObjectContext?

    var advertiser: MCNearbyServiceAdvertiser?
    var browser: MCNearbyServiceBrowser?

    func sendPerson(person: Person, inside context: NSManagedObjectContext) {
        self.context = context
        timeInterval = NSDate().timeIntervalSince1970

        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: ["TimeInterval" : String(timeInterval)], serviceType: serviceType)
        browser = MCNearbyServiceBrowser(peer: peerID, serviceType: serviceType)

        advertiser?.startAdvertisingPeer()
        browser?.startBrowsingForPeers()
    }

    // MARK: MCNearbyServiceAdvertiserDelegate

    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession) -> Void) {
        advertiser.stopAdvertisingPeer()

        let session: MCSession = MCSession(peer: peerID)
        invitationHandler(false, session)
    }

    @objc func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        print(error)
    }

    // MARK: MCNearbyServiceBrowserDelegate

    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        var error: NSError?
        if let person = context?.save(info, description: personDescription, error: &error) as? Person {
            delegate?.receivedPerson(person)
        } else {
            print(error)
        }
        let session: MCSession = MCSession(peer: peerID)
        browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 10)
        browser.stopBrowsingForPeers()
    }

    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) { }

    @objc func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        print(error)
    }

}