//
//  NotificatoinPoster.swift
//  Intoxologist
//
//  Created by Felix Leupold on 30/01/17.
//  Copyright © 2017 Felix Leupold. All rights reserved.
//

import UserNotifications
import Foundation

enum NotificationCategories : String {
  case YesNoCategory = "YesNoCategory"
  case HowMuchCategory = "HowMuchCategory"
}

enum NotificationActions : String {
  case Yes = "Yes"
  case No = "No"
  case Little = "Little"
  case Lot = "Lot"
}

class NotificationPoster : NSObject {
  let notificationCenter: UNUserNotificationCenter
  let recordStore: DrinkingRecordStore
  init(notificationCenter: UNUserNotificationCenter,
       recordStore: DrinkingRecordStore) {
    self.notificationCenter = notificationCenter
    self.recordStore = recordStore
    super.init()
    self.createActions()
  }
  
  func requestNotificationPermissions() -> Void {
    let options: UNAuthorizationOptions = [.alert, .sound];
    self.notificationCenter.requestAuthorization(options: options) {
      (granted, error) in
      if !granted {
        print("Something went wrong")
      }
    }
  }
  
  func scheduleNotification() -> Void {
    if let initialDate = NextEightAm() {
      let content = UNMutableNotificationContent();
      content.body = "Did you drink last night?"
      content.sound = UNNotificationSound.default()
      content.categoryIdentifier = NotificationCategories.YesNoCategory.rawValue;
      
      let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,],
                                                         from: initialDate)
      let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily,
                                                  repeats: true)
      let notification = UNNotificationRequest(identifier:"IntoxologistAssessment",
                                               content:content,
                                               trigger:trigger);
      
      self.notificationCenter.add(notification, withCompletionHandler: { (error) in
        if let error = error {
          print("Could not add notification request becuase %@", error)
        }
      })
    }
  }
  
  func scheduleSecondaryNotification() -> Void {
    let content = UNMutableNotificationContent();
    content.body = "How much did you drink?"
    content.sound = UNNotificationSound.default()
    content.categoryIdentifier = NotificationCategories.HowMuchCategory.rawValue;
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
    let notification = UNNotificationRequest(identifier:"IntoxologistFollowUp",
                                             content:content,
                                             trigger:trigger);
    
    self.notificationCenter.add(notification, withCompletionHandler: { (error) in
      if let error = error {
        print("Could not add notification request becuase %@", error)
      }
    })
  }
  
  private func createActions() {
    let yes = UNNotificationAction(identifier: NotificationActions.Yes.rawValue,
                                   title: "Yes", options: [])
    let no = UNNotificationAction(identifier: NotificationActions.No.rawValue,
                                  title: "No", options: [])
    let yesNoCategory = UNNotificationCategory(identifier: NotificationCategories.YesNoCategory.rawValue,
                                               actions: [yes, no],
                                               intentIdentifiers: [], options: [])
    
    let aLittle = UNNotificationAction(identifier: NotificationActions.Little.rawValue,
                                       title: "A Little", options: [])
    let aLot = UNNotificationAction(identifier: NotificationActions.Lot.rawValue,
                                    title: "A Lot", options: [])
    let howMuchCategory = UNNotificationCategory(identifier: NotificationCategories.HowMuchCategory.rawValue,
                                                 actions: [aLittle, aLot],
                                                 intentIdentifiers: [], options: [])
    self.notificationCenter.setNotificationCategories([yesNoCategory, howMuchCategory])
  }
}

extension NotificationPoster : UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let calendar = Calendar.current
    let ingredients: Set = [Calendar.Component.day,
                            Calendar.Component.year,
                            Calendar.Component.month]
    let components = calendar.dateComponents(ingredients, from: NSDate() as Date)
    if let today = calendar.date(from: components) {
      if let yesterday = calendar.date(byAdding: .day, value: -1, to: today) {
        switch response.actionIdentifier {
        case NotificationActions.Yes.rawValue:
          self.scheduleSecondaryNotification()
        case NotificationActions.Little.rawValue:
          self.recordStore.storeRecord(record: .LittleAlcohol, forDate: yesterday)
        case NotificationActions.Lot.rawValue:
          self.recordStore.storeRecord(record: .Binge, forDate: yesterday)
        default:
          print("Received unhandled action %@", response.actionIdentifier)
        }
      }
    }
    completionHandler()
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.alert,.sound])
  }
}
