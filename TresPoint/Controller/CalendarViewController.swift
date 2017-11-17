//
//  CalendarViewController.swift
//  TresPoint
//
//  Created by Shiyu Zhang on 11/6/17.
//  Copyright © 2017 Shiyu Zhang. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController {
    
    let formatter = DateFormatter()
    let outsideMonthColor = UIColor.gray
    let monthColor = UIColor(rgb:0x323232)
    let selectedMonthColor = UIColor(rgb:0x3a294b)
    let currentDateSelectedViewColor = UIColor(rgb: 0x4e3f5d)
    let SatSunColor = UIColor(rgb: 0x7EBCDC)
    let cellId = "CustomCalendarCell"
    
    let icon:UIImageView = {
        let ic = UIImageView()
        ic.image = UIImage(named:"TresPointLogin")
        ic.contentMode = .scaleAspectFill
        ic.translatesAutoresizingMaskIntoConstraints = false
        return ic
    }()
    
    let calendarContainer: UIView = {
        let cc = UIView()
        cc.translatesAutoresizingMaskIntoConstraints = false
        cc.backgroundColor = UIColor.clear
        return cc
    }()
    
    
    let calendarView:JTAppleCalendarView = {
        let cv = JTAppleCalendarView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.clear
        cv.scrollDirection = .horizontal
        cv.scrollingMode = .stopAtEachCalendarFrame
        return cv
    }()
    
    let yearLabel: UILabel = {
        let yl = UILabel()
        yl.text = "2017"
        yl.font = UIFont.systemFont(ofSize: 24)
        yl.adjustsFontSizeToFitWidth = true
        yl.minimumScaleFactor = 0.2
        yl.numberOfLines = 0
        yl.translatesAutoresizingMaskIntoConstraints = false
        return yl
    }()
    
    let monthLabel: UILabel = {
        let ml = UILabel()
        ml.text = "September"
        ml.font = UIFont.systemFont(ofSize: 14)
        ml.adjustsFontSizeToFitWidth = true
        ml.numberOfLines = 0
        ml.minimumScaleFactor = 0.1
        ml.translatesAutoresizingMaskIntoConstraints = false
        return ml
    }()
    
    let weekLabel1: UILabel = {
        let wl = UILabel()
        wl.layer.cornerRadius = 8
        wl.layer.masksToBounds = true
        wl.textAlignment = .center
        wl.backgroundColor = UIColor.black
        wl.textColor = UIColor.white
        wl.translatesAutoresizingMaskIntoConstraints = false
        wl.text = "Sun"
        return wl
    }()
    
    let weekLabel2: UILabel = {
        let wl = UILabel()
        wl.layer.cornerRadius = 8
        wl.textAlignment = .center
        wl.layer.masksToBounds = true
        wl.backgroundColor = UIColor.black
        wl.textColor = UIColor.white
        wl.translatesAutoresizingMaskIntoConstraints = false
        wl.text = "Mon"
        return wl
    }()
    
    let weekLabel3: UILabel = {
        let wl = UILabel()
        wl.layer.cornerRadius = 8
        wl.textAlignment = .center
        wl.layer.masksToBounds = true
        wl.backgroundColor = UIColor.black
        wl.textColor = UIColor.white
        wl.translatesAutoresizingMaskIntoConstraints = false
        wl.text = "Tue"
        return wl
    }()
    
    let weekLabel4: UILabel = {
        let wl = UILabel()
        wl.layer.cornerRadius = 8
        wl.textAlignment = .center
        wl.layer.masksToBounds = true
        wl.backgroundColor = UIColor.black
        wl.textColor = UIColor.white
        wl.translatesAutoresizingMaskIntoConstraints = false
        wl.text = "Wed"
        return wl
    }()
    
    let weekLabel5: UILabel = {
        let wl = UILabel()
        wl.layer.cornerRadius = 8
        wl.textAlignment = .center
        wl.layer.masksToBounds = true
        wl.backgroundColor = UIColor.black
        wl.textColor = UIColor.white
        wl.translatesAutoresizingMaskIntoConstraints = false
        wl.text = "Thu"
        return wl
    }()
    
    let weekLabel6: UILabel = {
        let wl = UILabel()
        wl.layer.cornerRadius = 8
        wl.textAlignment = .center
        wl.layer.masksToBounds = true
        wl.backgroundColor = UIColor.black
        wl.textColor = UIColor.white
        wl.translatesAutoresizingMaskIntoConstraints = false
        wl.text = "Fri"
        return wl
    }()
    
    let weekLabel7: UILabel = {
        let wl = UILabel()
        wl.layer.cornerRadius = 8
        wl.textAlignment = .center
        wl.layer.masksToBounds = true
        wl.backgroundColor = UIColor.black
        wl.textColor = UIColor.white
        wl.translatesAutoresizingMaskIntoConstraints = false
        wl.text = "Sat"
        return wl
    }()
    
    
    lazy var week:UIStackView = {
        let s = UIStackView(frame: self.view.bounds)
        s.axis = .horizontal
        s.distribution = .fillEqually
        s.alignment = .fill
        s.spacing = 5
        s.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        s.backgroundColor = UIColor.clear
        s.addArrangedSubview(weekLabel1)
        s.addArrangedSubview(weekLabel2)
        s.addArrangedSubview(weekLabel3)
        s.addArrangedSubview(weekLabel4)
        s.addArrangedSubview(weekLabel5)
        s.addArrangedSubview(weekLabel6)
        s.addArrangedSubview(weekLabel7)
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(rgb: 0xE5E6E7)
        setupIcon()
        setupContainer()
        //setupStackView()
        setupCalendar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func setupStackView(){
//        calendarContainer.addSubview(week)
//        let constraints:[NSLayoutConstraint] = [
//            week.leadingAnchor.constraint(equalTo: calendarContainer.leadingAnchor),
//            week.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 4),
//            week.trailingAnchor.constraint(equalTo: calendarContainer.trailingAnchor),
//            week.heightAnchor.constraint(equalToConstant: 32)
//        ]
//        NSLayoutConstraint.activate(constraints)
//    }
    
    func setUpCalendarView() {
        //print("setupdelegate")
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.visibleDates { (visibleDates) in
            self.setUpViewsOfCalendar(from: visibleDates)
        }
    }
    
    func setupCalendar(){
        calendarContainer.addSubview(calendarView)
        calendarContainer.addSubview(yearLabel)
        calendarContainer.addSubview(monthLabel)
        calendarContainer.addSubview(week)
        let constraints1:[NSLayoutConstraint] = [
            week.leadingAnchor.constraint(equalTo: calendarContainer.leadingAnchor),
            week.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 4),
            week.trailingAnchor.constraint(equalTo: calendarContainer.trailingAnchor),
            week.heightAnchor.constraint(equalToConstant: 24)
        ]
        NSLayoutConstraint.activate(constraints1)
        
        let constraints: [NSLayoutConstraint] = [
            calendarView.leadingAnchor.constraint(equalTo: calendarContainer.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: calendarContainer.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: week.bottomAnchor,constant:4),
            calendarView.bottomAnchor.constraint(equalTo: calendarContainer.bottomAnchor, constant: -50),
            yearLabel.leadingAnchor.constraint(equalTo: calendarContainer.leadingAnchor),
            yearLabel.topAnchor.constraint(equalTo: calendarContainer.topAnchor),
            yearLabel.widthAnchor.constraint(equalToConstant: 60),
            yearLabel.heightAnchor.constraint(equalToConstant: 30),
            monthLabel.leadingAnchor.constraint(equalTo: calendarContainer.leadingAnchor),
            monthLabel.topAnchor.constraint(equalTo: yearLabel.bottomAnchor),
            monthLabel.widthAnchor.constraint(equalToConstant: 80),
            monthLabel.heightAnchor.constraint(equalToConstant: 24)
        ]
        NSLayoutConstraint.activate(constraints)
        //print("before calendar view")
        calendarView.register(CalendarCell.self, forCellWithReuseIdentifier: cellId)
        //print("after calendar view")
        setUpCalendarView()
    }
    
    func handleCellSelected(view:JTAppleCell?, cellState:CellState) {
        guard let validCell = view as? CalendarCell else {return}
        //print("valid cell")
        if validCell.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellTextColor(view: JTAppleCell? , cellState:CellState) {
        guard let validCell = view as? CalendarCell else {return}
        
        if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            }else {
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }
    
    
    func setupIcon(){
        self.view.addSubview(icon)
        let constraints: [NSLayoutConstraint] = [
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            icon.widthAnchor.constraint(equalToConstant: 120),
            icon.heightAnchor.constraint(equalToConstant: 120)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func setupContainer(){
        view.addSubview(calendarContainer)
        let constraints:[NSLayoutConstraint] = [
            calendarContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarContainer.topAnchor.constraint(equalTo: icon.bottomAnchor, constant:20),
            calendarContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            calendarContainer.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}


extension CalendarViewController: JTAppleCalendarViewDataSource{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 09 01")!
        let endDate = formatter.date(from: "2019 08 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}


extension CalendarViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    //display cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: cellId, for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1
        let cellColor = UIColor(rgb:0xE5E6E7)
        //cell.backgroundColor = cellColor
        cell.layer.borderColor = cellColor.cgColor
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
        
        if cellState.day == .sunday {
            cell.backgroundColor = SatSunColor
        }else if(cellState.dateBelongsTo != .thisMonth){
            cell.backgroundColor = SatSunColor
        }else {
            cell.backgroundColor = cellColor
        }
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpViewsOfCalendar(from: visibleDates)
    }
    
    func setUpViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        yearLabel.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        monthLabel.text = formatter.string(from: date)
        
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        //guard let validCell = cell as? CustomCell else {return}
        handleCellSelected(view: cell, cellState: cellState)
        //validCell.selectedView.isHidden = false
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        //guard let validCell = cell as? CustomCell else {return}
        //validCell.selectedView.isHidden = true
        handleCellSelected(view: cell, cellState: cellState)
    }
}

extension CalendarViewController {
    
    @objc dynamic func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
}

