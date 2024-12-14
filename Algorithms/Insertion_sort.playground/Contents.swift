// MARK: - Report
/*

 Notation: O(n2)
 100 elements:
    time - 0.17988991737365723 sec
    memory - 1168 KB
 1000 elements:
    time - 17.53861403465271 sec
    memory - 133714 KB
 10000 elements:
    time -
    memory -
*/

import Foundation

// MARK: - Input Parameters

var example_array: [Int] = generateUniqueRandomNumbers(count: 10000, range: 0...1_000_000, shouldBeReversedOrderSorted: true)

// MARK: - Algorithm

func insertionSort(arrayToSort: inout [Int]) {

    /// Precount
    let startTime = CFAbsoluteTimeGetCurrent()
    let initialMemory = memoryFootprint() ?? 0

    /// Do
    for i in 1..<arrayToSort.count {
        let key = arrayToSort[i]
        var j = i - 1

        while j >= 0, arrayToSort[j] > key {
            arrayToSort[j+1] = arrayToSort[j]
            j -= 1
        }
        arrayToSort[j + 1] = key
    }

    /// Postcount
    let endTime = CFAbsoluteTimeGetCurrent()
    print("Algorithm work time is: \(endTime - startTime)")
    let finalMemory = memoryFootprint() ?? 0
    print("Algorithm used memory during execution: \((finalMemory - initialMemory) / 1024) KB")
}

// MARK: - Execution

insertionSort(arrayToSort: &example_array)
print(example_array)

// MARK: - Support functionality

func generateUniqueRandomNumbers(count: Int, range: ClosedRange<Int>, shouldBeReversedOrderSorted: Bool = false) -> [Int] {
    guard count <= range.count else {
        fatalError("Диапазон значений слишком мал для генерации заданного количества уникальных значений")
    }

    var uniqueNumbers = Set<Int>()
    while uniqueNumbers.count < count {
        uniqueNumbers.insert(Int.random(in: range))
    }

    var uniqueNumbersArray = Array(uniqueNumbers)
    if shouldBeReversedOrderSorted {
        uniqueNumbersArray.sort(by: { $0 > $1 })
    }
    return Array(uniqueNumbersArray)
}

func memoryFootprint() -> UInt64? {

    var info = task_vm_info_data_t()
    var count = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size) / 4

    let result: kern_return_t = withUnsafeMutablePointer(to: &info) {
        $0.withMemoryRebound(to: Int32.self, capacity: Int(count)) {
            task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
        }
    }
    guard result == KERN_SUCCESS else { return nil }
    return info.phys_footprint
}
