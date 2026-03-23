[vector_db_reflection.md](https://github.com/user-attachments/files/26184999/vector_db_reflection.md)
# Vector DB Reflection

## Vector DB Use Case

A traditional keyword-based database search would **not** suffice for a law firm's contract search system, and the reasons are fundamental rather than merely technical.

Keyword search operates by matching exact or stemmed tokens — it will find "termination" wherever it appears, but it cannot understand that phrases like "either party may discontinue this agreement upon written notice" or "this contract shall expire upon breach of the obligations set forth in Section 5" are both describing termination clauses. Legal language is notoriously varied: different drafters use different vocabulary, contracts span jurisdictions with different terminologies, and the same concept can be expressed across multiple non-adjacent paragraphs. A keyword query for "termination" would miss these semantically equivalent passages entirely, while simultaneously returning irrelevant mentions of the word in unrelated contexts.

A vector database solves this by storing each chunk of the contract as a high-dimensional embedding — a numerical representation that encodes *meaning*, not just characters. When a lawyer types "What are the termination clauses?", that query is also converted into an embedding, and the system retrieves contract chunks whose vectors are closest in semantic space, regardless of the exact words used.

In practice, the pipeline would: (1) split each 500-page contract into overlapping chunks, (2) embed each chunk using a language model such as `all-MiniLM-L6-v2` or a legal-domain model, (3) store those vectors in a database like Pinecone, Weaviate, or pgvector, and (4) at query time, embed the natural-language question and perform an approximate nearest-neighbour search to retrieve the most relevant chunks, which are then passed to an LLM for a synthesised answer.

This approach handles synonyms, paraphrasing, and implicit meaning — exactly the qualities that make contract language challenging and that keyword search cannot address.
