import Foundation

struct DiskInfo {
    let totalBytes: Int64
    let freeBytes: Int64
    let usedBytes: Int64
    let usagePercentage: Double

    var totalFormatted: String {
        ByteCountFormatter.string(fromByteCount: totalBytes, countStyle: .file)
    }

    var freeFormatted: String {
        ByteCountFormatter.string(fromByteCount: freeBytes, countStyle: .file)
    }

    var usedFormatted: String {
        ByteCountFormatter.string(fromByteCount: usedBytes, countStyle: .file)
    }

    static let placeholder = DiskInfo(
        totalBytes: 500_000_000_000,
        freeBytes: 200_000_000_000,
        usedBytes: 300_000_000_000,
        usagePercentage: 60.0
    )
}

class DiskInfoService {
    static let shared = DiskInfoService()

    private init() {}

    func getDiskInfo() -> DiskInfo {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: "/")

            guard let totalSpace = attributes[.systemSize] as? Int64,
                  let freeSpace = attributes[.systemFreeSize] as? Int64 else {
                return .placeholder
            }

            let usedSpace = totalSpace - freeSpace
            let percentage = Double(usedSpace) / Double(totalSpace) * 100.0

            return DiskInfo(
                totalBytes: totalSpace,
                freeBytes: freeSpace,
                usedBytes: usedSpace,
                usagePercentage: percentage
            )
        } catch {
            return .placeholder
        }
    }
}
