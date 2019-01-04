//
//  HomeModel.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit

//https://newsapi.org/v2/everything?sources=abc-news&apiKey=b7f7add8d89849be8c82306180dac738

struct HomeModel: Codable {
    var articles: [Article]?
}

struct Article: Codable {
    var source: Source?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
}

struct Source: Codable {
    var id: String?
    var name: String?
}
