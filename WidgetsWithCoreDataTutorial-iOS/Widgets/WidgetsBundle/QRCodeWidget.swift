//
//  QRCodeWidget.swift
//  WidgetsWithCoreDataTutorial-iOS
//
//  Created by kimhyungyu on 2022/11/28.
//

import WidgetKit
import SwiftUI
import Intents

struct QRCodeProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> QRCodeEntry {
        QRCodeEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (QRCodeEntry) -> ()) {
        let entry = QRCodeEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [QRCodeEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = QRCodeEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct QRCodeEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct QRCodeEnytryView : View {
    var entry: QRCodeProvider.Entry
    
    var body: some View {
        Image("widgetQr")
            .resizable()
            .scaledToFill()
    }
}

struct QRCodeWidget: Widget {
    let kind: String = "QRCodeWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: QRCodeProvider()) { entry in
            QRCodeEnytryView(entry: entry)
        }
        .configurationDisplayName("QR Code 위젯")
        .description("QR Code 를 인식할 수 있도록 카메라로 빠르게 접근합니다.")
        .supportedFamilies([.systemSmall])
    }
}

struct QRCodeWidget_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeEnytryView(entry: QRCodeEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
