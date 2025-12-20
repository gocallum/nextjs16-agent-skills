---
title: "AI Agents & UI - Building Agentic Applications with AI SDK 6"
description: "Comprehensive guide for building AI agents using ToolLoopAgent, workflow patterns, and AI SDK UI components (useChat, generative UIs, tool calling)"
keywords: ["ToolLoopAgent", "agents", "workflows", "AI SDK UI", "useChat", "generative-ui", "tool-calling", "chatbot"]
---

# AI Agents & UI Skills

**Status:** AI SDK 6 Beta
**Package Manager:** pnpm
**Key Version:** @ai-sdk/core, @ai-sdk/react (for UI)
**Official Docs:** 
- [Agents Overview](https://v6.ai-sdk.dev/docs/agents/overview)
- [Building Agents](https://v6.ai-sdk.dev/docs/agents/building-agents)
- [Workflow Patterns](https://v6.ai-sdk.dev/docs/agents/workflows)
- [AI SDK UI](https://v6.ai-sdk.dev/docs/ai-sdk-ui/overview)
- [Chatbot Guide](https://v6.ai-sdk.dev/docs/ai-sdk-ui/chatbot)
- [Chatbot Tool Usage](https://v6.ai-sdk.dev/docs/ai-sdk-ui/chatbot-tool-usage)
- [Generative User Interfaces](https://v6.ai-sdk.dev/docs/ai-sdk-ui/generative-user-interfaces)

---

## Table of Contents

1. [Installation & Setup](#installation--setup)
2. [Understanding Agents](#understanding-agents)
3. [Building ToolLoopAgent](#building-toolloopagent)
4. [Agent Configuration Options](#agent-configuration-options)
5. [System Instructions & Behavior](#system-instructions--behavior)
6. [Workflow Patterns](#workflow-patterns)
7. [AI SDK UI - useChat Hook](#ai-sdk-ui---usechat-hook)
8. [Building Chatbot Applications](#building-chatbot-applications)
9. [Tool Calling in UI](#tool-calling-in-ui)
10. [Generative User Interfaces](#generative-user-interfaces)
11. [Advanced Patterns](#advanced-patterns)
12. [Best Practices](#best-practices)

---

## Installation & Setup

### Install Dependencies

```bash
# Core packages
pnpm add ai @ai-sdk/core @ai-sdk/anthropic

# For UI (React)
pnpm add @ai-sdk/react

# Optional: specific providers
pnpm add @ai-sdk/openai @ai-sdk/google
```

### TypeScript Configuration

Ensure your `tsconfig.json` has proper settings:

```json
{
  "compilerOptions": {
    "target": "ES2020",
    "lib": ["ES2020", "DOM"],
    "moduleResolution": "bundler",
    "strict": true
  }
}
```

---

## Understanding Agents

### What Are Agents?

Agents are LLMs that use tools in a loop to accomplish tasks. Three core components work together:

1. **LLMs** - Process input, decide next action
2. **Tools** - Extend capabilities (APIs, databases, files)
3. **Loop** - Orchestrates execution through context management and stopping conditions

### ToolLoopAgent Class

The `ToolLoopAgent` class is the recommended approach because it:

- **Reduces boilerplate** - Manages loops and message arrays automatically
- **Improves reusability** - Define once, use throughout application
- **Simplifies maintenance** - Single place to update configuration
- **Provides type safety** - Full TypeScript support for tools and outputs

### vs. Core Functions

For most use cases, use `ToolLoopAgent`. Use core functions (`generateText`, `streamText`) when you need explicit control for complex structured workflows.

---

## Building ToolLoopAgent

### Basic Agent

```typescript
import { ToolLoopAgent, tool } from 'ai';
import { z } from 'zod';

const weatherAgent = new ToolLoopAgent({
  model: 'anthropic/claude-sonnet-4.5',
  tools: {
    weather: tool({
      description: 'Get weather in a location (Fahrenheit)',
      inputSchema: z.object({
        location: z.string().describe('The location'),
      }),
      execute: async ({ location }) => ({
        location,
        temperature: 72 + Math.floor(Math.random() * 21) - 10,
      }),
    }),
    convertFahrenheitToCelsius: tool({
      description: 'Convert Fahrenheit to Celsius',
      inputSchema: z.object({
        temperature: z.number(),
      }),
      execute: async ({ temperature }) => ({
        celsius: Math.round((temperature - 32) * (5 / 9)),
      }),
    }),
  },
});

// Use the agent
const result = await weatherAgent.generate({
  prompt: 'What is the weather in San Francisco in celsius?',
});

console.log(result.text); // Agent's final answer
console.log(result.steps); // Steps taken by agent
```

### Multi-Tool Execution

The agent automatically:
1. Calls `weather` tool to get temperature in Fahrenheit
2. Calls `convertFahrenheitToCelsius` to convert it
3. Generates final text response with result

---

## Agent Configuration Options

### Model and System Instructions

```typescript
const agent = new ToolLoopAgent({
  model: 'anthropic/claude-sonnet-4.5',
  instructions: 'You are an expert data analyst. Provide clear insights.',
});
```

### Tools

```typescript
const codeAgent = new ToolLoopAgent({
  model: 'anthropic/claude-sonnet-4.5',
  tools: {
    runCode: tool({
      description: 'Execute Python code',
      inputSchema: z.object({
        code: z.string(),
      }),
      execute: async ({ code }) => {
        // Execute code
        return { output: 'Result' };
      },
    }),
  },
});
```

### Loop Control (stopWhen)

By default, agents run for 20 steps (`stopWhen: stepCountIs(20)`). Each step is one generation (text or tool call).

```typescript
import { ToolLoopAgent, stepCountIs } from 'ai';

const agent = new ToolLoopAgent({
  model: 'anthropic/claude-sonnet-4.5',
  stopWhen: stepCountIs(20), // Allow up to 20 steps
});

// Combine multiple stop conditions
const agent2 = new ToolLoopAgent({
  model: 'anthropic/claude-sonnet-4.5',
  stopWhen: [
    stepCountIs(20),
    yourCustomCondition(), // Custom logic
  ],
});
```

The loop stops when:
- Finish reasoning (non-tool-call) is returned
- Tool without execute function is invoked
- Tool call needs approval
- Stop condition is met

### Tool Choice

Control how agent uses tools:

```typescript
const agent = new ToolLoopAgent({
  model: 'anthropic/claude-sonnet-4.5',
  tools: { /* ... */ },
  toolChoice: 'required', // Force tool use
  // or 'none' to disable tools
  // or 'auto' (default) to let model decide
});

// Force specific tool
const agent2 = new ToolLoopAgent({
  model: 'anthropic/claude-sonnet-4.5',
  tools: { weather: weatherTool, attractions: attractionsTool },
  toolChoice: {
    type: 'tool',
    toolName: 'weather', // Force weather tool
  },
});
```

### Structured Output

Define structured output schemas:

```typescript
import { ToolLoopAgent, Output, stepCountIs } from 'ai';

const analysisAgent = new ToolLoopAgent({
  model: 'anthropic/claude-sonnet-4.5',
  output: Output.object({
    schema: z.object({
      sentiment: z.enum(['positive', 'neutral', 'negative']),
      summary: z.string(),
      keyPoints: z.array(z.string()),
    }),
  }),
  stopWhen: stepCountIs(10),
});

const { output } = await analysisAgent.generate({
  prompt: 'Analyze customer feedback',
});
```

---

## System Instructions & Behavior

### Basic System Instructions

```typescript
const agent = new ToolLoopAgent({
  model: 'anthropic/claude-sonnet-4.5',
  instructions: 'You are an expert software engineer.',
});
```

### Detailed Behavioral Instructions

```typescript
const codeReviewAgent = new ToolLoopAgent({
  model: 'anthropic/claude-sonnet-4.5',
  instructions: `You are a senior software engineer conducting code reviews.

Your approach:
- Focus on security vulnerabilities first
- Identify performance bottlenecks
- Suggest improvements for readability and maintainability
- Be constructive and educational in your feedback
- Always explain why something is an issue and how to fix it`,
});
```

### Constrain Agent Behavior

```typescript
const supportAgent = new ToolLoopAgent({
  model: 'anthropic/claude-sonnet-4.5',
  instructions: `You are a customer support specialist.

Rules:
- Never make promises about refunds without checking policy
- Always be empathetic and professional
- If you don't know something, say so and offer to escalate
- Keep responses concise and actionable
- Never share internal company information`,
  tools: {
    checkOrderStatus,
    lookupPolicy,
    createTicket,
  },
});
```

### Tool Usage Instructions

```typescript
const researchAgent = new ToolLoopAgent({
  model: 'anthropic/claude-sonnet-4.5',
  instructions: `You are a research assistant with access to search and document tools.

When researching:
1. Always start with a broad search to understand the topic
2. Use document analysis for detailed information
3. Cross-reference multiple sources before drawing conclusions
4. Cite your sources when presenting information
5. If information conflicts, present both viewpoints`,
  tools: {
    webSearch,
    analyzeDocument,
    extractQuotes,
  },
});
```

### Format and Style Instructions

```typescript
const technicalWriterAgent = new ToolLoopAgent({
  model: 'anthropic/claude-sonnet-4.5',
  instructions: `You are a technical documentation writer.

Writing style:
- Use clear, simple language
- Avoid jargon unless necessary
- Structure information with headers and bullet points
- Include code examples where relevant
- Write in second person ("you" instead of "the user")

Always format responses in Markdown.`,
});
```

---

## Workflow Patterns

Combine patterns thoughtfully to build reliable solutions for complex problems.

### 1. Sequential Processing (Chains)

Execute steps in predefined order. Each step's output becomes next step's input.

**Use case:** Content generation pipelines, data transformation processes

```typescript
import { generateText, generateObject } from 'ai';
import { z } from 'zod';

async function generateMarketingCopy(input: string) {
  const model = 'anthropic/claude-sonnet-4.5';

  // Step 1: Generate marketing copy
  const { text: copy } = await generateText({
    model,
    prompt: `Write persuasive marketing copy for: ${input}. Focus on benefits and emotional appeal.`,
  });

  // Step 2: Quality check
  const { object: qualityMetrics } = await generateObject({
    model,
    schema: z.object({
      hasCallToAction: z.boolean(),
      emotionalAppeal: z.number().min(1).max(10),
      clarity: z.number().min(1).max(10),
    }),
    prompt: `Evaluate this marketing copy:
1. Presence of call to action (true/false)
2. Emotional appeal (1-10)
3. Clarity (1-10)

Copy to evaluate: ${copy}`,
  });

  // Step 3: Regenerate if needed
  if (
    !qualityMetrics.hasCallToAction ||
    qualityMetrics.emotionalAppeal < 7 ||
    qualityMetrics.clarity < 7
  ) {
    const { text: improvedCopy } = await generateText({
      model,
      prompt: `Rewrite this marketing copy with:
${!qualityMetrics.hasCallToAction ? '- A clear call to action' : ''}
${qualityMetrics.emotionalAppeal < 7 ? '- Stronger emotional appeal' : ''}
${qualityMetrics.clarity < 7 ? '- Improved clarity and directness' : ''}

Original copy: ${copy}`,
    });
    return { copy: improvedCopy, qualityMetrics };
  }

  return { copy, qualityMetrics };
}
```

### 2. Routing

Let the model decide which path to take based on context and intermediate results.

**Use case:** Handling varied inputs that require different processing approaches

```typescript
import { generateObject, generateText } from 'ai';
import { z } from 'zod';

async function handleCustomerQuery(query: string) {
  const model = 'anthropic/claude-sonnet-4.5';

  // Step 1: Classify the query
  const { object: classification } = await generateObject({
    model,
    schema: z.object({
      reasoning: z.string(),
      type: z.enum(['general', 'refund', 'technical']),
      complexity: z.enum(['simple', 'complex']),
    }),
    prompt: `Classify this customer query: ${query}

Determine:
1. Query type (general, refund, or technical)
2. Complexity (simple or complex)
3. Brief reasoning`,
  });

  // Step 2: Route based on classification
  const { text: response } = await generateText({
    model:
      classification.complexity === 'simple'
        ? 'openai/gpt-4o-mini'
        : 'openai/o4-mini',
    system: {
      general: 'You are an expert customer service agent.',
      refund: 'You are a refund specialist. Follow company policy strictly.',
      technical: 'You are a technical support specialist.',
    }[classification.type],
    prompt: query,
  });

  return { response, classification };
}
```

### 3. Parallel Processing

Break tasks into independent subtasks that execute simultaneously.

**Use case:** Analyzing multiple documents, different aspects of input (like code review)

```typescript
import { generateText, generateObject } from 'ai';
import { z } from 'zod';

async function parallelCodeReview(code: string) {
  const model = 'anthropic/claude-sonnet-4.5';

  // Run parallel reviews
  const [securityReview, performanceReview, maintainabilityReview] =
    await Promise.all([
      generateObject({
        model,
        system: 'You are an expert in code security.',
        schema: z.object({
          vulnerabilities: z.array(z.string()),
          riskLevel: z.enum(['low', 'medium', 'high']),
          suggestions: z.array(z.string()),
        }),
        prompt: `Review this code: ${code}`,
      }),
      generateObject({
        model,
        system: 'You are an expert in code performance.',
        schema: z.object({
          issues: z.array(z.string()),
          impact: z.enum(['low', 'medium', 'high']),
          optimizations: z.array(z.string()),
        }),
        prompt: `Review this code: ${code}`,
      }),
      generateObject({
        model,
        system: 'You are an expert in code quality.',
        schema: z.object({
          concerns: z.array(z.string()),
          qualityScore: z.number().min(1).max(10),
          recommendations: z.array(z.string()),
        }),
        prompt: `Review this code: ${code}`,
      }),
    ]);

  // Aggregate results
  const { text: summary } = await generateText({
    model,
    system: 'You are a technical lead summarizing multiple code reviews.',
    prompt: `Synthesize these code review results into a concise summary:
${JSON.stringify(
  [
    { ...securityReview.object, type: 'security' },
    { ...performanceReview.object, type: 'performance' },
    { ...maintainabilityReview.object, type: 'maintainability' },
  ],
  null,
  2,
)}`,
  });

  return { reviews: [securityReview.object, performanceReview.object, maintainabilityReview.object], summary };
}
```

### 4. Orchestrator-Worker

Primary model coordinates specialized workers. Each worker optimizes for specific subtask.

**Use case:** Complex tasks requiring different types of expertise

```typescript
import { generateObject } from 'ai';
import { z } from 'zod';

async function implementFeature(featureRequest: string) {
  // Orchestrator: Plan the implementation
  const { object: implementationPlan } = await generateObject({
    model: 'anthropic/claude-sonnet-4.5',
    schema: z.object({
      files: z.array(
        z.object({
          purpose: z.string(),
          filePath: z.string(),
          changeType: z.enum(['create', 'modify', 'delete']),
        }),
      ),
      estimatedComplexity: z.enum(['low', 'medium', 'high']),
    }),
    system:
      'You are a senior software architect planning feature implementations.',
    prompt: `Analyze this feature request and create an implementation plan: ${featureRequest}`,
  });

  // Workers: Execute the planned changes
  const fileChanges = await Promise.all(
    implementationPlan.files.map(async (file) => {
      const workerSystemPrompt = {
        create:
          'You are an expert at implementing new files following best practices.',
        modify:
          'You are an expert at modifying existing code while maintaining consistency.',
        delete:
          'You are an expert at safely removing code while ensuring no breaking changes.',
      }[file.changeType];

      const { object: change } = await generateObject({
        model: 'anthropic/claude-sonnet-4.5',
        schema: z.object({
          explanation: z.string(),
          code: z.string(),
        }),
        system: workerSystemPrompt,
        prompt: `Implement changes for ${file.filePath} to support: ${file.purpose}`,
      });

      return {
        file,
        implementation: change,
      };
    }),
  );

  return {
    plan: implementationPlan,
    changes: fileChanges,
  };
}
```

### 5. Evaluator-Optimizer

Add quality control with dedicated evaluation steps that assess intermediate results.

**Use case:** Robust workflows with self-improvement and error recovery

```typescript
import { generateText, generateObject } from 'ai';
import { z } from 'zod';

async function translateWithFeedback(text: string, targetLanguage: string) {
  let currentTranslation = '';
  let iterations = 0;
  const MAX_ITERATIONS = 3;

  // Initial translation
  const { text: translation } = await generateText({
    model: 'anthropic/claude-sonnet-4.5',
    system: 'You are an expert literary translator.',
    prompt: `Translate this text to ${targetLanguage}, preserving tone and cultural nuances: ${text}`,
  });

  currentTranslation = translation;

  // Evaluation-optimization loop
  while (iterations < MAX_ITERATIONS) {
    // Evaluate current translation
    const { object: evaluation } = await generateObject({
      model: 'anthropic/claude-sonnet-4.5',
      schema: z.object({
        qualityScore: z.number().min(1).max(10),
        preservesTone: z.boolean(),
        preservesNuance: z.boolean(),
        culturallyAccurate: z.boolean(),
        specificIssues: z.array(z.string()),
        improvementSuggestions: z.array(z.string()),
      }),
      system: 'You are an expert in evaluating literary translations.',
      prompt: `Evaluate this translation:
Original: ${text}
Translation: ${currentTranslation}

Consider: tone, nuance, cultural accuracy`,
    });

    // Check if quality meets threshold
    if (
      evaluation.qualityScore >= 8 &&
      evaluation.preservesTone &&
      evaluation.preservesNuance &&
      evaluation.culturallyAccurate
    ) {
      break;
    }

    // Generate improved translation based on feedback
    const { text: improvedTranslation } = await generateText({
      model: 'anthropic/claude-sonnet-4.5',
      system: 'You are an expert literary translator.',
      prompt: `Improve this translation based on feedback:
${evaluation.specificIssues.join('\n')}
${evaluation.improvementSuggestions.join('\n')}

Original: ${text}
Current Translation: ${currentTranslation}`,
    });

    currentTranslation = improvedTranslation;
    iterations++;
  }

  return {
    finalTranslation: currentTranslation,
    iterationsRequired: iterations,
  };
}
```

---

## AI SDK UI - useChat Hook

The `useChat` hook makes it effortless to create a conversational UI for chatbot applications.

### Features

- **Message Streaming** - Real-time streaming from AI provider
- **Managed States** - Input, messages, status, error states
- **Seamless Integration** - Easy integration into any design

### Basic Example

**Client:**

```typescript
'use client';

import { useChat } from '@ai-sdk/react';
import { DefaultChatTransport } from 'ai';
import { useState } from 'react';

export default function Page() {
  const { messages, sendMessage, status } = useChat({
    transport: new DefaultChatTransport({
      api: '/api/chat',
    }),
  });
  const [input, setInput] = useState('');

  return (
    <>
      {messages.map((message) => (
        <div key={message.id}>
          {message.role === 'user' ? 'User: ' : 'AI: '}
          {message.parts.map((part, index) =>
            part.type === 'text' ? <span key={index}>{part.text}</span> : null,
          )}
        </div>
      ))}

      <form
        onSubmit={(e) => {
          e.preventDefault();
          if (input.trim()) {
            sendMessage({ text: input });
            setInput('');
          }
        }}
      >
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          disabled={status !== 'ready'}
          placeholder="Say something..."
        />
        <button type="submit" disabled={status !== 'ready'}>
          Submit
        </button>
      </form>
    </>
  );
}
```

**Server:**

```typescript
import { convertToModelMessages, streamText, UIMessage } from 'ai';

export const maxDuration = 30;

export async function POST(req: Request) {
  const { messages }: { messages: UIMessage[] } = await req.json();

  const result = streamText({
    model: 'anthropic/claude-sonnet-4.5',
    system: 'You are a helpful assistant.',
    messages: await convertToModelMessages(messages),
  });

  return result.toUIMessageStreamResponse();
}
```

### Message Parts

Messages use a `parts` property that contains message parts (text, tool invocation, tool result):

```typescript
{messages.map((message) => (
  <div key={message.id}>
    {message.parts.map((part, index) => {
      if (part.type === 'text') {
        return <span key={index}>{part.text}</span>;
      }
      // Handle other part types
    })}
  </div>
))}
```

### Status States

```typescript
const { messages, sendMessage, status, stop } = useChat({
  transport: new DefaultChatTransport({
    api: '/api/chat',
  }),
});

// Status values:
// - 'submitted': Message sent, awaiting response start
// - 'streaming': Response actively streaming
// - 'ready': Full response received
// - 'error': Error occurred

{(status === 'submitted' || status === 'streaming') && (
  <div>
    {status === 'submitted' && <Spinner />}
    <button type="button" onClick={() => stop()}>
      Stop
    </button>
  </div>
)}
```

### Error Handling

```typescript
const { messages, sendMessage, error, reload } = useChat({
  transport: new DefaultChatTransport({
    api: '/api/chat',
  }),
});

{error && (
  <>
    <div>An error occurred.</div>
    <button type="button" onClick={() => reload()}>
      Retry
    </button>
  </>
)}
```

### Modify Messages

```typescript
const { messages, setMessages } = useChat();

const handleDelete = (id: string) => {
  setMessages(messages.filter((message) => message.id !== id));
};

{messages.map((message) => (
  <div key={message.id}>
    {/* message content */}
    <button onClick={() => handleDelete(message.id)}>Delete</button>
  </div>
))}
```

### Cancellation and Regeneration

```typescript
const { stop, status, regenerate } = useChat();

<button onClick={stop} disabled={!(status === 'streaming' || status === 'submitted')}>
  Stop
</button>

<button onClick={regenerate} disabled={!(status === 'ready' || status === 'error')}>
  Regenerate
</button>
```

### Event Callbacks

```typescript
import { UIMessage } from 'ai';

const { messages } = useChat({
  onFinish: ({ message, messages, isAbort, isDisconnect, isError }) => {
    // Use information to update other UI states
  },
  onError: (error) => {
    console.error('An error occurred:', error);
  },
  onData: (data) => {
    console.log('Received data part from server:', data);
  },
});
```

### Request Configuration

```typescript
import { useChat } from '@ai-sdk/react';
import { DefaultChatTransport } from 'ai';

const { messages, sendMessage } = useChat({
  transport: new DefaultChatTransport({
    api: '/api/custom-chat',
    headers: {
      Authorization: 'your_token',
    },
    body: {
      user_id: '123',
    },
  }),
});

// Dynamic configuration
const { messages: messages2 } = useChat({
  transport: new DefaultChatTransport({
    api: '/api/chat',
    headers: () => ({
      Authorization: `Bearer ${getAuthToken()}`,
      'X-User-ID': getCurrentUserId(),
    }),
    body: () => ({
      sessionId: getCurrentSessionId(),
      preferences: getUserPreferences(),
    }),
  }),
});

// Request-level configuration (recommended)
sendMessage(
  { text: input },
  {
    headers: {
      Authorization: 'Bearer token123',
      'X-Custom-Header': 'custom-value',
    },
    body: {
      temperature: 0.7,
      max_tokens: 100,
      user_id: '123',
    },
  },
);
```

---

## Building Chatbot Applications

### Full Chatbot Example with Status and Error Handling

```typescript
'use client';

import { useChat } from '@ai-sdk/react';
import { DefaultChatTransport } from 'ai';
import { useState } from 'react';

export default function Chat() {
  const { messages, sendMessage, error, reload, status, stop } = useChat({
    transport: new DefaultChatTransport({
      api: '/api/chat',
    }),
  });
  const [input, setInput] = useState('');

  return (
    <div className="flex flex-col w-full max-w-md py-24 mx-auto stretch">
      {messages.map((m) => (
        <div key={m.id} className="whitespace-pre-wrap">
          {m.role === 'user' ? 'User: ' : 'AI: '}
          {m.parts.map((part, i) =>
            part.type === 'text' ? <span key={i}>{part.text}</span> : null,
          )}
        </div>
      ))}

      {status === 'error' && (
        <div className="text-red-500">
          <p>An error occurred. Please try again.</p>
          <button onClick={() => reload()}>Retry</button>
        </div>
      )}

      {(status === 'submitted' || status === 'streaming') && (
        <div>
          <button onClick={() => stop()}>Stop</button>
        </div>
      )}

      <form
        onSubmit={(e) => {
          e.preventDefault();
          if (input.trim() && status === 'ready') {
            sendMessage({ text: input });
            setInput('');
          }
        }}
      >
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          disabled={status !== 'ready'}
          placeholder="Send message..."
          className="w-full p-2 border rounded"
        />
        <button type="submit" disabled={status !== 'ready'}>
          Send
        </button>
      </form>
    </div>
  );
}
```

### Message Metadata

Track token consumption and usage information:

```typescript
import { LanguageModelUsage, UIMessage, streamText, convertToModelMessages } from 'ai';

// Create custom metadata type
type MyMetadata = {
  totalUsage: LanguageModelUsage;
};

export type MyUIMessage = UIMessage<MyMetadata>;

// Server
export async function POST(req: Request) {
  const { messages }: { messages: MyUIMessage[] } = await req.json();

  const result = streamText({
    model: 'anthropic/claude-sonnet-4.5',
    messages: await convertToModelMessages(messages),
  });

  return result.toUIMessageStreamResponse({
    originalMessages: messages,
    messageMetadata: ({ part }) => {
      if (part.type === 'finish') {
        return { totalUsage: part.totalUsage };
      }
    },
  });
}

// Client
export default function Chat() {
  const { messages } = useChat<MyUIMessage>({
    transport: new DefaultChatTransport({
      api: '/api/chat',
    }),
  });

  return (
    <div>
      {messages.map((m) => (
        <div key={m.id}>
          {m.role === 'user' ? 'User: ' : 'AI: '}
          {m.parts.map((part) => {
            if (part.type === 'text') {
              return part.text;
            }
          })}
          {m.metadata?.totalUsage && (
            <div>Total usage: {m.metadata?.totalUsage.totalTokens} tokens</div>
          )}
        </div>
      ))}
    </div>
  );
}
```

---

## Tool Calling in UI

### Three Types of Tools in Chatbot

1. **Automatically executed server-side tools** - Execute on server, use `execute` method
2. **Automatically executed client-side tools** - Execute in browser, handle with `onToolCall`
3. **Tools requiring user interaction** - Confirmation dialogs, displayed in UI

### Tool Call Flow

1. User enters message
2. Message sent to API route
3. Language model generates tool calls during `streamText`
4. Tool calls forwarded to client
5. Server-side tools executed, results forwarded
6. Client-side tools handled with `onToolCall` callback
7. User-interaction tools displayed in UI
8. `addToolOutput` provides tool result
9. Chat configured to auto-submit when all results available

### Full Tool Usage Example

**Server:**

```typescript
import { convertToModelMessages, streamText, UIMessage } from 'ai';
import { z } from 'zod';

export const maxDuration = 30;

export async function POST(req: Request) {
  const { messages }: { messages: UIMessage[] } = await req.json();

  const result = streamText({
    model: 'anthropic/claude-sonnet-4.5',
    messages: await convertToModelMessages(messages),
    tools: {
      // Server-side tool with execute
      getWeatherInformation: {
        description: 'Show the weather in a given city to the user',
        inputSchema: z.object({ city: z.string() }),
        execute: async ({ city }: { city: string }) => {
          const weatherOptions = ['sunny', 'cloudy', 'rainy', 'snowy', 'windy'];
          return weatherOptions[Math.floor(Math.random() * weatherOptions.length)];
        },
      },
      // Client-side tool for user interaction
      askForConfirmation: {
        description: 'Ask the user for confirmation.',
        inputSchema: z.object({
          message: z.string().describe('The message to ask for confirmation.'),
        }),
      },
      // Automatically executed client-side tool
      getLocation: {
        description: 'Get the user\'s location',
        inputSchema: z.object({
          query: z.string(),
        }),
      },
    },
  });

  return result.toUIMessageStreamResponse();
}
```

**Client:**

```typescript
'use client';

import { useChat } from '@ai-sdk/react';
import { DefaultChatTransport, lastAssistantMessageIsCompleteWithToolCalls } from 'ai';
import { useState } from 'react';

export default function Chat() {
  const { messages, sendMessage, addToolOutput } = useChat({
    transport: new DefaultChatTransport({
      api: '/api/chat',
    }),

    sendAutomaticallyWhen: lastAssistantMessageIsCompleteWithToolCalls,

    // Run client-side tools automatically
    async onToolCall({ toolCall }) {
      // Always check if dynamic tool first
      if (toolCall.dynamic) {
        return;
      }

      if (toolCall.toolName === 'getLocation') {
        const cities = ['New York', 'Los Angeles', 'Chicago'];
        addToolOutput({
          tool: 'getLocation',
          toolCallId: toolCall.toolCallId,
          output: cities[Math.floor(Math.random() * cities.length)],
        });
      }
    },
  });
  const [input, setInput] = useState('');

  return (
    <>
      {messages?.map((message) => (
        <div key={message.id}>
          <strong>{`${message.role}: `}</strong>
          {message.parts.map((part) => {
            switch (part.type) {
              case 'text':
                return part.text;

              case 'tool-askForConfirmation': {
                const callId = part.toolCallId;
                switch (part.state) {
                  case 'input-available':
                    return (
                      <div key={callId}>
                        {part.input.message}
                        <button
                          onClick={() =>
                            addToolOutput({
                              tool: 'askForConfirmation',
                              toolCallId: callId,
                              output: 'Yes, confirmed.',
                            })
                          }
                        >
                          Yes
                        </button>
                        <button
                          onClick={() =>
                            addToolOutput({
                              tool: 'askForConfirmation',
                              toolCallId: callId,
                              output: 'No, denied',
                            })
                          }
                        >
                          No
                        </button>
                      </div>
                    );
                  case 'output-available':
                    return <div key={callId}>Result: {part.output}</div>;
                }
                break;
              }

              case 'tool-getWeatherInformation': {
                const callId = part.toolCallId;
                switch (part.state) {
                  case 'input-available':
                    return <div key={callId}>Getting weather for {part.input.city}...</div>;
                  case 'output-available':
                    return (
                      <div key={callId}>
                        Weather in {part.input.city}: {part.output}
                      </div>
                    );
                }
                break;
              }
            }
          })}
          <br />
        </div>
      ))}

      <form
        onSubmit={(e) => {
          e.preventDefault();
          if (input.trim()) {
            sendMessage({ text: input });
            setInput('');
          }
        }}
      >
        <input value={input} onChange={(e) => setInput(e.target.value)} />
      </form>
    </>
  );
}
```

### Tool Execution Approval

Require user confirmation before server-side tool runs:

**Server:**

```typescript
import { streamText, tool } from 'ai';
import { z } from 'zod';

export async function POST(req: Request) {
  const { messages } = await req.json();

  const result = streamText({
    model: 'anthropic/claude-sonnet-4.5',
    messages,
    tools: {
      getWeather: tool({
        description: 'Get the weather in a location',
        inputSchema: z.object({
          city: z.string(),
        }),
        needsApproval: true,
        execute: async ({ city }) => {
          const weather = await fetchWeather(city);
          return weather;
        },
      }),
    },
  });

  return result.toUIMessageStreamResponse();
}
```

**Client:**

```typescript
'use client';

import { useChat } from '@ai-sdk/react';

export default function Chat() {
  const { messages, addToolApprovalResponse } = useChat();

  return (
    <>
      {messages.map((message) => (
        <div key={message.id}>
          {message.parts.map((part) => {
            if (part.type === 'tool-getWeather') {
              switch (part.state) {
                case 'approval-requested':
                  return (
                    <div key={part.toolCallId}>
                      <p>Get weather for {part.input.city}?</p>
                      <button
                        onClick={() =>
                          addToolApprovalResponse({
                            id: part.approval.id,
                            approved: true,
                          })
                        }
                      >
                        Approve
                      </button>
                      <button
                        onClick={() =>
                          addToolApprovalResponse({
                            id: part.approval.id,
                            approved: false,
                          })
                        }
                      >
                        Deny
                      </button>
                    </div>
                  );
                case 'output-available':
                  return (
                    <div key={part.toolCallId}>
                      Weather in {part.input.city}: {part.output}
                    </div>
                  );
              }
            }
          })}
        </div>
      ))}
    </>
  );
}
```

---

## Generative User Interfaces

Generative UI allows LLMs to generate UI components, not just text.

### Core Concept

1. You provide model with tools
2. Model decides when/how to use tools based on context
3. Tool executes and returns data
4. Data passed to React component for rendering

### Basic Generative UI Example

**Tools:**

```typescript
import { tool as createTool } from 'ai';
import { z } from 'zod';

export const weatherTool = createTool({
  description: 'Display the weather for a location',
  inputSchema: z.object({
    location: z.string().describe('The location'),
  }),
  execute: async function ({ location }) {
    await new Promise((resolve) => setTimeout(resolve, 2000));
    return { weather: 'Sunny', temperature: 75, location };
  },
});

export const tools = {
  displayWeather: weatherTool,
};
```

**UI Component:**

```typescript
type WeatherProps = {
  temperature: number;
  weather: string;
  location: string;
};

export const Weather = ({ temperature, weather, location }: WeatherProps) => {
  return (
    <div>
      <h2>Current Weather for {location}</h2>
      <p>Condition: {weather}</p>
      <p>Temperature: {temperature}°C</p>
    </div>
  );
};
```

**Chatbot:**

```typescript
'use client';

import { useChat } from '@ai-sdk/react';
import { useState } from 'react';
import { Weather } from '@/components/weather';

export default function Page() {
  const [input, setInput] = useState('');
  const { messages, sendMessage } = useChat();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    sendMessage({ text: input });
    setInput('');
  };

  return (
    <div>
      {messages.map((message) => (
        <div key={message.id}>
          <div>{message.role === 'user' ? 'User: ' : 'AI: '}</div>
          <div>
            {message.parts.map((part, index) => {
              if (part.type === 'text') {
                return <span key={index}>{part.text}</span>;
              }

              if (part.type === 'tool-displayWeather') {
                switch (part.state) {
                  case 'input-available':
                    return <div key={index}>Loading weather...</div>;
                  case 'output-available':
                    return (
                      <div key={index}>
                        <Weather {...part.output} />
                      </div>
                    );
                  case 'output-error':
                    return <div key={index}>Error: {part.errorText}</div>;
                }
              }

              return null;
            })}
          </div>
        </div>
      ))}

      <form onSubmit={handleSubmit}>
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Type a message..."
        />
        <button type="submit">Send</button>
      </form>
    </div>
  );
}
```

**Server:**

```typescript
import { streamText, convertToModelMessages, UIMessage, stepCountIs } from 'ai';
import { tools } from '@/ai/tools';

export async function POST(request: Request) {
  const { messages }: { messages: UIMessage[] } = await request.json();

  const result = streamText({
    model: 'anthropic/claude-sonnet-4.5',
    system: 'You are a friendly assistant!',
    messages: await convertToModelMessages(messages),
    stopWhen: stepCountIs(5),
    tools,
  });

  return result.toUIMessageStreamResponse();
}
```

### Adding Multiple Tools

```typescript
// Define more tools
export const stockTool = createTool({
  description: 'Get price for a stock',
  inputSchema: z.object({
    symbol: z.string(),
  }),
  execute: async ({ symbol }) => {
    await new Promise((resolve) => setTimeout(resolve, 2000));
    return { symbol, price: 150 };
  },
});

export const tools = {
  displayWeather: weatherTool,
  getStockPrice: stockTool,
};
```

Then render multiple components based on tool types:

```typescript
{message.parts.map((part, index) => {
  if (part.type === 'tool-displayWeather') {
    return <Weather {...part.output} />;
  }
  if (part.type === 'tool-getStockPrice') {
    return <Stock {...part.output} />;
  }
})}
```

---

## Advanced Patterns

### Type Safety for Tools

```typescript
import { InferUITool, InferUITools, UIMessage, UIDataTypes } from 'ai';

// Infer single tool type
type WeatherUITool = InferUITool<typeof weatherTool>;
// { input: { location: string }; output: string }

// Infer tool set types
type MyUITools = InferUITools<typeof tools>;

// Use in custom message type
type MyUIMessage = UIMessage<never, UIDataTypes, MyUITools>;

// Pass to useChat
const { messages } = useChat<MyUIMessage>();
```

### Reasoning and Sources

Some models support reasoning tokens and sources:

**Server:**

```typescript
export async function POST(req: Request) {
  const { messages }: { messages: UIMessage[] } = await req.json();

  const result = streamText({
    model: 'deepseek/deepseek-r1',
    messages: await convertToModelMessages(messages),
  });

  return result.toUIMessageStreamResponse({
    sendReasoning: true, // Include reasoning tokens
    sendSources: true,   // Include sources
  });
}
```

**Client:**

```typescript
{message.parts.map((part, index) => {
  if (part.type === 'text') {
    return <div key={index}>{part.text}</div>;
  }

  if (part.type === 'reasoning') {
    return <pre key={index}>{part.text}</pre>;
  }

  if (part.type === 'source-url') {
    return (
      <a key={`source-${part.id}`} href={part.url} target="_blank">
        {part.title ?? new URL(part.url).hostname}
      </a>
    );
  }

  if (part.type === 'source-document') {
    return <span key={`source-${part.id}`}>{part.title ?? `Document`}</span>;
  }
})}
```

### File Attachments

```typescript
'use client';

import { useChat } from '@ai-sdk/react';
import { useRef, useState } from 'react';

export default function Page() {
  const { messages, sendMessage, status } = useChat();
  const [input, setInput] = useState('');
  const [files, setFiles] = useState<FileList | undefined>();
  const fileInputRef = useRef<HTMLInputElement>(null);

  return (
    <div>
      {messages.map((message) => (
        <div key={message.id}>
          {message.parts.map((part, index) => {
            if (part.type === 'text') {
              return <span key={index}>{part.text}</span>;
            }

            if (part.type === 'file' && part.mediaType?.startsWith('image/')) {
              return <img key={index} src={part.url} alt={part.filename} />;
            }

            return null;
          })}
        </div>
      ))}

      <form
        onSubmit={(event) => {
          event.preventDefault();
          if (input.trim()) {
            sendMessage({
              text: input,
              files,
            });
            setInput('');
            setFiles(undefined);
            if (fileInputRef.current) {
              fileInputRef.current.value = '';
            }
          }
        }}
      >
        <input
          type="file"
          onChange={(event) => {
            if (event.target.files) {
              setFiles(event.target.files);
            }
          }}
          multiple
          ref={fileInputRef}
        />
        <input
          value={input}
          placeholder="Send message..."
          onChange={(e) => setInput(e.target.value)}
          disabled={status !== 'ready'}
        />
      </form>
    </div>
  );
}
```

---

## Best Practices

### Agents

1. **Start with ToolLoopAgent** - Use for most cases; only use core functions when you need explicit control
2. **Clear system instructions** - Define agent's role, expertise, and constraints clearly
3. **Appropriate tool choice** - Use `'required'` when tools must be used, `'auto'` for flexibility
4. **Set reasonable step limits** - Balance thorough execution with resource consumption
5. **Tool descriptions matter** - Provide clear, specific descriptions so model uses tools correctly

### Workflows

1. **Choose appropriate pattern** - Use simplest pattern that meets requirements
2. **Plan before implementation** - Break down complex tasks into clear steps
3. **Add error handling** - Gracefully handle tool failures and edge cases
4. **Monitor costs** - Complex workflows mean more LLM calls
5. **Test extensively** - Non-deterministic nature requires thorough testing

### Chat UI

1. **Handle all status states** - Show spinners, error states, and stop buttons
2. **Use typed message parts** - Leverage `tool-${toolName}` typed parts for type safety
3. **Display tool execution** - Show loading states and results to users
4. **Manage history** - Consider message persistence for long conversations
5. **Implement retry logic** - Provide easy way to retry failed requests

### Generative UI

1. **Separate concerns** - Keep tools, components, and chat logic separate
2. **Type tool outputs** - Ensure component props match tool output schema
3. **Handle loading states** - Show `input-streaming` and `input-available` states
4. **Error boundaries** - Handle tool execution errors gracefully
5. **Progressive enhancement** - Start simple, add complexity incrementally

### General

1. **Use pnpm** - Default package manager for all AI SDK projects
2. **Pin versions** - AI SDK 6 is beta; consider pinning versions for stability
3. **Test edge cases** - Test with various inputs, tool combinations, error scenarios
4. **Monitor performance** - Track token usage, execution time, and error rates
5. **Iterate on prompts** - System instructions have significant impact on results

---

## Framework Support

**AI SDK UI supports:**
- React (@ai-sdk/react) - Full support: useChat, useCompletion, useObject
- Vue.js (@ai-sdk/vue) - useChat, useCompletion, useObject
- Svelte (@ai-sdk/svelte) - useChat, useCompletion, useObject
- Angular (@ai-sdk/angular) - useChat, useCompletion, useObject
- SolidJS (community) - Contributions welcome

---

## Resources

- [AI SDK 6 Docs](https://v6.ai-sdk.dev/docs)
- [Cookbook Examples](https://v6.ai-sdk.dev/cookbook)
- [Showcase](https://v6.ai-sdk.dev/showcase)
- [GitHub](https://github.com/vercel/ai)
- [Discussions](https://github.com/vercel/ai/discussions)
- [Playground](https://v6.ai-sdk.dev/playground)
