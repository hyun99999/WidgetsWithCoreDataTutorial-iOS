//
//  Color+.swift
//  WidgetsWithCoreDataTutorial-iOS
//
//  Created by kimhyungyu on 2022/11/29.
//

import SwiftUI

extension Color {
    static func backgroundColor(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0)
        case .dark:
            return Color(red: 19.0 / 255.0, green: 20.0 / 255.0, blue: 22.0 / 255.0, opacity: 0.5)
            // ✅ future version 에서 추가적으로 알려지지 않은 case 가 생겼을 때 사용하는 쪽에서 경고를 얻어볼 수 있는 편의 기능을 제공한다.
            // 이때 알려지지 않은 case 에 대한 대응을 할 수 있다.
        @unknown default:
            return Color(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0)
        }
    }
    
    static func userNameColor(for colorScheme: ColorScheme) -> Color {
        switch colorScheme {
        case .light:
            return Color(red: 19.0 / 255.0, green: 20.0 / 255.0, blue: 22.0 / 255.0)
        case .dark:
            return Color(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0)
        @unknown default:
            return Color(red: 19.0 / 255.0, green: 20.0 / 255.0, blue: 22.0 / 255.0)
        }
    }
}
