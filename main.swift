import Foundation

var gMatchedPatterns:[String] = []
var gCurrentBestMatchedWildCardCount = 9999
var patternsArray:[String] = []
var stringsArray:[String] = []

func readFromStdInput() -> String {
    let keyboard = NSFileHandle.fileHandleWithStandardInput()
    let inputData = keyboard.availableData
    var str = NSString(data: inputData, encoding: NSUTF8StringEncoding) as! String
    str = str.stringByReplacingOccurrencesOfString("\n", withString: "")
    return str;
}

func writeToStdOutput(str: String) {
    let handle = NSFileHandle.fileHandleWithStandardOutput()
    if let data = str.dataUsingEncoding(NSUTF8StringEncoding) {
        handle.writeData(data)
    }
}

func returnBestMatch(patternArray: [String]) -> [String] {
    if patternArray.count > 1 {
        var workingArray: [String] = []
        let patternSize = patternArray.first!.componentsSeparatedByString(",").count
        for i in 0 ..< patternSize  {
            if workingArray.count == 0 {
                for pattern in patternArray {
                    let subStringArray = pattern.componentsSeparatedByString(",")
                    if subStringArray[i] != "*" {
                        workingArray.append(pattern)
                    }
                }
            } else if workingArray.count == 1 {
                return workingArray;
            } else {
                var secondWorkingArray: [String] = []
                for pattern in workingArray {
                    let subStringArray = pattern.componentsSeparatedByString(",")
                    if subStringArray[i] != "*" {
                        secondWorkingArray.append(pattern)
                    }
                }
                if secondWorkingArray.count > 0 {
                    workingArray = secondWorkingArray;
                }
            }
        }
    }
    
    return patternArray
}

func printTheBestMatch() -> Void {
    if gMatchedPatterns.count == 0 {
        writeToStdOutput("NO MATCH\n")
    } else if(gMatchedPatterns.count == 1){
            writeToStdOutput("\(gMatchedPatterns.first!)\n")
    } else {
        let matchedPatterns = returnBestMatch(gMatchedPatterns)
        writeToStdOutput("\(matchedPatterns.first!)\n")
    }
}
while true {//continuously wait for new inputs
    //READ FROM STD INPUT
    var numberOfPatterns = Int(readFromStdInput())!
    var numberOfStrings = 0
    while   numberOfPatterns >= 0  {
        if numberOfPatterns > 0 {
            patternsArray.append(readFromStdInput())
        } else {
            numberOfStrings = Int(readFromStdInput())!
        }
        numberOfPatterns-=1
    }
    while numberOfStrings>0 {
        stringsArray.append(readFromStdInput())
        numberOfStrings-=1
    }
//PATTERN MATCH
    for str in stringsArray {
        gMatchedPatterns = []
        gCurrentBestMatchedWildCardCount = 9999
        for pattern in patternsArray {
            var isMatch = true
            let patternArray = pattern.componentsSeparatedByString(",")
            var strArray = str.componentsSeparatedByString("/")
            
            if strArray.last == "" {strArray.removeAtIndex(strArray.count-1)}
            if strArray.first == "" {strArray.removeAtIndex(0)}
            let patternArrayCount = patternArray.count
            
            if patternArrayCount == strArray.count {
                var bestMatchedWildCardCount:Int = 0
                for i in 0 ..< patternArrayCount {
                    if patternArray[i] == strArray[i] {
                    } else if patternArray[i] == "*" {
                        bestMatchedWildCardCount+=1
                        if(bestMatchedWildCardCount > gCurrentBestMatchedWildCardCount) {
                            break
                        }
                    } else {
                        isMatch = false
                        break
                    }
                }
                if isMatch {
                    if bestMatchedWildCardCount == gCurrentBestMatchedWildCardCount {
                        if bestMatchedWildCardCount == 0 {
                            gMatchedPatterns = [pattern]
                            break
                        } else {
                            gMatchedPatterns.append(pattern)
                        }
                    } else if bestMatchedWildCardCount < gCurrentBestMatchedWildCardCount {
                        gMatchedPatterns = [pattern]
                        gCurrentBestMatchedWildCardCount = bestMatchedWildCardCount
                    }
                }
            }
        }
        printTheBestMatch()
    }
    gMatchedPatterns = []
    gCurrentBestMatchedWildCardCount = 9999
    patternsArray = []
    stringsArray = []
}