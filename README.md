# hexdump-util
Turns binary files into hex files, and hex files back into binary

Compiling
`odin build .`

Usage

```
Hex Dumper utility written in Odin
    hexdump [file]
    hexdump [inHexFile] [outBinaryFile]


Arguments

[file] - input filepath

[inHexFile] - the output of hexdump [file]
[outBinaryFile] - the output filename of the binary file

Examples
    hexdump ./image.png > image.hex
    hexdump ./image.hex ./imageModified.png
```