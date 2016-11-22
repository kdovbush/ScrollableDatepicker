//
//  Created by Dmitry Ivanenko on 01.10.16.
//  Copyright © 2016 Dmitry Ivanenko. All rights reserved.
//

import UIKit


public class ScrollableDatepickerDayCell: UICollectionViewCell {
    
    public let selectorColor = UIColor(red: 0.255, green: 0.714, blue: 0.553, alpha: 1.00)
    
    @IBOutlet public weak var dateLabel: UILabel!
    @IBOutlet public weak var weekDayLabel: UILabel!
    @IBOutlet public weak var monthLabel: UILabel!
    @IBOutlet public weak var selectorView: UIView!
    
    static var ClassName: String {
        return String(describing: self)
    }
    
    // MARK: - Setup
    
    func setup(date: Date, isWeekend: Bool) {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd"
        dateLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "EEE"
        weekDayLabel.text = formatter.string(from: date).uppercased()
        
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date).uppercased()
        
        weekDayLabel.font = UIFont.systemFont(ofSize: 8, weight: isWeekend ? UIFontWeightBold : UIFontWeightThin)
    }
    
}
