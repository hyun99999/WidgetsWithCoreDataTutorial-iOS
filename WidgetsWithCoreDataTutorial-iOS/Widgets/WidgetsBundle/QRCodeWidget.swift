//
//  QRCodeWidget.swift
//  WidgetsWithCoreDataTutorial-iOS
//
//  Created by kimhyungyu on 2022/11/28.
//

import WidgetKit
import SwiftUI

struct QRCodeProvider: TimelineProvider {
    func placeholder(in context: Context) -> QRCodeEntry {
        QRCodeEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (QRCodeEntry) -> ()) {
        let entry = QRCodeEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [QRCodeEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = QRCodeEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct QRCodeEntry: TimelineEntry {
    let date: Date
}

struct QRCodeEntryView : View {
    var entry: QRCodeProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .accessoryCircular:
                Image("widgetQr")
                    .resizable()
                    .widgetURL(URL(string: "openQRCode"))
        @unknown default:
            Image("widgetQr")
                .resizable()
                .scaledToFill()
                .widgetURL(URL(string: "openQRCode"))
        }
    }
}

struct QRCodeWidget: Widget {
    let kind: String = "QRCodeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: QRCodeProvider()) { entry in
            QRCodeEntryView(entry: entry)
        }
        .configurationDisplayName("QR Code 위젯")
        .description("QR Code 를 인식할 수 있도록 카메라로 빠르게 접근합니다.")
        .supportedFamilies([.systemSmall, .accessoryCircular])
    }
}

struct QRCodeWidget_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeEntryView(entry: QRCodeEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        QRCodeEntryView(entry: QRCodeEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}
