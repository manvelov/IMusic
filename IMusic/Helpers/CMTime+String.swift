//
//  CMTime+String.swift
//  IMusic
//
//  Created by Kirill Manvelov on 16.08.2020.
//  Copyright © 2020 Kirill Manvelov. All rights reserved.
//

import Foundation
import AVKit

extension CMTime {
    func toString() -> String {
        guard !CMTimeGetSeconds(self).isNaN else { return ""}
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let formatString = String(format: "%02d:%02d", minutes, seconds)
        return formatString
    }
    
}
