//
//  ViewController.swift
//  AsyncImageLoadingTest
//
//  Created by Thomas Lam on 22/9/2018.
//  Copyright © 2018年 Thomas Lam. All rights reserved.
//

import UIKit
import SDWebImage
import Kingfisher

final class ViewController: UIViewController {
    let session = URLSession.shared
    let url = URL.init(string: "https://www.gratus.com.hk/PublicImages/Marketing_Image/201808/reenex_gelplus_20180824_Desktop.jpg")!
    //let url = URL.init(string:"https://flyers.dancedeets.com/1579761148982232")!
    let skittle = UIImage.init(named: "skittles")
    
    @IBOutlet weak var ivBanner: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetImage()
    }
    
    func resetImage() {
        DispatchQueue.main.async {
            self.ivBanner.image = self.skittle
        }
    }
    
    @IBAction func normalMethod(_ sender: Any) {
        resetImage()
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    self.ivBanner.image = UIImage.init(data: data)
                }
                
            }
        }.resume()
    }
    
    @IBAction func loadImageWithCache(_ sender: Any) {
        self.ivBanner.sd_setImage(with: url, placeholderImage: skittle)
    }
    
    @IBAction func loadImageWithoutCache(_ sender: Any) {
        self.ivBanner.kf.setImage(with: url, placeholder: skittle, options: [.forceRefresh], progressBlock: nil) { (image, error, cachetype, url) in
        let documentsDirectoryURL = try! FileManager().url(for:
                .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:
                true)
        let fileURL = documentsDirectoryURL.appendingPathComponent("Temp.png")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch {
                print(error)
            }
        }
        
        do {
            try image!.pngData()!.write(to: fileURL)
            print("Image Added Successfully")
        } catch {
            print(error)
        }
        
        }
    }
}
