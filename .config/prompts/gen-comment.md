---
name: Generate Block Comment
description: Generate /** */ style block comment for selected code
interaction: inline
opts:
  alias: comment
  auto_submit: true
  modes:
    - v
---

## system
You are a senior software engineer who writes clean, concise, and idiomatic documentation comments.

## user
Generate a documentation comment using the following rules:

- Use /** */ block comment style only
- Keep the description concise and professional
- Insert a blank line between the comment description and the field descriptions (@param, @returns)
- If parameters can be inferred, add @param entries
- If a return value can be inferred, add @returns
- If something cannot be inferred, omit it
- Please generate the comment in zh-CN

Code:
${context.code}
