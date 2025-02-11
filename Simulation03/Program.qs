namespace Simulation03 {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Diagnostics;

    ////////////////////////////////////////////////////////////////////////////
    // 1) Gera um bit aleatório (operações do QDK >= 0.28)
    ////////////////////////////////////////////////////////////////////////////
    operation RandomBit() : Bool {
        let r = DrawRandomInt(0, 2); 
        return r == 1;
    }

    ////////////////////////////////////////////////////////////////////////////
    // 2) BB84: enviar/receber um único qubit
    ////////////////////////////////////////////////////////////////////////////
    operation SendAndReceiveQubit(aliceBit : Bool, aliceBasis : Bool, bobBasis : Bool) : Result {
        use q = Qubit();

        // Alice prepara
        if (aliceBit) {
            X(q);
        }
        if (aliceBasis) {
            H(q);
        }

        // Bob mede
        if (bobBasis) {
            H(q);
        }

        return M(q);
    }

    ////////////////////////////////////////////////////////////////////////////
    // 3) Gera Chave BB84 (Alice & Bob)
    ////////////////////////////////////////////////////////////////////////////
    operation GenerateBB84Key(numQubits : Int) : (Bool[], Bool[]) {
        mutable aliceBits  = [false, size = numQubits];
        mutable aliceBases = [false, size = numQubits];
        mutable bobBases   = [false, size = numQubits];
        mutable bobResults = [false, size = numQubits];

        // Prepara bits e bases
        for i in 0..numQubits-1 {
            set aliceBits w/= i <- RandomBit();
            set aliceBases w/= i <- RandomBit(); // false=Z, true=X
            set bobBases   w/= i <- RandomBit(); // false=Z, true=X
        }

        // Envia e mede
        for i in 0..numQubits-1 {
            let meas = SendAndReceiveQubit(aliceBits[i], aliceBases[i], bobBases[i]);
            set bobResults w/= i <- (meas == One);
        }

        // Filtra onde bases coincidem
        mutable matchingIndices = []; // array vazio de Int
        for i in 0..numQubits-1 {
            if (aliceBases[i] == bobBases[i]) {
                set matchingIndices += [i]; // "append"
            }
        }

        let matchCount = Length(matchingIndices);
        mutable finalAliceKey = [false, size = matchCount];
        mutable finalBobKey   = [false, size = matchCount];

        for j in 0..matchCount-1 {
            let idx = matchingIndices[j];
            set finalAliceKey w/= j <- aliceBits[idx];
            set finalBobKey   w/= j <- bobResults[idx];
        }

        return (finalAliceKey, finalBobKey);
    }

    ////////////////////////////////////////////////////////////////////////////
    // 4) One-Time Pad (XOR de arrays de bits)
    ////////////////////////////////////////////////////////////////////////////
    function XorBool(a : Bool, b : Bool) : Bool {
        return a != b;
    }

    function OneTimePad(message : Bool[], key : Bool[]) : Bool[] {
        let lenMsg = Length(message);
        let lenKey = Length(key);

        // Usar o tamanho mínimo para evitar estourar o array
        let n = (lenMsg < lenKey) ? lenMsg | lenKey; // "ternary" no Q#

        mutable result = [false, size = n];
        for i in 0..n-1 {
            set result w/= i <- XorBool(message[i], key[i]);
        }
        return result;
    }

    ////////////////////////////////////////////////////////////////////////////
    // 5) EntryPoint (Main)
    ////////////////////////////////////////////////////////////////////////////
    @EntryPoint()
    operation Main() : Unit {
        // Exemplo de "Hello world"
        Message("Hello from Q# (versão >=0.28)! Demonstração BB84.\n");

        // Gerar chave BB84
        let numQubits = 20;
        let (aliceKey, bobKey) = GenerateBB84Key(numQubits);

        Message($"Alice Key: {aliceKey}");
        Message($"Bob Key  : {bobKey}");

        // Calcular taxa de erro (em Double) sem casts
        let lengthKey = Length(aliceKey);
        if (lengthKey == 0) {
            Message("Não há bases coincidentes, chave vazia!\n");
        } else {
            // Contar erros em double
            mutable errorsDouble = 0.0;
            for i in 0..lengthKey-1 {
                if (aliceKey[i] != bobKey[i]) {
                    set errorsDouble += 1.0;
                }
            }
            // Converter lengthKey para double manualmente
            mutable lengthKeyDouble = 0.0;
            for _ in 1..lengthKey {
                set lengthKeyDouble += 1.0;
            }

            let errorRate = (errorsDouble / lengthKeyDouble) * 100.0;
            Message($"Taxa de erro: {errorRate}%\n");
        }

        // Exemplo de cifragem/decifragem via One-Time Pad
        let originalMsg = [true, false, true, true, false]; // 5 bits
        let cipher = OneTimePad(originalMsg, aliceKey);
        let decipher = OneTimePad(cipher, bobKey);

        Message($"Mensagem original: {originalMsg}");
        Message($"Cifrado          : {cipher}");
        Message($"Decifrado        : {decipher}");

        Message("\nFim da demonstração BB84 em Q#.");
    }
}
