//
//  String+Validation.swift
//  GitHubFollowers
//
//  Created by Aleksandr on 04.07.23.
//

import UIKit

extension String {
    var isValidGitHubUsername: Bool {
        let regex = "^[a-zA-Z0-9](?:[a-zA-Z0-9]|-(?=[a-zA-Z0-9])){0,38}$"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }
}

extension NSMutableAttributedString {
    convenience init(string: String, systemName: String) {
        self.init()
        
        let symbolAttachment = NSTextAttachment()
        
        symbolAttachment.image = UIImage(systemName: systemName)
        append(NSAttributedString(attachment: symbolAttachment))
        
        append(NSAttributedString(string: " "))
        append(NSAttributedString(string: string))
    }
}
