//
//  ViewController.swift
//  TDChristian InfoBoard
//
//  Created by Ethan Vander Kooi on 2018-02-15.
//  Copyright © 2018 Next Development. All rights reserved.
//

import UIKit

struct InfoBoard: Codable {
    
    var topMessageData: Array<String>?
    let bottomMessageData: Array<String>?
    let periodsData: Array<Array<String>>?
    
    private enum CodingKeys: String, CodingKey {
        case topMessageData = "5"
        case bottomMessageData = "6"
        case periodsData = "4"
    }
}

struct Period {
    var view: UIStackView!
    var nameLabel: UILabel!
    var timeLabel: UILabel!
    var value: Int!
    var name: String!
    var startTime: String!
    var endTime: String!
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var topMessage: UILabel!
    @IBOutlet weak var period1: UIStackView!
    @IBOutlet weak var period2: UIStackView!
    @IBOutlet weak var period3: UIStackView!
    @IBOutlet weak var period4: UIStackView!
    @IBOutlet weak var period5: UIStackView!
    @IBOutlet weak var period6: UIStackView!
    @IBOutlet weak var period7: UIStackView!
    @IBOutlet weak var period1Name: UILabel!
    @IBOutlet weak var period2Name: UILabel!
    @IBOutlet weak var period3Name: UILabel!
    @IBOutlet weak var period4Name: UILabel!
    @IBOutlet weak var period5Name: UILabel!
    @IBOutlet weak var period6Name: UILabel!
    @IBOutlet weak var period7Name: UILabel!
    @IBOutlet weak var period1Time: UILabel!
    @IBOutlet weak var period2Time: UILabel!
    @IBOutlet weak var period3Time: UILabel!
    @IBOutlet weak var period4Time: UILabel!
    @IBOutlet weak var period5Time: UILabel!
    @IBOutlet weak var period6Time: UILabel!
    @IBOutlet weak var period7Time: UILabel!
    @IBOutlet weak var bottomMessage: UILabel!
    
    func retrieveInfoBoardData() {
        
        let url = URL(string: "http://splash.tdchristian.ca/apps/if2/getScreenData.php")
        
        URLSession.shared.dataTask(with: url!) { (data, response
        , error) in
            
            
            guard let data = data else { return }
            do {
                
                let decoder = JSONDecoder()
                let infoBoardData = try decoder.decode(InfoBoard.self, from: data)
                
                let periodViewsArray = [self.period1, self.period2, self.period3, self.period4, self.period5, self.period6, self.period7]
                let periodNameLabelsArray = [self.period1Name, self.period2Name, self.period3Name, self.period4Name, self.period5Name, self.period6Name, self.period7Name]
                let periodTimeLabelsArray = [self.period1Time, self.period2Time, self.period3Time, self.period4Time, self.period5Time, self.period6Time, self.period7Time]
                
                var periods: [Period] = []
                
                let periodCount = infoBoardData.periodsData!.count
                
                for i in 0...periodCount-1 {
                    
                    let currentPeriod = infoBoardData.periodsData![i]
                    
                    periods.append(Period(view: periodViewsArray[i], nameLabel: periodNameLabelsArray[i], timeLabel: periodTimeLabelsArray[i], value: i, name: currentPeriod[0], startTime: currentPeriod[1], endTime: currentPeriod[2]))
                }
                
                DispatchQueue.main.sync {
                    self.displayInfoBoardData(top: infoBoardData.topMessageData![1], bottom: infoBoardData.bottomMessageData![1], periods: periods)
                }
            } catch let err {
                print("Err", err)
            }
        }.resume()
        
    }
    
    func displayInfoBoardData(top: String, bottom: String, periods: [Period]) {
        topMessage.text = top
        bottomMessage.text = bottom
        
        period1.isHidden = true
        period2.isHidden = true
        period3.isHidden = true
        period4.isHidden = true
        period5.isHidden = true
        period6.isHidden = true
        period7.isHidden = true
        
        let dateFormatter = DateFormatter()
        
        for period in periods {
            period.view?.isHidden = false
            period.nameLabel.text = period.name
            var time = ""
            
            dateFormatter.dateFormat = "HH:mm"
            let startTime = dateFormatter.date(from: (period.startTime)!)
            dateFormatter.dateFormat = "h:mm"
            time = dateFormatter.string(from: startTime!) + " - "
            
            dateFormatter.dateFormat = "HH:mm"
            let endTime = dateFormatter.date(from: (period.endTime)!)
            dateFormatter.dateFormat = "h:mm"
            time.append(dateFormatter.string(from: endTime!))
            
            period.timeLabel.text = time
            
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.retrieveInfoBoardData()
    }


}

