//
//  JiraTimeTracking.swift
//  JiraSwiftAPI
//
//  Created by ORIOL.OMNILOG, MAXIME on 10/10/2020.
//

public struct JiraTimeTracking: JiraObject {
    public var remainingEstimate: String?
    public var timeSpent: String?
    public var remainingEstimateSeconds: Int?
    public var timeSpentSeconds: Int?
}
