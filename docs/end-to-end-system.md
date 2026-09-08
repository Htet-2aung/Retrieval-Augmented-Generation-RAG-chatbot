flowchart TD
    subgraph Client_Layer ["Client Layer (ReactJS + Tailwind)"]
        UI["Chat UI & Admin Dashboard"]
    end

    subgraph Backend_Layer ["Core Backend Layer (Node.js)"]
        API["REST API Router"]
        Auth["JWT Auth & Role Guard"]
        Session["Session Manager"]
        Cache["In-Memory Cache (LRU)"]
    end

    subgraph AI_Layer ["AI Engine Layer (FastAPI + Python)"]
        SSERouter["SSE Stream Router"]
        Agent["LangGraph Agentic RAG"]
        LLM["OpenAI API (GPT-4o-mini)"]
    end

    subgraph Data_Layer ["Database Layer (PostgreSQL)"]
        Relational["Relational Data<br>(Users, Chats, Docs)"]
        Vector["Vector Store<br>(pgvector Embeddings)"]
    end

    %% Flow Execution
    UI -->|1. HTTP POST /chat| API
    API -->|2. Validate Token| Auth
    Auth -->|3. Read/Write Auth Data| Relational
    
    API -->|4. Check Cache| Cache
    Cache -.->|5. Cache Miss| Session
    Session -->|6. Save Chat State| Relational
    
    API -->|7. Forward Query| SSERouter
    SSERouter -->|8. Invoke State Graph| Agent
    
    Agent -->|9. Hybrid Search| Vector
    Agent -->|10. Generate Response| LLM
    
    Agent -->|11. Stream Tokens| SSERouter
    SSERouter -->|12. Server-Sent Events| API
    API -->|13. Stream to Client| UI

    %% Styling
    classDef client fill:#0f172a,stroke:#3b82f6,stroke-width:2px,color:#f8fafc;
    classDef backend fill:#1e293b,stroke:#10b981,stroke-width:2px,color:#f8fafc;
    classDef ai fill:#1e293b,stroke:#f59e0b,stroke-width:2px,color:#f8fafc;
    classDef data fill:#020617,stroke:#6366f1,stroke-width:2px,color:#f8fafc;

    class UI client;
    class API,Auth,Session,Cache backend;
    class SSERouter,Agent,LLM ai;
    class Relational,Vector data;