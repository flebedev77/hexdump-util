package main 

import "core:fmt"
import "core:os"
import "core:bufio"
import "core:strings"
import "core:strconv"

main :: proc() {
    if len(os.args) == 1 {
        printHelp()
    } else if len(os.args) == 2 {
        runHexRead(os.args[1])
    } else if len(os.args) == 3 {
        runHexWrite(os.args[1], os.args[2])
    } else {
        printHelp()
    }
}

printHelp :: proc() {
    binary_name := "hexdump"
    fmt.println("Hex Dumper utility written in Odin")
    fmt.println("Usage error: ");
    fmt.printf("   %s <file>\n", binary_name)
    fmt.printf("   %s <inHexFile> <outBinaryFile>\n\n", binary_name)
    fmt.println("<arguments>")
    fmt.println("<file> - input filepath\n")
    fmt.printf("<inHexFile> - the output of %s <file>\n", binary_name)
    fmt.println("<outBinaryFile> - the output filename of the binary file\n")
    fmt.println("examples")
    fmt.printf("    %s ./image.png > image.hex\n", binary_name)
    fmt.printf("    %s ./image.hex ./imageModified.png\n", binary_name)
    fmt.println("")
}

runHexWrite :: proc(inputPath: string, outputPath: string) {
    fmt.printf("\n")

    data, ok := os.read_entire_file(inputPath, context.allocator)
	if !ok {
        fmt.printf("Error reading file %s", inputPath)
		return
	}
	defer delete(data, context.allocator)

    fullString: string = ""

	it := string(data)
	for line in strings.split_lines_iterator(&it) {
        //Not the bottom line
        if !strings.contains_rune(line, 'L') {
            str: string = line
            str = strings.trim_right(str, "\r")
            str = strings.trim_right(str, "\n")
            str = strings.trim_right(str, "\r")
            str = strings.trim_right(str, "\n")

            fullString = strings.concatenate({fullString, str})
        }
	}
    hexNumbers := strings.split(fullString, ",")
    convertedData: []byte
    convertedData = make([]byte, len(hexNumbers))

    i := 0
    for hex in hexNumbers {
        b, ok := strconv.parse_int(hex)
        convertedData[i] = u8(b)
        i += 1
    }
    os.write_entire_file(outputPath, convertedData)
}

runHexRead :: proc(filepath: string) {
    fmt.printf("\n")

    f, err := os.open(filepath)
    if err != 0 {
        fmt.printf("Error opening file %s\n", filepath)
        return
    }

    defer os.close(f)

    size, sizeErr := os.file_size(f)
    if sizeErr != 0 {
        fmt.printf("Error getting file size %s\n", filepath)
    }

    data: []byte
    data = make([]byte, size)
    bytesRead, readErr := os.read(f, data[:])
    if readErr != 0 {
        fmt.printf("Error reading file %s\n", filepath)
        return
    }

    if len(data) == 0 {
        fmt.printf("Error: File does not exist %s!", filepath)
    } else {
        index: int = 0
        for b in data {
            index += 1
            byteToHex(b, (index == len(data)))
            if index % 12 == 0 {
                fmt.printf("\n")
            }
        }
        fmt.printf("\n")
        fmt.printf("Length: %d\n", len(data))
    }
}

byteToHex :: proc(inputByte: byte, isLastByte: bool) -> string {
    if !isLastByte {
        fmt.printf("0x%02X,", inputByte)
    } else {
        fmt.printf("0x%02X", inputByte)
    }
    return ""
}