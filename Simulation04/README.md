# 🔑 Simulação QKD-BB84 - Transmissão Segura com BB84 e One-Time Pad

Este projeto implementa uma variante do protocolo **BB84** para **Distribuição Quântica de Chaves (QKD)**, incluindo uma simulação de cifragem e decifragem de mensagens utilizando o **One-Time Pad (OTP)**. Desenvolvido em **Q#** e utilizando o **Microsoft Quantum Development Kit (QDK)**, este projeto permite explorar a comunicação quântica segura.

---

## 📚 Explicação do Código

### **1️⃣ Codificação de uma Mensagem**
A função `GetMessageBitsHelloWord()` converte a mensagem "Hello Word" em bits:
```qsharp
function GetMessageBitsHelloWord() : Bool[] {
    return [
        false, false, false, true,  false, false, true,  false,
        true,  false, true,  false, false, true,  true,  false,
        false, false, true,  true,  false, true,  true,  false,
        false, false, true,  true,  false, true,  true,  false,
        true,  true,  true,  true,  false, true,  true,  false,
    ];
}
```

### **2️⃣ Troca de Qubits (BB84)**
A função `SendAndReceiveQubit()` simula a transmissão e medição de um qubit entre Alice e Bob.
```qsharp
operation SendAndReceiveQubit(aliceBit : Bool, aliceBasis : Bool, bobBasis : Bool) : Result {
    use q = Qubit();
    if (aliceBit) { X(q); }
    if (aliceBasis) { H(q); }
    if (bobBasis) { H(q); }
    return M(q);
}
```

### **3️⃣ Geração da Chave BB84**
A operação `GenerateBB84Key(numQubits : Int)` gera a chave de Alice e Bob e elimina bits onde as bases não coincidem.

### **4️⃣ Cifragem com One-Time Pad**
O **One-Time Pad** é utilizado para encriptar e desencriptar mensagens usando a chave BB84.
```qsharp
function OneTimePad(msgBits : Bool[], keyBits : Bool[]) : Bool[] {
    mutable result = [false, size = Length(msgBits)];
    for i in 0..Length(msgBits)-1 {
        set result w/= i <- (msgBits[i] != keyBits[i]);
    }
    return result;
}
```

### **5️⃣ Execução Principal (Main)**
O `Main()` executa a simulação completa:
- Codifica a mensagem "Hello Word"
- Gera a chave BB84
- Exibe a taxa de erro
- Demonstra a cifragem e descifragem

```qsharp
@EntryPoint()
operation Main() : Unit {
    let messageBits = GetMessageBitsHelloWord();
    let numQubits = 200;
    let (aliceKey, bobKey) = GenerateBB84Key(numQubits);
    let cipherBits = OneTimePad(messageBits, aliceKey);
    let decipherBits = OneTimePad(cipherBits, bobKey);
}
```

---

## 📜 Licença

Este projeto é distribuído sob a **MIT License**. 📄

---

🚀 **Simulação QKD-BB84 - Encriptação Segura com Q#** 🔒✨

