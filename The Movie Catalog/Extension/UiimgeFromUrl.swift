//
//  UiimgeFromUrl.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 4/28/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit
extension UIImageView{

    func addImageFromURL(urlMovie: String?) {
        if urlMovie == nil{
            self.image = #imageLiteral(resourceName: "background")
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: "https://image.tmdb.org/t/p/w780"+urlMovie!),
                let imgData = try? Data(contentsOf: url),
                let img = UIImage(data: imgData){
                DispatchQueue.main.async{
                    self.image =  img
                }
            }
        }
    }
}
