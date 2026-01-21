module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",     // Localhost
      port: 7545,            // Standard Ganache UI port
      network_id: "*",       // Match any network id
    },
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.20",      // MATCHES your contract pragmas
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        },
        evmVersion: "paris"   // <--- CRITICAL FIX: Prevents "Invalid Opcode" error on Ganache
      }
    }
  }
};