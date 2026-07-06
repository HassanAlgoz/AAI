#import "@preview/touying:0.6.1": *
#import "@preview/curryst:0.5.1" as curryst: rule
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#import "/template/theme.typ": *

#show: university-theme.with(
  config-colors(
    primary: primary-color,
    secondary: secondary-color,
    tertiary: tertiary-color,
    neutral-darkest: text-color
  ),
  config-info(
    title: [Introduction to RAG],
    subtitle: [Retrieval Augmented Generation — ground LLMs with your own data.],
    author: [Hassan Algoz],
    date: datetime.today(),
  ),
)

#set heading(numbering: "1.")

#title-slide()

= Introduction to RAG

== Overview

Large language models like GPT-5, Claude, or Gemini can write code, answer questions, generate content, and solve complex problems with remarkable sophistication. You can build chatbots, content generators, coding assistants, and analysis tools by crafting good prompts and calling AI APIs.

- *Customer support* AI agents navigate product documentation, past ticket resolutions, and company knowledge bases, while dynamically adjusting their search based on specific use cases. #pause
- *Legal assistants* search across case law databases, statutes, regulatory documents, and internal firm precedents. #pause
- *Medical AI* systems query across clinical guides, research papers, patient records, and drug databases to support medical reasoning. #pause
- *Coding assistants* search across documentation, code repositories, and issue trackers to help developers solve problems.

#pagebreak()

=== Problem

As you start to build applications that require knowledge not available to an LLM, you'll quickly run into some fundamental limitations:

+ *Token Limits:* AI models have maximum input lengths. Even the largest models might not be able to fit an entire company's documentation in a single prompt. #pause
+ *Cost:* AI APIs typically charge per token. Including thousands of words of context in every request becomes expensive quickly. #pause
+ *Relevance:* When you include too much information, the AI can get confused or focus on irrelevant details instead of what actually matters for answering the user's question. #pause
+ *Freshness:* Information changes constantly. Product specs update, policies change, new documentation gets written. Keeping everything in prompts means manually updating every prompt whenever anything changes. #pause
+ *Hallucinations:* Without the correct information or focus for answering a user's question, LLMs may produce a wrong answer with an authoritative voice. For most business applications, where accuracy matters, hallucination is a critical problem.

#pagebreak()

=== Solution

*Retrieval Augmented Generation (RAG)* addresses these problems by fetching relevant out-of-training knowledge, and injecting it into the prompt before invoking the LLM, guiding the answer with context-specific information.

In short, *RAG* is a three step process: #pause

+ *Retrieval*: find text relevant to answering the question #pause
+ *Augmentation*: concatenate it into the prompt #pause
+ *Generation*: invoke the LLM #pause

== How RAG Works

A simple RAG workflow from question to answer is shown below:

#align(center)[
  #diagram(
    node-stroke: luma(80%),
    edge-corner-radius: none,
    spacing: (28pt, 32pt),

    node((2, 0), [Question], name: <q>),
    node((0, 1), [Retriever], name: <r>),
    node((1, 1), [Relevant docs], name: <docs>),
    node((3, 1), [LLM], name: <llm>),
    node((4, 1), [Answer], name: <a>),

    edge(<q>, <r>, "-|>"),
    edge(<r>, <docs>, "-|>"),
    edge(<docs>, <llm>, "-|>"),
    edge(<q>, <llm>, "-|>"),
    edge(<llm>, <a>, "-|>"),
  )
]

#pagebreak()

We actually have already seen RAG when #link("09_dspy_ReAct.ipynb")[we built the `ReAct` agent] that searched via a search engine library `ddgs` and used that information to answer the users' question.

A *Retriever* has to know _how_ to find the data. If we have private data, we would need to build our own *Information Retrieval (IR)* system; so we'll need to understand:

+ _Indexing_
+ _Retrieval_

Since they are affected by the type of data, we will list the three types of data in the structured–unstructured spectrum.

== Structured Data

Relational and non-relational database management systems have their own indexing and querying mechanisms. So, if our data is structured, we can already leverage existing software for that; through SQL and some non-SQL languages.

=== Examples of Structured Data

Structured data is information that is organized in a fixed schema, typically in tables with rows and columns.
#pagebreak()
*Customer Database:*

