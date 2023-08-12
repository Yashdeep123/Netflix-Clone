//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Yash Patil on 28/07/23.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> Self {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
