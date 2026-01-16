import WidgetKit
import SwiftUI

struct DiskInfoEntry: TimelineEntry {
    let date: Date
    let diskInfo: DiskInfo
}

struct DiskInfoProvider: TimelineProvider {
    func placeholder(in context: Context) -> DiskInfoEntry {
        DiskInfoEntry(date: Date(), diskInfo: .placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (DiskInfoEntry) -> Void) {
        let entry = DiskInfoEntry(
            date: Date(),
            diskInfo: DiskInfoService.shared.getDiskInfo()
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DiskInfoEntry>) -> Void) {
        let currentDate = Date()
        let diskInfo = DiskInfoService.shared.getDiskInfo()

        let entry = DiskInfoEntry(date: currentDate, diskInfo: diskInfo)

        // Refresh every 15 minutes (WidgetKit minimum)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!

        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}

struct DiskInfoWidgetEntryView: View {
    var entry: DiskInfoProvider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(diskInfo: entry.diskInfo)
        case .systemMedium:
            MediumWidgetView(diskInfo: entry.diskInfo)
        default:
            SmallWidgetView(diskInfo: entry.diskInfo)
        }
    }
}

struct SmallWidgetView: View {
    let diskInfo: DiskInfo

    var progressColor: Color {
        if diskInfo.usagePercentage > 90 {
            return .red
        } else if diskInfo.usagePercentage > 75 {
            return .orange
        }
        return .blue
    }

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 8)

                Circle()
                    .trim(from: 0, to: CGFloat(diskInfo.usagePercentage / 100))
                    .stroke(progressColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text("\(Int(diskInfo.usagePercentage))%")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    Text("used")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 80, height: 80)

            Text(diskInfo.freeFormatted)
                .font(.caption)
                .fontWeight(.medium)
            Text("free")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct MediumWidgetView: View {
    let diskInfo: DiskInfo

    var progressColor: Color {
        if diskInfo.usagePercentage > 90 {
            return .red
        } else if diskInfo.usagePercentage > 75 {
            return .orange
        }
        return .blue
    }

    var body: some View {
        HStack(spacing: 16) {
            // Circular progress
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 10)

                Circle()
                    .trim(from: 0, to: CGFloat(diskInfo.usagePercentage / 100))
                    .stroke(progressColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text("\(Int(diskInfo.usagePercentage))%")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Text("used")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 90, height: 90)

            // Details
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "internaldrive.fill")
                        .foregroundStyle(.blue)
                    Text("Disk Storage")
                        .font(.headline)
                }

                Divider()

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Circle()
                            .fill(.blue)
                            .frame(width: 8, height: 8)
                        Text("Used: \(diskInfo.usedFormatted)")
                            .font(.caption)
                    }

                    HStack {
                        Circle()
                            .fill(.green)
                            .frame(width: 8, height: 8)
                        Text("Free: \(diskInfo.freeFormatted)")
                            .font(.caption)
                    }

                    HStack {
                        Circle()
                            .fill(.gray)
                            .frame(width: 8, height: 8)
                        Text("Total: \(diskInfo.totalFormatted)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Spacer()
        }
        .padding()
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct DiskInfoWidget: Widget {
    let kind: String = "DiskInfoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DiskInfoProvider()) { entry in
            DiskInfoWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Disk Info")
        .description("Shows your disk storage usage at a glance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    DiskInfoWidget()
} timeline: {
    DiskInfoEntry(date: .now, diskInfo: .placeholder)
}

#Preview(as: .systemMedium) {
    DiskInfoWidget()
} timeline: {
    DiskInfoEntry(date: .now, diskInfo: .placeholder)
}
