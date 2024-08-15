# Handwritten-digit-recognition-using-ELM

# Hardware Efficient 256-bit AES Encryption and Decryption Algorithm



Data encryption has become an indispensable requirement in today’s apps, transactions, and
webpages and the applications are endless. Along with encrypting the sensitive data, authenticity
also needs to be verified. Many remote devices require an encryption scheme to transmit the
information. I implemented an Advanced Encryption Standard (AES) encryption scheme that resists replay attacks.
This repository contains the source codes and a brief description of Advanced Encrytion Standard using Verilog.


## Background: Cryptographic techniques 
### Symmetric-key cryptography
▢ Both the sender and receiver share a single key.
▢ The sender uses this key to encrypt the plaintext.
▢ On the other side, the receiver uses the same key to decrypt the message and recover
the plaintext. Advanced Encryption Standard (AES) is the most celebrated example.
![Screenshot from 2023-07-14 16-53-53](https://github.com/vendraDp/AES_Vendra_Durgaprasad-/assets/107578770/599d202f-4d52-44ff-9a80-fb58f4da752c)


### Public-key cryptography
▢ In Public-Key Cryptography two related keys (public and private key) are used.
▢ Public keys may be freely distributed, while private keys remain secret.
▢ The public key is used for encryption and the private key for decryption. RSA is a
well-known example of this kind.


## STA Report
Summary of setup slack and hold slack for the top-level module

![image](https://github.com/vendraDp/AES_Vendra_Durgaprasad-/assets/107578770/857a4f35-68e0-4192-9a39-addedaeb419d)


Time period = 10ns, Setup slack = 3.972ns , Hold slack = 0.397ns 


## Layout

Layout of top module 

### cell view

![image](https://github.com/vendraDp/AES_Vendra_Durgaprasad-/assets/107578770/9b794c14-7df3-4b7f-a1e4-921f91220b04)

### transistor-level view

![image](https://github.com/vendraDp/AES_Vendra_Durgaprasad-/assets/107578770/c4ea8e39-ac82-44cd-b24f-1f4ccf09a8ad)





