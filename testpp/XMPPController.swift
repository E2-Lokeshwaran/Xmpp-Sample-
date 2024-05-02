import Foundation
import XMPPFramework

enum XMPPControllerError: Error {
case wrongUserJID

}

extension XMPPController: XMPPStreamDelegate 
{
    //4
    func xmppStreamWillConnect(_ stream: XMPPStream) {
        print("Stream: will connect")
    }

    
//5
    func xmppStreamDidStartNegotiation(_ stream: XMPPStream) {
        print("Stream: starts negotiation...")
    }


    func xmppStream(_ sender: XMPPStream, didReceive trust: SecTrust, completionHandler: ((Bool) -> Void)) {
        print("Stream: didReceive auth...")
            completionHandler(true)
        }

    func xmppStream(_ sender: XMPPStream, willSecureWithSettings settings: NSMutableDictionary) {
            print("=====willSecureWithSettings")
            settings.setObject(true, forKey:GCDAsyncSocketManuallyEvaluateTrust as NSCopying)
        }

    func xmppStreamDidConnect(_ stream: XMPPStream) {

        print("Stream: Connected")
        try! stream.authenticate(withPassword: self.password)
    }


    func xmppStreamDidAuthenticate(_ sender: XMPPStream) {
        self.xmppStream.send(XMPPPresence())
        print("Stream: Authenticated")

    }
}

class XMPPController: NSObject
{
    var xmppStream: XMPPStream
    let hostName: String
    let userJID: XMPPJID
    let hostPort: UInt16
    let password: String

    

    init(hostName: String, userJIDString: String, hostPort: UInt16, password: String) throws {
        guard let userJID = XMPPJID(string: userJIDString) else 
        {
            throw XMPPControllerError.wrongUserJID

        }

        //3
        print("Attempting to connect......")

        
        self.hostName = hostName
        self.userJID = userJID
        self.hostPort = hostPort
        self.password = password

        // Stream Configuration
        self.xmppStream = XMPPStream()
        self.xmppStream.hostName = hostName
        self.xmppStream.hostPort = hostPort
        self.xmppStream.startTLSPolicy = XMPPStreamStartTLSPolicy.allowed
        self.xmppStream.myJID = userJID

        super.init()
        self.xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)

    }
    
    func connect() {

        if !self.xmppStream.isDisconnected {
            return
        }

        try! self.xmppStream.connect(withTimeout: XMPPStreamTimeoutNone)
    }

}

