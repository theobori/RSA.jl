"""
Converts String to Integer
"""
function process_string!(message::String)
    acc::BigInt = BigInt(0)
    padding = 0
    len = length(message)

    if (len % 4 != 0)
        padding = (4 - (len % 4))
        message = repeat("\x00", padding) * message
    end

    for i in 1:4:len
        message_part = Vector{UInt8}(message[i:i + 3])
        message_part = reinterpret(UInt32, message_part)[1]
        acc = (acc << 32) + message_part
    end
    acc
end

"""
Convert Integer to String
"""
function recover_string!(number::BigInt)
    s = ""
    i = 1

    while number > 0
        s = String(to_bytes([UInt32(number & 0xffffffff)])) * s
        number = number >> 32
    end
    if (s == "")
        return (s)
    end
    while UInt8(s[i]) == 0
        i += 1
    end
    s[i:length(s)]
end
