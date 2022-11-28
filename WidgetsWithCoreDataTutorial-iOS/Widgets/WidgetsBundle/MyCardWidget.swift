//
//  MyCardWidget.swift
//  WidgetsExtension
//
//  Created by kimhyungyu on 2022/11/28.
//

import WidgetKit
import SwiftUI
import Intents

struct MyCardProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> MyCardEntry {
        MyCardEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (MyCardEntry) -> ()) {
        let entry = MyCardEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [MyCardEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = MyCardEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct MyCardEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct MyCardEnytryView : View {
    var entry: MyCardProvider.Entry
    
    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct MyCardWidget: Widget {
    let kind: String = "MyCardWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: MyCardProvider()) { entry in
            MyCardEnytryView(entry: entry)
        }
        .configurationDisplayName("명함 위젯")
        .description("명함 이미지를 보여주고,\n내 명함으로 빠르게 접근합니다.")
        .supportedFamilies([.systemSmall])
    }
}

struct MyCardWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyCardEnytryView(entry: MyCardEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
