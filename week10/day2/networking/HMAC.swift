//
//  HMAC.swift
//  networking
//
//  Created by Nicholas Addison on 5/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import CommonCrypto


// Wrapper class to Crypto Common's CCHmac function
//
// Hash-based Message Authentication Code (HMAC)
// Encrypts a message using a private key (secret) that can then be decrypted using a public key.
// The returned encrypted data is called a digest
// http://en.wikipedia.org/wiki/Hash-based_message_authentication_code
//
// This class also handles conversion between binary data and encoded binary strings in Base64 and Hex formats
//
// convertion of the secret string (private key) to binary data before passing to the HMAC function
// conversion of message string to binary data before passing to HMAC function
// convertsion of data returned from HMAC function (digest) to either Base64 or Hex strings

class HMAC
{
    let algorithm: HMACAAlgorithm
    
    let secretDecoding: BinaryEncoding
    
    let messageEncoding: BinaryEncoding
    let digestEncoding: BinaryEncoding
    
    init(algorithm: HMACAAlgorithm,
        secretDecoding: BinaryEncoding = .UTF8,
        messageEncoding: BinaryEncoding = .UTF8,
        digestEncoding: BinaryEncoding = .Base64 )
    {
        self.algorithm = algorithm
        
        self.secretDecoding = secretDecoding
        self.messageEncoding = messageEncoding
        self.digestEncoding = digestEncoding
    }
    
    func createDigest(messageStr: String, secretStr: String) -> String?
    {
        // if message and secret can be decoded to NSData
        if  let messageData: NSData = self.messageEncoding.encode(messageStr),
            let secretData: NSData = self.secretDecoding.decode(fromEncodedString: secretStr)
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