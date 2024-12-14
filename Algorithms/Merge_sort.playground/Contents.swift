// MARK: - Report
/*

 Notation: O()
 100 elements:
    time - 0.09892499446868896 SEC
    memory - 304 KB
 1000 elements:
    time - 2.1565330028533936 SEC
    memory - 11328 KB
 10000 elements:
    time - 39.05890500545502 SEC
    memory - 354864 KB
*/

import Foundation

// MARK: - Input Parameters

var example_array: [Int] = generateUniqueRandomNumbers(count: 10000, range: 0...1_000_000, shouldBeReversedOrderSorted: true)

// MARK: - Algorithm

func mergeSort(arrayToSort: [Int]) -> [Int] {
    guard arrayToSort.count > 1 else { return arrayToSort }

    let middleIndex = arrayToSort.count / 2
    let leftArray = Array(arrayToSort[0..<middleIndex])
    let rightArray = Array(arrayToSort[middleIndex..<arrayToSort.count])

    let sortedLeft = mergeSort(arrayToSort: leftArray)
    let sortedRight = mergeSort(arrayToSort: rightArray)

    return merge(sortedLeft, sortedRight)
}

func merge(_ left: [Int], _ right: [Int]) -> [Int] {

    var leftIndex = 0
    var rightIndex = 0
    var result: [Int] = []

    while leftIndex < left.count && rightIndex < right.count {
        if left[leftIndex] < right[rightIndex] {
            result.append(left[leftIndex])
            leftIndex += 1
        } else {
            result.append(right[rightIndex])
            rightIndex += 1
        }
    }

    if leftIndex < left.count {
        result.append(contentsOf: left[leftIndex...])
    }

    if rightIndex < right.count {
        result.append(contentsOf: right[rightIndex...])
    }

    return result
}

// MARK: - Execution

execute(arrayToMergeSort: example_array)


// MARK: - Support functionality

func execute(arrayToMergeSort: [Int]) {
    /// Precount
    let startTime = CFAbsoluteTimeGetCurrent()
    let initialMemory = memoryFootprint() ?? 0

    /// Do
    let sortedArray = mergeSort(arrayToSort: arrayToMergeSort)

    /// Postcount
    let endTime = CFAbsoluteTimeGetCurrent()
    print("Algorithm work time is: \(endTime - startTime) SEC")
    let finalMemory = memoryFootprint() ?? 0
    print("Algorithm used memory during execution: \((finalMemory - initialMemory) / 1024) KB")
}

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
