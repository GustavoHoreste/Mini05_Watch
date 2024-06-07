//
//  Complication.swift
//  Complication
//
//  Created by Samu Lima on 07/06/24.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []
        
        // Create a timeline entry for the current date.
        let currentDate = Date()
        let entry = SimpleEntry(date: currentDate)
        entries.append(entry)
        
        // Generate a timeline consisting of a single entry for now.
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct ComplicationEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack{
            if let image = UIImage(named: "49mm"){
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("Image not found")
                    .foregroundColor(.red)
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

@main
struct Complication: Widget {
    let kind: String = "Complication"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ComplicationEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is a sample widget.")
        
    }
}


#Preview(as: .accessoryRectangular) {
    Complication()
} timeline: {
    SimpleEntry(date: .now)
}
