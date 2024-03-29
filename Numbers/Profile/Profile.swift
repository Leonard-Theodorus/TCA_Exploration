//
//  Profile.swift
//  Numbers
//
//  Created by Alonica🐦‍⬛🐺 on 29/02/24.
//

import Foundation

struct Profile : Equatable{
    let id : Int
    let email : String
    let firstName : String
    let lastName : String
    
    var name : String {
        firstName + " " + lastName
    }
}

extension Profile{
    static let mock = Profile(id: 1, email: "mail@mail.com", firstName: "Milla", lastName: "Ivanovich")
}

extension Profile : Decodable{
    enum ProfileKeys : String, CodingKey{
        case id
        case email
        case name
        case firstName = "firstname"
        case lastName = "lastname"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProfileKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.email = try container.decode(String.self, forKey: .email)
        
        let nameContainer = try container.nestedContainer(keyedBy: ProfileKeys.self, forKey: .name)
        self.firstName = try nameContainer.decode(String.self, forKey: .firstName)
        self.lastName = try nameContainer.decode(String.self, forKey: .lastName)
    }
}
