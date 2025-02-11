# 🔑 QKDBB84 - Implementação de QKD com BB84 em Q#

Este projeto implementa o **Protocolo BB84** para **Distribuição Quântica de Chaves (QKD)** utilizando a linguagem **Q#** e o **Microsoft Quantum Development Kit (QDK)**.  
O BB84 é um dos protocolos fundamentais para comunicação segura baseada em criptografia quântica.

---

## 📦 Estrutura do Projeto

A organização do código segue a seguinte estrutura:

```
QKDBB84/
│── │
│   ├── HelloWorld/            # Diretório do primeiro exemplo em Q#
│   │   ├── Program.qs         # Código principal do QKD BB84
│   │   ├── HelloWorld.csproj  # Arquivo de configuração do projeto
│── .gitignore                 # Ignorar arquivos desnecessários no Git
│── QKDBB84.sln                # Arquivo de solução do Visual Studio
│── README.md                  # Documentação do projeto
```

---

## 🛠️ Configuração do Ambiente

Para compilar e executar o código, será necessário instalar:

- **.NET 6.0+ SDK** → [Baixar aqui](https://dotnet.microsoft.com/download)
- **Microsoft Quantum Development Kit (QDK)** → [Baixar aqui](https://learn.microsoft.com/en-us/azure/quantum/install-overview-qdk)

Após instalar, verifica se os pacotes estão disponíveis executando:

```sh
dotnet --version
```

E para confirmar a instalação do QDK:

```sh
dotnet tool list -g
```

Se `Microsoft.Quantum.IQSharp` não estiver na lista, instala com:

```sh
dotnet tool install -g Microsoft.Quantum.IQSharp
dotnet iqsharp install
```

---

## 🚀 Como Rodar o Código

### 🔹 **Passo 1: Clonar o Repositório**
Se ainda não tens o repositório clonado:

```sh
git clone https://github.com/teu-usuario/QKDBB84.git
cd QKDBB84
```

### 🔹 **Passo 2: Restaurar Dependências**
Caso seja a primeira vez que estás a rodar o projeto:

```sh
dotnet restore
```

### 🔹 **Passo 3: Compilar o Projeto**
```sh
dotnet build
```

### 🔹 **Passo 4: Executar o Programa**
```sh
dotnet run --project src/HelloWorld
```

Isso imprimirá no terminal:
```
Hello, World!
```

---

## 🛠️ Criando um Script de Instalação (Opcional)

Caso queiras reinstalar tudo e rodar o projeto automaticamente, podes criar um script de setup.

### **Linux/macOS (`setup.sh`):**
```sh
#!/bin/bash

echo "🔄 Limpando projeto..."
rm -rf bin obj

echo "📦 Instalando dependências..."
dotnet restore

echo "🛠️ Compilando..."
dotnet build

echo "🚀 Executando..."
dotnet run --project src/HelloWorld
```

Dá permissão de execução ao script:
```sh
chmod +x setup.sh
```

E executa:
```sh
./setup.sh
```

### **Windows (`setup.bat`):**
```bat
@echo off
echo 🔄 Limpando projeto...
rmdir /s /q bin obj

echo 📦 Instalando dependências...
dotnet restore

echo 🛠️ Compilando...
dotnet build

echo 🚀 Executando...
dotnet run --project src/HelloWorld
```

Executa no **Prompt de Comando**:
```sh
setup.bat
```

---

## 📚 Explicação do Código

Aqui está um exemplo simples de código **Q#** usado neste projeto:

```qsharp
namespace HelloWorld {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    operation HelloWorld() : Unit {
        Message("Hello, World!");
    }
}
```

Este código usa a operação `Message()` para exibir `"Hello, World!"` no console.  
Podes modificar este código para incluir operações quânticas específicas do protocolo **BB84**.

---

## 🤝 Contribuições

Ficamos felizes em receber contribuições! Para sugerir melhorias ou relatar problemas:

1. Cria uma **Issue** descrevendo o problema ou sugestão.
2. Faz um **Fork** do repositório.
3. Cria um **Branch** para tua contribuição.
4. Envia um **Pull Request** com as alterações.

---

## 📜 Licença

Este projeto é distribuído sob a **MIT License**. 📄

---

🚀 **QKD BB84 em Q# - Segurança Quântica para o Futuro!** 🔒✨

