//
//  OpenAppLockScreenWidget.swift
//  WidgetsExtension
//
//  Created by kimhyungyu on 2023/01/13.
//

import WidgetKit
import SwiftUI

struct OpenAppLockScreenProvider: TimelineProvider {
    func placeholder(in context: Context) -> OpenAppLockScreenEntry {
        OpenAppLockScreenEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (OpenAppLockScreenEntry) -> ()) {
        let entry = OpenAppLockScreenEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [OpenAppLockScreenEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = OpenAppLockScreenEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct OpenAppLockScreenEntry: TimelineEntry {
    let date: Date
}

struct OpenAppLockScreenEntryView : View {
    var entry: OpenAppLockScreenProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .accessoryCircular:
            // 일관된 배경을 위젯에 주기 위해서 추가.
            ZStack {
                AccessoryWidgetBackground()
                Image("logoNada")
                    .resizable()
                // 원본 이미지의 색상을 그대로 사용하니 흐릿해서 진하게 표현하고자 다음의 코드를 사용.
                    .renderingMode(.template)
                    .tint(.white)
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            }
        @unknown default:
            Image("logoNada")
        }
    }
}

struct OpenAppLockScreenWidget: Widget {
    let kind: String = "OpenAppLockScreen"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: OpenAppLockScreenProvider()) { entry in
            OpenAppLockScreenEntryView(entry: entry)
        }
        .configurationDisplayName("나다 NADA")
        .description("나다 NADA를 실행합니다.")
        .supportedFamilies([.accessoryCircular])
    }
}

struct OpenAppLockScreenWidget_Previews: PreviewProvider {
    static var previews: some View {
        OpenAppLockScreenEntryView(entry: OpenAppLockScreenEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .accessoryCircular))
    }
}
