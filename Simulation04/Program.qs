namespace Simulation04 {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Diagnostics;

    ////////////////////////////////////////////////////////////////////////////
    // 1) Função para comparar dois arrays de bits (porque == não é permitido)
    ////////////////////////////////////////////////////////////////////////////
    function ArraysEqualBool(a : Bool[], b : Bool[]) : Bool {
        if (Length(a) != Length(b)) {
            return false;
        }
        for i in 0..Length(a)-1 {
            if (a[i] != b[i]) {
                return false;
            }
        }
        return true;
    }

    ////////////////////////////////////////////////////////////////////////////
    // 2) Mensagem “Hello Word” em bits (80 bits)
    ////////////////////////////////////////////////////////////////////////////
    /// <summary>
    /// Temos 10 caracteres, cada um ocupa 8 bits (little-endian).
    /// 'H'(72)  -> [F,F,F,T,F,F,T,F]
    /// 'e'(101) -> [T,F,T,F,F,T,T,F]
    /// 'l'(108) -> [F,F,T,T,F,T,T,F]
    /// 'l'(108) -> [F,F,T,T,F,T,T,F]
    /// 'o'(111) -> [T,T,T,T,F,T,T,F]
    /// ' '(32)  -> [F,F,F,F,F,T,F,F]
    /// 'W'(87)  -> [T,T,T,F,T,F,T,F]
    /// 'o'(111) -> [T,T,T,T,F,T,T,F]
    /// 'r'(114) -> [F,T,F,F,T,T,T,F]
    /// 'd'(100) -> [F,F,T,F,F,T,T,F]
    /// </summary>
    function GetMessageBitsHelloWord() : Bool[] {
        return [
            // 'H' = 72
            false, false, false, true,  false, false, true,  false,
            // 'e' = 101
            true,  false, true,  false, false, true,  true,  false,
            // 'l' = 108
            false, false, true,  true,  false, true,  true,  false,
            // 'l' = 108
            false, false, true,  true,  false, true,  true,  false,
            // 'o' = 111
            true,  true,  true,  true,  false, true,  true,  false,
            // ' ' = 32
            false, false, false, false, false, true,  false, false,
            // 'W' = 87
            true,  true,  true,  false, true,  false, true,  false,
            // 'o' = 111
            true,  true,  true,  true,  false, true,  true,  false,
            // 'r' = 114
            false, true,  false, false, true,  true,  true,  false,
            // 'd' = 100
            false, false, true,  false, false, true,  true,  false
        ];
    }

    ////////////////////////////////////////////////////////////////////////////
    // 3) Operações e funções de BB84 + One-Time Pad
    ////////////////////////////////////////////////////////////////////////////
    /// <summary>
    /// Gera um bit aleatório (False/True).
    /// </summary>
    operation RandomBit() : Bool {
        let r = DrawRandomInt(0, 2);
        return (r == 1);
    }

    /// <summary>
    /// BB84: Envia o bit (aliceBit) na base (aliceBasis),
    ///       Bob mede na base (bobBasis).
    /// Retorna Zero ou One.
    /// false => base Z
    /// true  => base X
    /// </summary>
    operation SendAndReceiveQubit(aliceBit : Bool, aliceBasis : Bool, bobBasis : Bool) : Result {
        use q = Qubit();

        if (aliceBit) {
            X(q);
        }
        if (aliceBasis) {
            H(q);
        }

        if (bobBasis) {
            H(q);
        }
        return M(q);
    }

    /// <summary>
    /// Gera a chave BB84, devolvendo (chaveAlice, chaveBob).
    /// </summary>
    operation GenerateBB84Key(numQubits : Int) : (Bool[], Bool[]) {
        mutable aliceBits  = [false, size = numQubits];
        mutable aliceBases = [false, size = numQubits];
        mutable bobBases   = [false, size = numQubits];
        mutable bobResults = [false, size = numQubits];

        // 1) Gerar bits e bases aleatórios
        for i in 0..numQubits-1 {
            set aliceBits w/= i <- RandomBit();
            set aliceBases w/= i <- RandomBit();
            set bobBases   w/= i <- RandomBit();
        }

        // 2) Enviar e medir
        for i in 0..numQubits-1 {
            let meas = SendAndReceiveQubit(
                aliceBits[i],
                aliceBases[i],
                bobBases[i]
            );
            set bobResults w/= i <- (meas == One);
        }

        // 3) Filtrar onde as bases coincidem
        mutable matchingIndices = [];
        for i in 0..numQubits-1 {
            if (aliceBases[i] == bobBases[i]) {
                set matchingIndices += [i];
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

    /// <summary>
    /// XOR de dois bits: devolve True se forem diferentes, False se iguais.
    /// </summary>
    function XorBool(a : Bool, b : Bool) : Bool {
        return a != b;
    }

    /// <summary>
    /// One-Time Pad: XOR entre o array de bits da mensagem e da chave.
    /// Usa o tamanho mínimo, se a chave for menor que a mensagem.
    /// </summary>
    function OneTimePad(msgBits : Bool[], keyBits : Bool[]) : Bool[] {
        let lenMsg = Length(msgBits);
        let lenKey = Length(keyBits);
        let n = (lenMsg < lenKey) ? lenMsg | lenKey;

        mutable result = [false, size = n];
        for i in 0..n-1 {
            set result w/= i <- XorBool(msgBits[i], keyBits[i]);
        }
        return result;
    }

    ////////////////////////////////////////////////////////////////////////////
    // 4) ENTRYPOINT
    ////////////////////////////////////////////////////////////////////////////
    @EntryPoint()
    operation Main() : Unit {
        // (A) Mensagem "Hello Word" em bits
        let messageBits = GetMessageBitsHelloWord();
        let neededBits  = Length(messageBits);

        Message($"Mensagem \"Hello Word\" em bits (total={neededBits}):");
        Message($"{messageBits}\n");

        // (B) Gerar qubits suficientes para BB84
        // Se a msg tem 80 bits, vamos usar, por ex., 200 qubits
        // para aumentar a probabilidade de obter >=80 bits de chave.
        let numQubits = 200;
        let (aliceKey, bobKey) = GenerateBB84Key(numQubits);

        Message($"Chave Alice (len={Length(aliceKey)}): {aliceKey}");
        Message($"Chave Bob   (len={Length(bobKey)}): {bobKey}\n");

        // Se a chave for menor que 80 bits, podemos abortar (não há bits suficientes).
        if (Length(aliceKey) < neededBits) {
            Message($"A chave gerada ({Length(aliceKey)}) é menor que a mensagem (80). Impossível cifrar tudo!");
            return ();
        }

        // (C) Alice cifra
        let cipherBits = OneTimePad(messageBits, aliceKey);
        Message($"Cifrado (bits): {cipherBits}");

        // (D) Bob decifra
        let decipherBits = OneTimePad(cipherBits, bobKey);
        Message($"Decifrado      : {decipherBits}\n");

        // (E) Comparar arrays
        if (ArraysEqualBool(decipherBits, messageBits)) {
            Message("-> A mensagem foi decifrada com sucesso!\n");
        } else {
            Message("-> Houve erro na decifragem.\n");
        }

        Message("Fim da demonstração BB84 + OTP em Q#.");
    }
}