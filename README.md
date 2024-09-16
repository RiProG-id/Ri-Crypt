# Ri-Crypt

Ri-Crypt is a tool for encrypting shell commands using XOR with a random secret key. It generates Rust code to decrypt and execute those commands, then compiles the Rust code and places the binary in the same location as the input file.

## Warning

**Encryption does not support shells that use input readers like `read`.**

## Setup

To install the required dependencies, follow these steps:

1. Clone the repository:

    ```bash
    git clone https://github.com/RiProG-id/Ri-Crypt
    ```

2. Navigate to the Ri-Crypt directory:

    ```bash
    cd Ri-Crypt
    ```

3. Make the setup script executable and run it:

    ```bash
    bash setup.sh
    ```

## Using Ri-Crypt

1. Navigate to the Ri-Crypt directory:

    ```bash
    cd Ri-Crypt
    ```

2. Make the encryption script executable:

    ```bash
    chmod +x run.sh
    ```

3. Execute the encryption script:

    ```bash
    ./run.sh
    ```

4. Follow the prompts:

   The script will prompt you to enter the location of the file to be encrypted. It will generate a binary with the same name as the input file in the same directory. The resulting binary will match the system's default architecture.

## Support and Contact

**Developer Contact:**

- Telegram Channel: [@RiOpSo](https://t.me/RiOpSo)
- Telegram Group: [@RiOpSoDisc](https://t.me/RiOpSoDisc)

**Support Me:**

- Dana: 0831-4095-0951
- Seabank: 901114440459
- PayPal: [PayPal Donation](https://paypal.me/RiProG?country.x=ID&locale.x=id_ID)

Thank you for your support!