//
//  LocalizationManager.swift
//  GeoNotes
//
//  Created by Игорь Пинаев on 23/05/2019.
//  Copyright © 2019 Igor Pinaev. All rights reserved.
//

import Foundation

extension String {
    func localize() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
