// Simulação do protocolo BB84 onde Alice e Bob 
// Geram e compartilham uma chave segura.
namespace Simulation02 {
 
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Diagnostics;

    operation RandomBit() : Bool {
        let r = DrawRandomInt(0, 2);
        return r == 1;
    }

    operation SendAndReceiveQubit(aliceBit : Bool, aliceBasis : Bool, bobBasis : Bool) : Result {
        use q = Qubit();

        if (aliceBit) { X(q); }
        if (aliceBasis) { H(q); }

        if (bobBasis) { H(q); }
        return M(q);
    }

    operation GenerateBB84Key(numQubits : Int) : (Bool[], Bool[]) {
        mutable aliceBits  = [false, size = numQubits];
        mutable aliceBases = [false, size = numQubits];
        mutable bobBases   = [false, size = numQubits];
        mutable bobResults = [false, size = numQubits];

        for i in 0..numQubits-1 {
            set aliceBits w/= i <- RandomBit();
            set aliceBases w/= i <- RandomBit();
            set bobBases   w/= i <- RandomBit();
        }

        for i in 0..numQubits-1 {
            let meas = SendAndReceiveQubit(aliceBits[i], aliceBases[i], bobBases[i]);
            set bobResults w/= i <- (meas == One);
        }

        return (aliceBits, bobResults);
    }

    @EntryPoint()
    operation Main() : Unit {
        let numQubits = 16;
        let (aliceKey, bobKey) = GenerateBB84Key(numQubits);

        Message($"Alice Key: {aliceKey}");
        Message($"Bob Key  : {bobKey}");
    }
}

