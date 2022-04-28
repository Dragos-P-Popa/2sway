//
//  BrandBrain.swift
//  progressBar2
//
//  Created by user201027 on 8/2/21.
//

import Foundation
import UIKit

class BrandBrain {
    
    func buildSampleBrandList() -> [Brand] {
        let brands: [Brand] = [
            Brand(brandID: "DST", name: "Distrikt Bar", desc: K.SampleData.brandDesc, maxDiscount: 40, brandImage: UIImage(named: K.SampleBrandLogos.distriktLogo)!),
            Brand(brandID: "PXL", name: "Pixel Bar", desc: K.SampleData.brandDesc, maxDiscount: 50, brandImage: UIImage(named: K.SampleBrandLogos.pixelBarLogo)!),
            Brand(brandID: "WHRT", name: "The White Hart", desc: K.SampleData.brandDesc, maxDiscount: 30, brandImage: UIImage(named: K.SampleBrandLogos.fullersLogo)!),
            Brand(brandID: "PT", name: "The Packhorse & Talbot", desc: K.SampleData.brandDesc, maxDiscount: 60, brandImage: UIImage(named: K.SampleBrandLogos.greeneKingLogo)!),
            Brand(brandID: "REV", name: "Revolution", desc: K.SampleData.brandDesc, maxDiscount: 45, brandImage: UIImage(named: K.SampleBrandLogos.revsLogo)!)
        ]
        
        return brands
    }
    
    func buildBrandList() -> [Brand] {
        let brands: [Brand] = [
            
            Brand(brandID: "PIX",
                  name: "Pixel Bar",
                  desc: """
                    Pixel is a bar dedicated to video games. Book one of our console booths and enjoy our unique cocktail menu inspired by the games we love! Come find out why we’re the #1 rated nightlife venue in Yorkshire!
                    Students get 2-4-£9 on cocktails plus tonnes of other student offers all day every day.
                    """,
                  maxDiscount: 60,
                  brandImage: UIImage(named: "pixelBarLogo")!),
            
            Brand(brandID: "ROL",
                  name: "Rola Wala",
                  desc: """
'...street food that will change your life.' - BUZZFEED
Epic street food flavours discovered on Kolkata backstreets, Bombay beaches, and Keralan waterways led Aussie traveller Mark Wright on a journey, to bring the incredible experience of Indian street food to the UK. Based in Trinity Kitchen, Rola Wala is famous for is spice-fuelled naan rolls, rice bowls, and healthy Indian options.
""",
                  maxDiscount: 40,
                  brandImage: UIImage(named: "rolaWalaLogo")!),
            
            
            Brand(brandID: "YAC",
                  name: "Yard and Coop",
                  desc: """
                    Yard and Coop is the home of booze & buttermilk fried chicken. We’ve eaten tonnes of the good stuff in our time and have spent YEARS perfecting our secret recipe. Golden, crispy and juicy is the name of the game. \n Enjoy delicious cocktails, craft beer and 10p wings in our glamorous yet snug main bar. Head up the pink staircase to find our main restaurant. The home of bottomless brunch, drag shows and hot sauce challenges - we’re serving up a whole lot more than fried chicken on the regular. And it’s all HOT.
                    """,
                  maxDiscount: 60,
                  brandImage: UIImage(named: "yard&CoopLogo")!),
           
            Brand(brandID: "NAM",
                  name: "Nam Song",
                  desc: "A truly unique Coffee Shop, Restaurant, and Bar located in the heart of Leeds. You should be able to visit us at any point of the day and experience all different aspects of a day in Vietnam! Look out for the place with all the Lanterns and Orange Walls!",
                  maxDiscount: 20,
                  brandImage: UIImage(named: "namSongLogo")!)
        ]
        
        return brands
    }
    
    func getBrandFromID(brandID: String) -> Brand? {
        let brands = BrandBrain().buildBrandList()
        for brand in brands {
            if brand.brandID == brandID {
                return brand
            }
        }
        print("Brand could not be found")
        return nil
    }
}
