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
}

class ShakeHandler: NSObject, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {

    weak var delegate: ShakeHandlerDelegate?

    let serviceType = "Handshake"
    let peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
    let mapping = PGMappingDescription(localName: "Person", remoteName: "Person", localIDKey: "name", remoteIDKey: "name", mapping: ["firstName": "firstName", "lastName": "lastName", "email": "email", "phoneNumber": "phoneNumber", "facebookUrl": "facebookUrl", "linkedinUrl": "linkedinUrl", "dateOfBirth": "dateOfBirth"])

    var context: NSManagedObjectContext?

    var advertiser: MCNearbyServiceAdvertiser?
    var browser: MCNearbyServiceBrowser?

    init(delegate: ShakeHandlerDelegate) {
        self.delegate = delegate
    }

    func sendPerson(person: Person, inside context: NSManagedObjectContext) {
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
        let session: MCSession = MCSession(peer: peerID)
        browser.invitePeer(peerID, toSession: session, withContext: nil, timeout: 10)
        browser.stopBrowsingForPeers()
    }

    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) { }

    @objc func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        print("Can't start borwsing. \(error)")
    }

}