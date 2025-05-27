---
marp: true
---
## ElixirでローカルLLM＋Difyを動かし、MCPが混ざると …
---
### 実際に動かしてみる😺

<video src="LLM_run.mp4" controls width="950" ></video>

---
 ## LiveView
 - 人間とのインターフェース
     <img src="01.png" width="900">
---
 ## Dify
  - LiveViewとのインターフェース
  - 開始はLiveViewから文章を受け取ります
  <img src="02.png" width="800">
---
 ## Dify
  - MCPサーバーとのインターフェース
  - クライアントとしてMCP FunctionCallingを使う
  <img src="03.png" width="780">
---
 ## Dify
  - LLMその２　
  <img src="06.png" width="780">
---
 ## Dify
  - LM-Studioとインターフェース
  - モデルプロバーダー OpenAI-API-compatible
  <img src="04.png" width="780">
---
 ## Dify
  - 終了はLiveViewから文章を渡します
  <img src="07.png" width="780">
---
## MCPサーバー
 - MCPサーバー（server-filesystem）
   - MCPクライアントの指示の元ファイル操作をする
 - MCPサーバーのプロキシ(supergateway)
   - SDTIO(MCPサーバ) <=>　Dify(SSE)に変換
###  server-filesystemをsupergateway経由で起動
 ```
 $ npx -y supergateway --stdio "npx -y @modelcontextprotocol/server-filesystem ~/local/mcp/tmp"
 ```
---
### MCPサーバーの検証
```
npx @modelcontextprotocol/inspector
```
 <img src="05.png" width="780">

---
 # LM-Studio
   - LLM（Large Language Models）を動かす本体
   - モデル internlm2_5-20b-chat
    <img src="08.png" width="780">
---
 # LM-Studio
   - ランタイム CUDA llama.cpp (Linux)
     - Vulkan llama.cpp (Linux)でも可能
  <img src="09.png" width="700">
---


