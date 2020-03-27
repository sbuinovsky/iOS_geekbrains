//
//  GetDataService.swift
//  VKclient
//
//  Created by Станислав Буйновский on 17.03.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let apiKey = SessionData.shared.token

private let baseUrl = "https://api.vk.com/method/"

private var parameters: Parameters = [
    "access_token" : apiKey,
    "v" : "5.103"
]

private enum apiMethods: String {
    case friends = "friends.get"
    case groups = "groups.get"
    case photos = "photos.get"
    case groupsSearch = "groups.search"
}

protocol DataServiceProtocol {
    func loadUsers(additionalParameters: [String : Any], completion: @escaping ([User]) -> Void)
    func loadGroups(additionalParameters: [String : Any], completion: @escaping ([Group]) -> Void)
    func loadPhotos(additionalParameters: [String : Any], completion: @escaping ([Photo]) -> Void)
    func getImageByURL(imageURL: String) -> UIImage?
}

class DataService: DataServiceProtocol {

    func loadUsers(additionalParameters: [String : Any], completion: @escaping ([User]) -> Void) {
        
        additionalParameters.forEach { (k,v) in parameters[k] = v }
        
        let url = baseUrl + apiMethods.friends.rawValue
        
        AF.request(url, parameters: parameters).responseJSON { [completion] (response) in
            if let error = response.error {
                print(error)
            } else {
                guard let data = response.data else { return }
                
                let users: [User] = self.usersParser(data: data)

                completion(users)
            }
            
        }
    }

    func loadGroups(additionalParameters: [String : Any], completion: @escaping ([Group]) -> Void) {

        additionalParameters.forEach { (k,v) in parameters[k] = v }
        
        let url = baseUrl + apiMethods.groups.rawValue
        
        AF.request(url, parameters: parameters).responseJSON { [completion] (response) in
            if let error = response.error {
                print(error)
            } else {
                guard let data = response.data else { return }
                
                let groups: [Group] = self.groupsParser(data: data)
                
                completion(groups)
            }
            
        }
    }

    func loadPhotos(additionalParameters: [String : Any], completion: @escaping ([Photo]) -> Void) {
        
        additionalParameters.forEach { (k,v) in parameters[k] = v }
        
        let url = baseUrl + apiMethods.photos.rawValue
        
        AF.request(url, parameters: parameters).responseJSON { [completion] (response) in
            if let error = response.error {
                print(error)
            } else {
                guard let data = response.data else { return }
                
                let photos: [Photo] = self.photosParser(data: data)
                
                completion(photos)
            }
            
        }
    }

    private func usersParser(data: Data) -> [User] {

        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> User in
                
                let user = User()
                user.id = item["id"].intValue
                user.name = item["first_name"].stringValue + " " + item["last_name"].stringValue
                user.avatar = item["photo_200_orig"].stringValue
                
                return user
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    private func groupsParser(data: Data) -> [Group] {

        do {
            let json = try JSON(data: data)
            let array = json["response"]["items"].arrayValue
            
            let result = array.map { item -> Group in
            
                let group = Group()
                
                group.name = item["name"].stringValue
                group.avatar = item["photo_200"].stringValue
                
                print("MARKER_URL \(group.avatar)")
                
                return group
            }
            
            return result
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    private func photosParser(data: Data) -> [Photo] {
    
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

    func getImageByURL(imageURL: String) -> UIImage? {
        let urlString = imageURL
        guard let url = URL(string: urlString) else { return nil }
        
        if let imageData: Data = try? Data(contentsOf: url) {
            return UIImage(data: imageData)
        }
        
        return nil
    }
}