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
        MyCardEntry(date: Date(), configuration: SelectMyCardIntent())
    }
    
    func getSnapshot(for configuration: SelectMyCardIntent, in context: Context, completion: @escaping (MyCardEntry) -> ()) {
        let entry = MyCardEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: SelectMyCardIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
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
    // TODO: - CoreData 를 사용해서 container app 과 데이터 공유.
    let configuration: SelectMyCardIntent
}

struct MyCardEnytryView : View {
    var entry: MyCardProvider.Entry
    @Environment(\.colorScheme) var colorScheme
    
    // TODO: - MyCardEntry 에 있는 변수를 사용해서 동적으로 컨텐츠 대응.
    // TODO: - 초기 상태는 아무런 선택 목록을 선택하지 않으므로(nil), 첫 번째 목록을 할당.
    
    var body: some View {
        ZStack {
            Color.white
            GeometryReader { proxy in
                HStack(spacing: 0) {
                    Image("imgCardWidget")
                        .resizable()
                    // ✅ aspectRatio(width: 너비, height: 높이, contentMode: .fill) 코드에서 지정하는 비율과 크기는 contentMode 에 대한 비율과 크기이다.(전체 frame 이 아님. 그래서 추후에 frame 에 대한 코드를 작성해주면 된다.)
                    // 현재 aspect ratio 를 그대로 사용하고 싶다면 contentMode 파라미터만 채워주면 된다.
                        .aspectRatio(contentMode: .fill)
                    // ✅ GeometryReader 의 GeometryProxy 사용해서 높이 값에 대한 너비를 비율로 사용.
                        .frame(width: proxy.size.height * (92 / 152), height: proxy.size.height)
                        .clipped()
                    Color.backgroundColor(for: colorScheme)
                }
            }
            VStack {
                HStack {
                    Text(entry.configuration.MyCard?.cardName ?? "✅")
                        .font(.system(size: 15))
                        .foregroundColor(.init(white: 1.0, opacity: 0.8))
                        .padding(EdgeInsets(top: 12, leading: 10, bottom: 0, trailing: 0))
                        .lineLimit(1)
                    Spacer()
                    Image("logoNada")
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                }
                Spacer()
                HStack {
                    Spacer()
                    Text("userName")
                        .font(.system(size: 15))
                        .foregroundColor(.userNameColor(for: colorScheme))
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 11, trailing: 10))
                        .lineLimit(1)
                    
                    // ✅ 아래와 같이 삼항 연산자를 활용해서 사용할 수도 있다.
//                        .foregroundColor(colorScheme == .light ? Color(red: 19.0 / 255.0, green: 20.0 / 255.0, blue: 22.0 / 255.0) : Color(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0))
                }
            }
        }
    }
}

struct MyCardWidget: Widget {
    let kind: String = "MyCardWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: SelectMyCardIntent.self,
                            provider: MyCardProvider()) { entry in
            MyCardEnytryView(entry: entry)
        }
        .configurationDisplayName("명함 위젯")
        .description("명함 이미지를 보여주고,\n내 명함으로 빠르게 접근합니다.")
        .supportedFamilies([.systemSmall])
    }
}

struct MyCardWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyCardEnytryView(entry: MyCardEntry(date: Date(), configuration: SelectMyCardIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
