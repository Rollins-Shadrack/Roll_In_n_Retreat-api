const CryptoJS = require('crypto-js')

const encryptData = (data) => {
    const encryptedData = CryptoJS.AES.encrypt(JSON.stringify(data), process.env.ENCRYPTITION_KEY).toString();
    return encodeURIComponent(encryptedData);
}

const decryptData = (encryptedData) => {
    try {
        const decryptedData = CryptoJS.AES.decrypt(decodeURIComponent(encryptedData), process.env.ENCRYPTITION_KEY);
        const utf8Data = decryptedData.toString(CryptoJS.enc.Utf8);
        return JSON.parse(utf8Data);
    } catch (error) {
      throw new Error("Invalid token");
    }
}

module.exports = {
  decryptData,
  encryptData,
};