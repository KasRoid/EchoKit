//
//  CPU.swift
//
//
//  Created by Lukas on 4/23/24.
//

import Foundation

internal final class CPU: NSObject {
    
    internal static let machHost = mach_host_self()
    private static let hostBasicInfoCount: mach_msg_type_number_t = UInt32(MemoryLayout<host_basic_info_data_t>.size / MemoryLayout<integer_t>.size)
    
    private static var cpuType: Int {
        Int(hostBasicInfo.cpu_type)
    }
    private static var cpuSubType: Int {
        Int(hostBasicInfo.cpu_subtype)
    }
    private static var cpuArch: String {
        switch hostBasicInfo.cpu_type {
        case CPU_TYPE_ARM:
            cpuTypeARM
        case CPU_TYPE_ARM64:
            cpuTypeArm64
        case CPU_TYPE_X86:
            "x86"
        case CPU_TYPE_X86_64:
            "x86_64"
        default:
            "unknown"
        }
    }

    private static var cpuTypeARM: String {
        switch hostBasicInfo.cpu_subtype {
        case CPU_SUBTYPE_ARM_V7:
            "armv7"
        case CPU_SUBTYPE_ARM_V7F:
            "armv7f"
        case CPU_SUBTYPE_ARM_V7K:
            "armv7k"
        case CPU_SUBTYPE_ARM_V7S:
            "armv7s"
        default:
            "arm"
        }
    }
    
    private static var cpuTypeArm64: String {
        switch hostBasicInfo.cpu_subtype {
        case CPU_SUBTYPE_ARM64E:
            "arm64e"
        case CPU_SUBTYPE_ARM64_V8:
            "arm64v8"
        case CPU_SUBTYPE_ARM64_ALL:
            "arm64all"
        default:
            "arm64"
        }
    }
    
    private static var hostBasicInfo: host_basic_info {
        var size = hostBasicInfoCount
        var hostInfo = host_basic_info()
        let result = withUnsafeMutablePointer(to: &hostInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(size), {
                host_info(machHost, HOST_BASIC_INFO, $0, &size)
            })
        }
        #if DEBUG
        if result != KERN_SUCCESS {
            fatalError("ERROR - \(#file):\(#function) - kern_result_t = "
                + "\(result)")
        }
        #endif
        return hostInfo
    }
    
    private static func getThreadName(_ thread: thread_act_t) -> String? {
        guard let pthread = pthread_from_mach_thread_np(thread) else { return nil }
        return getThreadName(pthread: pthread)
    }
    
    private static func getThreadName(pthread: pthread_t) -> String {
        var chars: [Int8] = Array(repeating: 0, count: 128)
        let error = pthread_getname_np(pthread, &chars, chars.count)
        assert(error == 0, "Could not retrieve thread name")
        let characters = chars.filter { $0 != 0 }.map { UInt8($0) }.map(UnicodeScalar.init).map(Character.init)
        return String(characters)
    }
}

// MARK: - Methods
extension CPU {
    
    internal static func cpuUsagePerThread() -> [(String, Double)] {
        var totalUsageOfCPU: Double = 0.0
        var threadsList: thread_act_array_t?
        var threadsCount = mach_msg_type_number_t(0)
        let threadsResult = withUnsafeMutablePointer(to: &threadsList) {
            return $0.withMemoryRebound(to: thread_act_array_t?.self, capacity: 1) {
                task_threads(mach_task_self_, $0, &threadsCount)
            }
        }
        guard let threadsList else { return [] }
        var result = [(String, Double)]()
        
        if threadsResult == KERN_SUCCESS {
            for index in 0..<threadsCount {
                var threadInfo = thread_basic_info()
                var threadInfoCount = mach_msg_type_number_t(THREAD_INFO_MAX)
                let thread = threadsList[Int(index)]
                var infoResult = withUnsafeMutablePointer(to: &threadInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(thread, thread_flavor_t(THREAD_BASIC_INFO), $0, &threadInfoCount)
                    }
                }
                guard infoResult == KERN_SUCCESS else { break }

                var identifierInfo = thread_identifier_info()
                infoResult = withUnsafeMutablePointer(to: &identifierInfo) {
                    $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                        thread_info(thread, thread_flavor_t(THREAD_IDENTIFIER_INFO), $0, &threadInfoCount)
                    }
                }
                guard infoResult == KERN_SUCCESS else { break }

                let threadBasicInfo = threadInfo as thread_basic_info
                if threadBasicInfo.flags & TH_FLAGS_IDLE == 0 {
                    let usage = (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE) * 100.0)
                    totalUsageOfCPU = (totalUsageOfCPU + usage)
                    
                    var threadName: String = "Thread \(index + 1)"
                    
                    if let name = getThreadName(thread), name.count > 0 {
                        threadName = "\(threadName) (\(name))"
                    }
                    result.append((threadName, usage))
                }
            }
        }
        vm_deallocate(mach_task_self_, vm_address_t(UInt(bitPattern: threadsList)), vm_size_t(Int(threadsCount) * MemoryLayout<thread_t>.stride))
        return result
    }
}
