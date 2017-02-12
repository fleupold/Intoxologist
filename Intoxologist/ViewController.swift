//
//  ViewController.swift
//  Intoxologist
//
//  Created by Felix Leupold on 23/01/17.
//  Copyright © 2017 Felix Leupold. All rights reserved.
//

import UIKit
import CVCalendar

class ViewController: UIViewController  {
  
  @IBOutlet weak var menuView: CVCalendarMenuView!
  @IBOutlet weak var calendarView: CVCalendarView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var recordSelectioView: UIView!
  var recordStore: DrinkingRecordStore!
  
  @IBAction func indexChanged(sender: UISegmentedControl) {
    let date = Date(fromCVDate: self.calendarView.presentedDate)
    var record: DrinkingRecord = .Binge
    if (sender.selectedSegmentIndex == 1) {
      record = .LittleAlcohol
    } else if (sender.selectedSegmentIndex == 0) {
      record = .NoAlcohol
    }
    
    self.recordStore.storeRecord(record: record, forDate: date)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    menuView.commitMenuViewUpdate()
    calendarView.commitCalendarViewUpdate()
  }
  
}

extension ViewController: CVCalendarMenuViewDelegate, CVCalendarViewDelegate {
  
  func presentationMode() -> CalendarMode {
    return .monthView
  }
  
  func firstWeekday() -> Weekday {
    return .sunday
  }
  
  func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
    let date = Date(fromDayView: dayView)
    return self.recordStore.loadRecord(forDate: date) != nil
  }
  
  func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
    let date = Date(fromDayView: dayView)
    switch self.recordStore.loadRecord(forDate: date)! {
    case .NoAlcohol:
      return [.green]
    case .LittleAlcohol:
      return [.yellow]
    case .Binge:
      return [.red]
    }
  }
  
  func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
    return 15.0;
  }
  
  func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
    let date = Date(fromDayView: dayView)
    self.recordSelectioView.isHidden = date > NSDate() as Date;
    
    switch (self.recordStore.loadRecord(forDate: date)) {
    case .some(let record):
      switch record {
      case .NoAlcohol:
        self.segmentedControl.selectedSegmentIndex = 0;
      case .LittleAlcohol:
        self.segmentedControl.selectedSegmentIndex = 1;
      case .Binge:
        self.segmentedControl.selectedSegmentIndex = 2;
      }
    default:
      self.segmentedControl.selectedSegmentIndex = 0;
    }
  }
}

extension ViewController: DrinkingRecordStoreListening {
  func didStoreRecord(forDate date: Date) {
    self.calendarView.contentController.refreshPresentedMonth()
  }
}

