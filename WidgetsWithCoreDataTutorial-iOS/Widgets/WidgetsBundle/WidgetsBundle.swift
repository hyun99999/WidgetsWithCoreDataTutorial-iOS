//
//  WidgetsBundle.swift
//  Widgets
//
//  Created by kimhyungyu on 2022/11/18.
//

import WidgetKit
import SwiftUI

@main
struct WidgetsBundle: WidgetBundle {
    var body: some Widget {
        // 순서대로 위젯 목록을 구성합니다.
        MyCardWidget()
        OpenAppLockScreenWidget()
        QRCodeWidget()
        WidgetsLiveActivity()
    }
}
