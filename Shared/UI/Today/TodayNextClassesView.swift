//
//  TodayNextClassesView.swift
//  CA
//
//  Created by Harry Liu on 3/27/24.
//

import SwiftUI

struct TodayNextClassesView: View {
    
    @Binding var schedule: Result<MySchoolAppScheduleList, Error>?
    let formatter = DateFormatter("h:mm a", timeZone: .current)
    
    var body: some View {
        ScrollView {
            Divider()
            switch schedule {
            case .success(let schedule):
                LazyVStack {
                    Text("Next Up:")
                        .fontWeight(.light)
                        .foregroundColor(.accentColor)
                        .frame(alignment: .leading)
                    ForEach(schedule, id: \.startTime) { item in
                        let currentTime = Date()
                        let date = item.date
                        let calendar = Calendar.current
                        let startTime = calendar.date(byAdding: calendar.dateComponents([.hour, .minute], from: formatter.date(from: item.myDayStartTime)!), to: date)
                        let endTime = calendar.date(byAdding: calendar.dateComponents([.hour, .minute], from: formatter.date(from: item.myDayEndTime)!), to: date)
                        if(currentTime < startTime!) {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(item.courseTitle)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                    Text("\(item.block.count == 0 ? "No Block" : item.block) - \(item.roomNumber.count == 0 ? "No Room" : item.roomNumber)")
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 10) {
                                    Text(item.myDayStartTime)
                                    Text(item.myDayEndTime)
                                        .foregroundColor(.secondary)
                                }
                            }
                            if item.startTime != schedule.last?.startTime {
                                Divider()
                            }
                        }
                    }.padding(EdgeInsets(top: 2.5, leading: 10, bottom: 2.5, trailing: 10))
                }
            case .failure(_): Text("Error")
            case nil: VStack {
                Text("Loading...")
                ProgressView()
            }
            }
        }
    }
}


