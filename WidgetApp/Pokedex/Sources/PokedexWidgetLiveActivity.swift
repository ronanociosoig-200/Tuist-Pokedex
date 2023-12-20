//
//  PokedexWidgetLiveActivity.swift
//  PokedexWidget
//
//  Created by ronan.ociosoig on 04/10/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PokedexWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PokedexWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PokedexWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PokedexWidgetAttributes {
    fileprivate static var preview: PokedexWidgetAttributes {
        PokedexWidgetAttributes(name: "World")
    }
}

extension PokedexWidgetAttributes.ContentState {
    fileprivate static var smiley: PokedexWidgetAttributes.ContentState {
        PokedexWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PokedexWidgetAttributes.ContentState {
         PokedexWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PokedexWidgetAttributes.preview) {
   PokedexWidgetLiveActivity()
} contentStates: {
    PokedexWidgetAttributes.ContentState.smiley
    PokedexWidgetAttributes.ContentState.starEyes
}
