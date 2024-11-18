//
//  FirstLaunchView.swift
//  Placeholder app
//
//  Created by T Krobot on 17/11/24.
//

import SwiftUI

struct FirstLaunchView: View {
    @Binding var hasOpenedAppBefore : Bool
    var body: some View {
        VStack {
            Button {
                hasOpenedAppBefore = true
            } label: {
                Text("BUTTON \(hasOpenedAppBefore)")
            }
        }
    }
}

#Preview {
    @Previewable @State var hasOpenedAppBefore = false
    FirstLaunchView(hasOpenedAppBefore: $hasOpenedAppBefore)
}
