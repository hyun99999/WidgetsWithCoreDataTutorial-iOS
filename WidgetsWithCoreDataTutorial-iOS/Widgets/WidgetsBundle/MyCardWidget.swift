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
        // ✅ CoreData 조회.
        let cardDetail = CoreDataManager.shared.fetch(entityName: "CardDetail")
        let myCardDetail = MyCardDetail(cardName: cardDetail[0].value(forKey: "cardName") as? String ?? "",
                                        userName: cardDetail[0].value(forKey: "userName") as? String ?? "",
                                        cardImage: UIImage(data: cardDetail[0].value(forKey: "cardImage") as? Data ?? Data()) ?? UIImage())
        return MyCardEntry(date: Date(), detail: myCardDetail)
    }
    
    func getSnapshot(for configuration: SelectMyCardIntent, in context: Context, completion: @escaping (MyCardEntry) -> ()) {
        // ✅ CoreData 조회.
        let cardDetail = CoreDataManager.shared.fetch(entityName: "CardDetail")
        let myCardDetail = MyCardDetail(cardName: cardDetail[0].value(forKey: "cardName") as? String ?? "",
                                        userName: cardDetail[0].value(forKey: "userName") as? String ?? "",
                                        cardImage: UIImage(data: cardDetail[0].value(forKey: "cardImage") as? Data ?? Data()) ?? UIImage())
        let entry = MyCardEntry(date: Date(), detail: myCardDetail)
        completion(entry)
    }
    
    func getTimeline(for configuration: SelectMyCardIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [MyCardEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            
            // ✅ CoreData 조회.
            let cardDetail = CoreDataManager.shared.fetch(entityName: "CardDetail")
            
            // ✅ SelectMyCardIntent 에서 전달되는 cardName 을 cardDetail 과 대조해서 동일한 카드를 결정.
            let cardName = configuration.MyCard?.cardName
            
//            MyCardDetail.availableMyCards.forEach { card in
            cardDetail.forEach { card in
                if cardName == card.value(forKey: "cardName") as? String ?? "" {
                    let myCardDetail = MyCardDetail(cardName: card.value(forKey: "cardName") as? String ?? "",
                                                    userName: card.value(forKey: "userName") as? String ?? "",
                                                    cardImage: UIImage(data: card.value(forKey: "cardImage") as? Data ?? Data()) ?? UIImage())
                    let entry = MyCardEntry(date: entryDate, detail: myCardDetail)
                    entries.append(entry)
                }
            }
        }
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct MyCardEntry: TimelineEntry {
    let date: Date
    let detail: MyCardDetail
}

struct MyCardEnytryView : View {
    var entry: MyCardProvider.Entry
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color.white
            GeometryReader { proxy in
                HStack(spacing: 0) {
                    Image(uiImage: entry.detail.cardImage)
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
                    Text(entry.detail.cardName)
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
                    Text(entry.detail.userName)
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
        MyCardEnytryView(entry: MyCardEntry(date: Date(), detail: MyCardDetail.availableMyCards[0]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
