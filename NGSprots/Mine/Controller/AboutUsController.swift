//
//  AboutUsController.swift
//  NGSprots
//
//  Created by wen xi on 2024/1/10.
//

import UIKit

class AboutUsController: BaseViewController {

    @IBOutlet weak var bgview: UIView!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    private func setUI(){
        title = "About Us"
        addNavBar(.white)
        version.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let attributedText = NSMutableAttributedString(string: "Simple, fast and you can make real money!\n\nBsports covers all the major sporting events across Europe and the world. We have great odds and also great combinations of bets like First Goalscorer and Half-Time/Full-Time. In Live Betting the odds change right up to the 90th minute. On a Saturday there may be as many as 10,000 different bets on offer.\n\nBsports provides professional lottery gaming services, as well as fast and accurate lottery results. We record and report all winning numbers, prizes, winners, prize pool whilst ensuring the results are fair, just and open.\n\nReal winnings\n\nYour winnings are real. You can play the games for free or bet real money and win. You can transfer your winnings straight across to your bank account at any time, whenever you want.\n\nEvery day, thousands of players withdraw their winnings and Bsports guarantees to pay out on all winning bets.")
        attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        textLabel.attributedText = attributedText
    }
    

}
