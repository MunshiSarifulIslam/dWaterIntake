//
//  LoadHydrationData.swift
//  dWaterIntake
//
//  Created by Munshi Sariful Islam on 04/06/25.
//

import Foundation

func loadHydrationData() -> HydrationData? {
    guard let url = Bundle.main.url(forResource: "hydration", withExtension: "json") else {
        print("Unable to load data from provide json path")
        return nil
    }
    do {
        let data = try Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        let hydrationDataModel = try decoder.decode(HydrationData.self, from: data)
        
        return hydrationDataModel
    } catch {
        print("Unable to decode json data: \(error)")
        return nil
    }
}
