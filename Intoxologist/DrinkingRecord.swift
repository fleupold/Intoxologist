//
//  RecordStore.swift
//  Intoxologist
//
//  Created by Felix Leupold on 24/01/17.
//  Copyright © 2017 Felix Leupold. All rights reserved.
//

import Foundation

enum DrinkingRecord {
  case NoAlcohol
  case LittleAlcohol
  case Binge
  
   init(index: Int) {
    switch index {
    case 0:
      self = .NoAlcohol
    case 1:
      self = .LittleAlcohol
    case 2:
      self = .Binge
    default:
      self = .NoAlcohol
    }
  }
  
  func toIndex() -> Int {
    switch self {
    case .NoAlcohol:
      return 0
    case .LittleAlcohol:
      return 1
    case .Binge:
      return 2
    }
  }
}

protocol DrinkingRecordStoreListening: class {
  func didStoreRecord(forDate date: Date) -> Void;
}

let DrinkingRecordsKey = "DrinkingRecordsKey"

class DrinkingRecordStore {
  let userDefaults: UserDefaults;
  weak var storeListener: DrinkingRecordStoreListening?;
  init(userDefaults: UserDefaults, listener: DrinkingRecordStoreListening) {
    self.userDefaults = userDefaults
    self.storeListener = listener
  }
  
  func loadRecord(forDate date: Date) -> DrinkingRecord? {
    let records = self.userDefaults.dictionary(forKey: DrinkingRecordsKey)
    if (records?[date.description] as? Int != nil) {
      let enumIndex = records![date.description]
      return DrinkingRecord(index: enumIndex as! Int)
    } else {
      return nil
    }
  }
  
  func storeRecord(record: DrinkingRecord, forDate date: Date) {
    var records = self.userDefaults.dictionary(forKey: DrinkingRecordsKey) ?? Dictionary()
    records.updateValue(record.toIndex(), forKey: date.description)
    self.userDefaults.set(records, forKey: DrinkingRecordsKey)
    self.storeListener?.didStoreRecord(forDate: date);
  }
}
