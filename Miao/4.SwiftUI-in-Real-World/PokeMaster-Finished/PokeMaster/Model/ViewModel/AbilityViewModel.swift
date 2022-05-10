//
//  AbilitiesViewModel.swift
//  PokeMaster
//
//  Created by 王 巍 on 2019/08/09.
//  Copyright © 2019 OneV's Den. All rights reserved.
//

import SwiftUI

/*
 该 ViewModel, 仅仅是做 View 展示的 Transfrom 的工作.
 里面存储 Model, 然后暴露出各个 View 相关的属性, 然后 View 直接使用这些属性, 来配置自己的展示. 
 */
struct AbilityViewModel: Identifiable, Codable {
    
    let ability: Ability
    
    init(ability: Ability) {
        self.ability = ability
    }
    
    var id: Int { ability.id }
    var name: String { ability.names.CN }
    var nameEN: String { ability.names.EN }
    var descriptionText: String { ability.flavorTextEntries.CN.newlineRemoved }
    var descriptionTextEN: String { ability.flavorTextEntries.EN.newlineRemoved }
}

extension AbilityViewModel: CustomStringConvertible {
    var description: String {
        "AbilityViewModel - \(id) - \(self.name)"
    }
}
