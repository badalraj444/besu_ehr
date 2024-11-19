const fs = require("fs").promises;
const solc = require("solc");

async function main() {
  // Load the Registry contract source code
  const sourceCode = await fs.readFile("Registry.sol", "utf8");

  // Compile the source code and retrieve the ABI and bytecode
  const { abi, bytecode } = compile(sourceCode, "Registry");

  // Store the ABI and bytecode into a JSON file
  const artifact = JSON.stringify({ abi, bytecode }, null, 2);
  await fs.writeFile("Registry.json", artifact);

  console.log("Registry contract compiled successfully!");
}

function compile(sourceCode, contractName) {
  // Create the Solidity Compiler Standard Input and Output JSON
  const input = {
    language: "Solidity",
    sources: { main: { content: sourceCode } },
    settings: { outputSelection: { "*": { "*": ["abi", "evm.bytecode"] } } },
  };

  // Parse the compiler output to retrieve the ABI and bytecode
  const output = solc.compile(JSON.stringify(input));
  const artifact = JSON.parse(output).contracts.main[contractName];
  
  return {
    abi: artifact.abi,
    bytecode: artifact.evm.bytecode.object,
  };
}

main().then(() => process.exit(0)).catch(console.error);
