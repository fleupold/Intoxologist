//
//  CVCalendarHelpers.swift
//  Intoxologist
//
//  Created by Felix Leupold on 24/01/17.
//  Copyright © 2017 Felix Leupold. All rights reserved.
//

import Foundation
import CVCalendar

func Date(fromDayView dayView: DayView) -> Date {
    return Date(fromCVDate: dayView.date)
}

func Date(fromCVDate date: CVDate) -> Date {
  return DateComponents(calendar: .current,
                        year: date.year,
                        month: date.month,
                        day:date.day).date!
}

func NextEightAm() -> Date? {
  let now = NSDate() as Date
  var dayOffsetComponent = DateComponents()
  dayOffsetComponent.day = Calendar.current.component(.hour, from: now) < 19 ? 0 : 1;
  let calendar = Calendar.current
  if let day = calendar.date(byAdding: dayOffsetComponent, to: now) {
    let components: Set<Calendar.Component> = [.era, .year, .month, .day]
    var validTime = calendar.dateComponents(components, from: day)
    validTime.hour = 19
    if let nextTime = calendar.date(from: validTime)  {
      return nextTime
    }
    
  }
  return nil
}
