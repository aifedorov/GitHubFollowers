//
//  String+Validation.swift
//  GitHubFollowers
//
//  Created by Aleksandr on 04.07.23.
//

import Foundation

extension String {
    var isValidGitHubUsername: Bool {
        let regex = "^[a-zA-Z0-9](?:[a-zA-Z0-9]|-(?=[a-zA-Z0-9])){0,38}$"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }
}
