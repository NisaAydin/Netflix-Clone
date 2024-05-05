//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Nisa Aydin on 20.03.2024.
//

import Foundation

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased()+self.lowercased().dropFirst()
    }
}
