//
//  ParserService.swift
//  VKclient
//
//  Created by Станислав Буйновский on 12.04.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol ParserServiceProtocol {
    func usersParser(data: Data) -> [User]
    func groupsParser(data: Data) -> [Group]
    func photosParser(data: Data) -> [Photo]
}

class ParserService: ParserServiceProtocol {
    
    private let firebaseService: FirebaseServiceProtocol = FirebaseService()
    
    func usersParser(data: Data) -> [User] {

        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> User in
                
                let user = User()
                user.id = item["id"].intValue
                user.name = item["first_name"].stringValue + " " + item["last_name"].stringValue
                user.avatar = item["photo_200_orig"].stringValue
                
                firebaseService.updateFriends(object: user)
                
                return user
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    
    func groupsParser(data: Data) -> [Group] {

        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> Group in
            
                let group = Group()
                
                group.id = item["id"].intValue
                group.name = item["name"].stringValue
                group.avatar = item["photo_200_orig"].stringValue
                
                firebaseService.updateGroups(object: group)
                
                return group
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    
    func photosParser(data: Data) -> [Photo] {
    
        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> Photo in
                
                let photo = Photo()
                photo.id = item["id"].intValue
                photo.ownerId = item["owner_id"].intValue
                
                let sizeValues = item["sizes"].arrayValue
                if let last = sizeValues.last {
                    photo.imageUrl = last["url"].stringValue
                }
                
                return photo
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
}
