//
//  HMAC.swift
//  networking
//
//  Created by Nicholas Addison on 5/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import CommonCrypto

class HMAC
{
    let algorithm: HMACAAlgorithm
    
    let secretEncoding: BinaryEncoding
    let messageEncoding: BinaryEncoding
    let digestEncoding: BinaryEncoding
    
    init(algorithm: HMACAAlgorithm,
        secretEncoding: BinaryEncoding = .UTF8,
        messageEncoding: BinaryEncoding = .UTF8,
        digestEncoding: BinaryEncoding = .Base64 )
    {
        self.algorithm = algorithm
        
        self.secretEncoding = secretEncoding
        self.messageEncoding = messageEncoding
        self.digestEncoding = digestEncoding
    }
    
    func createDigest(messageStr: String, secretStr: String) -> String?
    {
        // if message and secret can be decoded to NSData
        if  let messageData: NSData = self.messageEncoding.encode(messageStr),
            let secretData: NSData = self.secretEncoding.decode(fromEncodedString: secretStr)
        {
            // allocate enough memory for the digested (encrypted) data that will be populated by the HMAC C routine
            let digestPointer = UnsafeMutablePointer<UInt8>.alloc(algorithm.digestLength)
            
            // digest (encrypt) the message parameter using secret (private key) parameter and the class's algorithm property
            // The last parameter, digestPointer, is a pointer to this digested (encypted) data in memory
            CCHmac(algorithm.commonCryptoEnum, secretData.bytes, secretData.length, messageData.bytes, messageData.length, digestPointer)
            
            return digestEncoding.encode(digestPointer, length: algorithm.digestLength)
        }
        else
        {
            return nil
        }
    }
}