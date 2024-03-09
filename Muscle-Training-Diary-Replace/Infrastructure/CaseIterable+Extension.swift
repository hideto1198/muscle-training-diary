//
//  CaseIterable+Extension.swift
//  Muscle-Training-Diary-Replace
//
//  Created by 東　秀斗 on 2024/02/27.
//

import Foundation

extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let all = Self.allCases
        let index = all.firstIndex(of: self)!
        let next = all.index(after: index)
        return all[next == all.endIndex ? all.startIndex : next]
    }
    
    func back() -> Self {
        let all = Self.allCases
        let index = all.firstIndex(where: { $0 == self })
        let back = index as! Int - 1
        return all[back == -1 ? all.endIndex as! Int - 1 as! Self.AllCases.Index : back as! Self.AllCases.Index]
    }
}
