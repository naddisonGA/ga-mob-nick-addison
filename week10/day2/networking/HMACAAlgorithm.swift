//
//  HMACAlgorithm.swift
//  networking
//
//  Created by Nicholas Addison on 4/05/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import CommonCrypto

enum HMACAAlgorithm
{
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var commonCryptoEnum: CCHmacAlgorithm
    {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int
    {
        var result: Int32 = 0
        
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        
        return Int(result)
    }
}
