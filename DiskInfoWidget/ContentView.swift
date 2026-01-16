import SwiftUI

struct ContentView: View {
    @State private var diskInfo = DiskInfoService.shared.getDiskInfo()

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "internaldrive.fill")
                .font(.system(size: 48))
                .foregroundStyle(.blue)

            Text("Disk Info Widget")
                .font(.title)
                .fontWeight(.semibold)

            Text("Add the widget to your Notification Center")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Total Space:")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(diskInfo.totalFormatted)
                        .fontWeight(.medium)
                }

                HStack {
                    Text("Used Space:")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(diskInfo.usedFormatted)
                        .fontWeight(.medium)
                }

                HStack {
                    Text("Free Space:")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(diskInfo.freeFormatted)
                        .fontWeight(.medium)
                        .foregroundStyle(.green)
                }

                ProgressView(value: diskInfo.usagePercentage, total: 100)
                    .tint(diskInfo.usagePercentage > 90 ? .red : diskInfo.usagePercentage > 75 ? .orange : .blue)

                Text("\(Int(diskInfo.usagePercentage))% used")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))

            Spacer()

            Button("Refresh") {
                diskInfo = DiskInfoService.shared.getDiskInfo()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(30)
        .frame(width: 320, height: 400)
    }
}

#Preview {
    ContentView()
}
