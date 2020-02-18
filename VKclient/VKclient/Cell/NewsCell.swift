//
//  NewsTableViewCell.swift
//  VKclient
//
//  Created by Станислав Буйновский on 17.02.2020.
//  Copyright © 2020 Станислав Буйновский. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var likeCounter: UILabel!
    
    //инициализируем базовый объект Like
    let likeBox = Like()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //добавляем обработку нажатия на элемент
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        
        likeImage.addGestureRecognizer(tapGesture)
        likeImage.isUserInteractionEnabled = true
    }
    
    @objc func onTap(_ sender: UIGestureRecognizer) {
        print(#function)
        if likeBox.active == false {
            likeBox.active = true
            likeBox.counter += 1
            likeCounter.text = "\(likeBox.counter)"
            likeImage.image = UIImage(imageLiteralResourceName: "likeImageActive")
        } else {
            likeBox.active = false
            likeBox.counter -= 1
            likeCounter.text = "\(likeBox.counter)"
            likeImage.image = UIImage(imageLiteralResourceName: "likeImageDefault")
        }
        
    }
}