// ============================================================
// Geração de Bits Aleatórios
// ============================================================
// Neste exemplo, geramos um bit aleatório usando um qubit.
//
// Execução esperada:
// - O programa imprime um bit aleatório "true" ou "false".
// ============================================================

namespace Simulation01 {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Random;

    operation RandomBit() : Bool {
        let r = DrawRandomInt(0, 1);
        return r == 1;
    }

    @EntryPoint()
    operation Main() : Unit {
        let bit = RandomBit();
        Message($"Bit aleatório gerado: {bit}");
    }
}