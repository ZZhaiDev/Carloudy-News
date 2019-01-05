//
//  HomeViewModel.swift
//  CarloudyNews
//
//  Created by Zijia Zhai on 1/4/19.
//  Copyright © 2019 cognitiveAI. All rights reserved.
//

import UIKit

class HomeViewModel{
    lazy var articles: [Article] = [Article]()
}


extension HomeViewModel{
    func loadNews(str: String, finishesCallBack: @escaping () -> ()){
 "https://newsapi.org/v2/everything?sources=abc-news&apiKey=b7f7add8d89849be8c82306180dac738"
        NetworkTools.requestData(.get, URLString: str) { (result) in
//            ZJPrint(result)
            guard let dict = result as? [String: Any] else { return }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) else{
                return
            }
            do {
                let data = try JSONDecoder().decode(HomeModel.self, from: jsonData)
                var articlesWithImages: [Article] = [Article]()
                if let articles = data.articles{
                    for article in articles{
                        if let validateUrl = article.urlToImage{
                            articlesWithImages.append(article)
                        }
                    }
                }
                self.articles = articlesWithImages
            } catch let jsonError {
                ZJPrint(jsonError)
            }
            
            finishesCallBack()
        }
        
    }
}
