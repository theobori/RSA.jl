"""
RSA encryption

message: message to encrypt
key: public key to use for encryption
"""
function encrypt!(message::String, key::Tuple{BigInt, BigInt})
    e, n = key

    message = process_string!(message)
    CipherText(exp!(message, e, n), 1)
end

function encrypt!(message::Any, key::Tuple{BigInt, BigInt})
    e, n = key

    CipherText(exp!(message, e, n), 0)
end

"""RSA Decryption

ciphertext: Ciphertext object to decrypt
"""
function decrypt!(system::RSASystem, ciphertext::CipherText)
    d, n = system.private_key

    if (ciphertext.is_str == true)
        return (recover_string!(exp!(ciphertext.data, d, n)))
    end
    exp!(ciphertext.data, d, n)
end