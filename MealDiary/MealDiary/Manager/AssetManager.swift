//
//  AssetManager.swift
//  MealDiary
//
//  Created by mac on 2019. 1. 26..
//  Copyright © 2019년 clap. All rights reserved.
//


import Foundation
import Photos

struct AssetManager {
    // MARK: - Method
    static func fetchImages(by identifiers: [String]?) -> [PHAsset] {
        let fetchResult: PHFetchResult<PHAsset>
        let fetchOptions = PHFetchOptions()
        
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d",
                                             PHAssetMediaType.image.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        if (identifiers != nil) {
            fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifiers!, options: fetchOptions)
        } else {
            fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        }
        
        let indexSet = IndexSet(0..<fetchResult.count)
        
        return fetchResult.objects(at: indexSet)
    }
    
    static func getAsset(in dictionary: [String: [String]]) -> [String: [PHAsset]]{
        var returnDict: [String: [PHAsset]] = [:]
        
        for key in dictionary.keys {
            if let array = dictionary[key] {
                let images = fetchImages(by: array)
                if images.count != 0 {
                    returnDict[key] = fetchImages(by: array)
                }
            }
        }
        
        return returnDict
    }
    
    static func getArrayData(for key: String) -> [String] {
        if let data = UserDefaults.standard.object(forKey: key) as? Data {
            if let stringArray = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String] {
                return stringArray
            }
        }
        
        return []
    }
    
    static func getDictionaryData(for key: String) -> [String: [String]] {
        if let data = UserDefaults.standard.object(forKey: key) as? Data {
            if let dictionary = NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: [String]] {
                return dictionary
            }
        }
        
        return [:]
    }
    
    static func save(data:Any, for key: String) {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: data)
        userDefaults.set(encodedData, forKey: key)
        userDefaults.synchronize()
    }
}

