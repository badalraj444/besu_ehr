const fs = require("fs").promises;
const solc = require("solc");

async function main() {
  // Load the Metadata, Registry, and Permission contract source code
  const metadataSource = await fs.readFile("Metadata.sol", "utf8");
  const registrySource = await fs.readFile("Registry.sol", "utf8");
  const permissionSource = await fs.readFile("Permission.sol", "utf8");

  // Compile the source code and retrieve the ABI and bytecode
  const { abi, bytecode } = compile(metadataSource, registrySource, permissionSource, "Metadata");

  // Store the ABI and bytecode into a JSON file
  const artifact = JSON.stringify({ abi, bytecode }, null, 2);
  await fs.writeFile("Metadata.json", artifact);

  console.log("Metadata contract compiled successfully!");
}

function compile(metadataSource, registrySource, permissionSource, contractName) {
  // Create the Solidity Compiler Standard Input and Output JSON
  const input = {
    language: "Solidity",
    sources: {
      "Metadata.sol": { content: metadataSource },
      "Registry.sol": { content: registrySource },
      "Permission.sol": { content: permissionSource }
    },
    settings: { outputSelection: { "*": { "*": ["abi", "evm.bytecode"] } } },
  };

  // Compile the contract
  const output = solc.compile(JSON.stringify(input));
  const parsedOutput = JSON.parse(output);

  // Debug: Log parsed output to check structure
  console.log("Parsed Output:", parsedOutput);

  const artifact = parsedOutput.contracts["Metadata.sol"][contractName];
  
  return {
    abi: artifact.abi,
    bytecode: artifact.evm.bytecode.object,
  };
}

main().then(() => process.exit(0)).catch(console.error);