#table(
  columns: 4,
  align: (center, left, left, center),
  table.header([*id*], [*name*], [*email*], [*signup\_date*]),
  [1], [Alice], [alice\@email.com], [2024-01-10],
  [2], [Bob], [bob\@email.com], [2024-01-20],
)

*Product Inventory:*

#table(
  columns: 4,
  align: (center, left, center, center),
  table.header([*product\_id*], [*product\_name*], [*price*], [*in\_stock*]),
  [101], [Widget A], [10.00], [Yes],
  [102], [Widget B], [15.00], [No],
)

*Support Tickets (in a database):*

#table(
  columns: 4,
  align: (center, center, left, left),
  table.header([*ticket\_id*], [*customer\_id*], [*status*], [*created\_at*]),
  [1001], [1], [Open], [2024-05-10T08:00Z],
  [1002], [2], [Resolved], [2024-05-11T13:22Z],
)

== Semi-structured Data

Semi-structured data sits in-between perfectly organized tables and completely unstructured text. It has organizational markers (like fields or tags) but may not follow a rigid schema.

*JSON and XML files:* Used in config files, web APIs, or data exports—containing nested fields and arrays, but not always consistent in structure.

#pagebreak()

JSON strings like:

```json
[
    {
    "id": 1,
    "name": "Alice",
    "email": "alice@email.com",
    "signup_date": "2024-01-10"
    },
    {
    "id": 2,
    "name": "Bob",
    "email": "bob@email.com",
    "signup_date": "2024-01-20"
    }
]
```

XML strings like:

```xml
<users>
    <user>
    <id>1</id>
    <name>Alice</name>
    <email>alice@email.com</email>
    <signup_date>2024-01-10</signup_date>
    </user>
    <user>
    <id>2</id>
    <name>Bob</name>
    <email>bob@email.com</email>
    <signup_date>2024-01-20</signup_date>
    </user>
</users>
```

== Unstructured Data

*Unstructured data* has little to no inherent organization—no fields, tags, or schema—just raw text, images, audio, or other free-form content.

Here is an email in common #link("https://datatracker.ietf.org/doc/html/rfc5322")[RFC 5322] format:

#pagebreak()

```text
From: "Bob Example" <bob@email.com>
To: "Alice Example" <alice@email.com>
Subject: Welcome!
Date: Tue, 2 Apr 2024 14:05:00 +0000
Message-ID: <1234@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"

Hi Alice,

Welcome to the platform. Let us know if you have any questions!

Best,
Bob
```

While emails have defined fields (like sender, subject, date), the body is often unstructured text.

*Examples of Unstructured Data:*

- *Plain text:* News articles, books, conversations, social media posts, logs, etc.
- *Media files:* Images, audio recordings, video.
- *Mixed types:* HTML documents often contain chunks of unstructured text, scripts, and formatting; PDFs often contain mixed types as well.

== Indexing and Retrieval

DBMS (Database Management Systems) implement indexing mechanisms that allow easy querying using a standardized language: SQL, to retrieve relevant records.

```sql
SELECT full_name, age FROM users WHERE user_id = 123;
```

Even non-SQL, non-relational databases have their own SQL-like declarative language to query their systems to retrieve relevant records.

#pagebreak()

```json
{
  "find": "users",
  "filter": { "user_id": 123 },
  "projection": { "full_name": 1, "age": 1, "_id": 0 }
}
```

Or using the programmatic API:

```js
db.users.find(
  { user_id: 123 },
  { full_name: 1, age: 1, _id: 0 }
)
```
#pagebreak()
=== Document Collections

When it comes to unstructured data, we have to design our *collection schema* and *chunking strategy* based on the data:

- What *types of searches* do we want to support? (_semantic_, _regex_, keyword, etc.)
- What are the meaningful units of data we want to store as *records*? (i.e., what's a _Document_)
- What *metadata* fields can we leverage when querying?
- What *embedding models* should we use for semantic and keyword searches?

#pagebreak()

The structure of our collections, the granularity of our chunks, and the metadata we capture — all directly impact retrieval quality — and by extension, the quality of the LLM's responses in our AI application.

We'll start out with #link("15_chunking.ipynb")[types of search] after this #link("14_chromadb.ipynb")[ChromaDB quick start].
