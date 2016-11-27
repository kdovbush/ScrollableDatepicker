//
//  Created by Dmitry Ivanenko on 01.10.16.
//  Copyright © 2016 Dmitry Ivanenko. All rights reserved.
//

import UIKit


public protocol ScrollableDatepickerDelegate: class {
    func datepicker(_ datepicker: ScrollableDatepicker, didSelectDate date: Date)
    func datepicker(_ datepicker: ScrollableDatepicker, didChangeDate oldDate: Date?, to date: Date)
}


public class ScrollableDatepicker: LoadableFromXibView {
    
    @IBOutlet public weak var collectionView: UICollectionView! {
        didSet {
            let podBundle = Bundle(for: ScrollableDatepicker.self)
            let bundlePath = podBundle.path(forResource: String(describing: type(of: self)), ofType: "bundle")
            var bundle:Bundle? = nil
            
            if bundlePath != nil {
                bundle = Bundle(path: bundlePath!)
            }
            
            let cellNib = UINib(nibName: ScrollableDatepickerDayCell.ClassName, bundle: bundle)
            collectionView.register(cellNib, forCellWithReuseIdentifier: ScrollableDatepickerDayCell.ClassName)
            
            collectionView.backgroundColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
        }
    }
    
    
    // MARK: Configuration properties
    
    public weak var delegate: ScrollableDatepickerDelegate?
    
    public var cellBackgroundColor: UIColor = UIColor(red:0.11, green:0.11, blue:0.11, alpha:1.0)
    public var dateLabelTextColor: UIColor = UIColor.white
    public var monthLabelTextColor: UIColor = UIColor.lightGray
    public var weekDayTextColor: UIColor = UIColor.white
    public var selectedColor: UIColor = UIColor(red: 0.255, green: 0.714, blue: 0.553, alpha: 1.00)
    
    public var previousSelectedDate: Date?
    
    public var cellConfiguration: ((_ cell: ScrollableDatepickerDayCell, _ isWeekend: Bool, _ isSelected: Bool) -> Void)? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var dates = [Date]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var selectedDate: Date? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var currentDay: Date? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    public var numberOfDatesInOneScreen = 5 {
        didSet {
            collectionView.reloadData()
        }
    }
    
}


// MARK: - UICollectionViewDataSource

extension ScrollableDatepicker: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ScrollableDatepickerDayCell.ClassName, for: indexPath) as! ScrollableDatepickerDayCell
        
        let date = dates[indexPath.row]
        let isWeekend = isWeekday(date)
        let isSelected = date.timeIntervalSince1970 == selectedDate?.timeIntervalSince1970
        let isCurrent = date.timeIntervalSince1970 == currentDay?.timeIntervalSince1970
        
        cell.backgroundColor = cellBackgroundColor
        cell.dateLabel.textColor = isCurrent ? selectedColor : dateLabelTextColor
        cell.monthLabel.textColor = monthLabelTextColor
        cell.weekDayLabel.textColor = weekDayTextColor
        
        cell.selectorView.backgroundColor = isSelected ? selectedColor : UIColor.clear
        
        cell.setup(date: date, isWeekend: isWeekend)
        
        if let configuration = cellConfiguration {
            configuration(cell, isWeekend, isSelected)
        }
        
        return cell
    }
    
    private func isWeekday(_ date: Date) -> Bool {
        let day = NSCalendar.current.component(.weekday, from: date)
        return day == 1 || day == 7
    }
    
}


// MARK: - UICollectionViewDelegate

extension ScrollableDatepicker: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = dates[indexPath.row]
        
        previousSelectedDate = selectedDate
        selectedDate = date
        
        delegate?.datepicker(self, didSelectDate: date)
        delegate?.datepicker(self, didChangeDate: previousSelectedDate, to: date)
        
        collectionView.deselectItem(at: indexPath, animated: true)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.reloadData()
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout

extension ScrollableDatepicker: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / CGFloat(numberOfDatesInOneScreen), height: collectionView.frame.height)
    }
    
}
