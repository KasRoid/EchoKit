//
//  Memory.swift
//
//
//  Created by Lukas on 4/23/24.
//

import Foundation

internal final class Memory: NSObject {

    private static let hostVmInfo64Count: mach_msg_type_number_t = UInt32(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.size)
    private static let pageSize: Double = Double(vm_kernel_page_size)
    private static let totalBytes = Double(ProcessInfo.processInfo.physicalMemory)
}

// MARK: - Methods
extension Memory {
    
    internal class func applicationUsage() -> (used: Double, total: Double) {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout.size(ofValue: info) / MemoryLayout<integer_t>.size)
        let kern = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        guard kern == KERN_SUCCESS else {
            return (0, self.totalBytes)
        }
        let usedGB = Double(info.resident_size) / (1024 * 1024 * 1024)
        let totalGB = self.totalBytes / (1024 * 1024 * 1024)
        return (usedGB, totalGB)
    }
}

// MARK: - Private Functions
extension Memory {
    
    private class func systemUsage() -> (free: Double, usable: Double, total: Double) {
        let statistics = self.VMStatistics64()
        let free = Double(statistics.free_count) * pageSize
        let active = Double(statistics.active_count) * pageSize
        let inactive = Double(statistics.inactive_count) * pageSize
        let wired = Double(statistics.wire_count) * pageSize
        let compressed = Double(statistics.compressor_page_count) * pageSize
        let usable = active + inactive + wired + compressed
        return (free, usable, self.totalBytes)
    }
    
    private static func VMStatistics64() -> vm_statistics64 {
        var size = hostVmInfo64Count
        var hostInfo = vm_statistics64()
        
        let result = withUnsafeMutablePointer(to: &hostInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                host_statistics64(CPU.machHost, HOST_VM_INFO64, $0, &size)
            }
        }
#if DEBUG
        if result != KERN_SUCCESS {
            print("ERROR - \(#file):\(#function) - kern_result_t = " + "\(result)")
        }
#endif
        return hostInfo
    }
}
