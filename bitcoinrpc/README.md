# Bitcoin RPC Readme

Just a few basic notes when trying to work with the Bitcoin RPC in Bitcoin Core - 

1) Inside the configuration file, you're need to set credentials for JSON RPC commands -
   - Under "Accept command line and JSON-RPC commands" -
     - server
     - rpcuser
     - rpcpassword
     - rpcallowip
2) Inside the configuration file, you're going to need to turn on full transaction indexing -
   - Under "Maintain a full transaction index ..." -
     - txindex needs to be set to 1
3) If your node has already been functional before you turned on txindex, reindexing is going to take a long time and your JSON RPC calls are not going to work until this indexing is complete. While there is no graphical queue in Bitcoin Core to tell if reindexing is still occurring, you can check the status of your reindex by opening the debug.log file. If you see an entry that looks something like <em>2024-12-28T15:47:14Z Syncing txindex with block chain from height 632291</em> then you know reindexing is still occurring.
4) scantxoutset is going to run very slowly since it performs a full scan of the UTXO set for the specified address. This is likely overkill if you're looking to just get a wallet's balance and should probably be reserved for economic nodes wanting to deeply verify wallet balances before crediting accounts.
