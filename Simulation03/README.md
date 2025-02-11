# 🔑 Simulação QKD-BB84 - Distribuição Quântica de Chaves (BB84) em Q\#

Este projeto implementa o protocolo **BB84** para **Distribuição Quântica de Chaves (QKD)** utilizando **Q#** e o **Microsoft Quantum Development Kit (QDK)**. Demonstra-se como Alice e Bob podem gerar uma chave partilhada segura utilizando bits e bases quânticas.

Este repositório contém **várias simulações** do procedimento BB84 em **Q#**, permitindo explorar diferentes cenários e variações do protocolo.

---

## 📚 Explicação do Código

### **1️⃣ Gerar um bit aleatório**

A função `RandomBit()` gera um bit aleatório usando:

```qsharp
operation RandomBit() : Bool {
    let r = DrawRandomInt(0, 2);
    return r == 1;
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

### **3️⃣ Gerar a Chave BB84**

A operação `GenerateBB84Key(numQubits : Int)` gera a chave de Alice e Bob e elimina bits onde as bases não coincidem.

### **4️⃣ Cifragem com One-Time Pad**

O **One-Time Pad** é utilizado para encriptar e desencriptar mensagens usando a chave BB84.

```qsharp
function OneTimePad(message : Bool[], key : Bool[]) : Bool[] {
    mutable result = [false, size = Length(message)];
    for i in 0..Length(message)-1 {
        set result w/= i <- (message[i] != key[i]);
    }
    return result;
}
```

### **5️⃣ Execução Principal (Main)**

O `Main()` executa a simulação completa:

- Gera as chaves de Alice e Bob
- Exibe a taxa de erro
- Demonstra a cifragem e descifragem

```qsharp
@EntryPoint()
operation Main() : Unit {
    let numQubits = 20;
    let (aliceKey, bobKey) = GenerateBB84Key(numQubits);
    Message($"Alice Key: {aliceKey}");
    Message($"Bob Key  : {bobKey}");
}
```

---

## 🤝 Contribuições

Aceitamos contribuições! Para sugerir melhorias ou relatar problemas:

1. Criar uma **Issue**
2. Fazer um **Fork** do repositório
3. Criar um **Branch** para a tua contribuição
4. Enviar um **Pull Request**

---

## 📜 Licença

Este projeto é distribuído sob a **MIT License**. 📄

---

🚀 **Simulação QKD-BB84 - Comunicação Segura com Q#** 🔒✨

