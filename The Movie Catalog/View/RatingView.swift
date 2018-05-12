//
//  RatingView.swift
//  The Movie Catalog
//
//  Created by Владимир Бондарь on 4/28/18.
//  Copyright © 2018 vbbv. All rights reserved.
//

import UIKit

class RatingView: UIView {

    private var backView = UIView()

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    func set(vote: Double) {
        backView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(vote)*(self.frame.width/10),
                                height: self.frame.height)
        backView.backgroundColor = .red
        addSubview(backView)
        self.backgroundColor = .black
        for counter in 0...9 {
            let star = UIImageView(image: UIImage(named: "lilstar"))
            star.frame = CGRect(x: CGFloat( self.frame.width/10 * CGFloat(counter)),
                                y: CGFloat(0), width: self.frame.width/10, height: self.frame.height)
            addSubview(star)
        }
    }
}
