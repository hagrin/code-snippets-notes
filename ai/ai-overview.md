# AI / SI Random Overiew & Thoughts

Just a collection of thoughts and asking myself questions trying to hash out a short / medium / long term plan for AI / SI implementation.

## Overall Climate and Forecasting
### Chinese Open Source Models

This is a very complicated topic that requires looking at the issue from many different angles. Some of those angles include (but are not exclusive to) - 
* Qwen Escaping Sandbox - https://cohere.com/blog/concerning-behaviour-popular-open-weight-ai-model - additional work on this was done by Warren Togami here https://x.com/wtogami/status/2114923198475288751 . Some concerning results where English queries escaped some non-zero amount of the time
* US / Western frontier labs possibly protecting their valuations by asking the US government to ban or restrict these models / imports
* US Government wanting to ban / restrict Chinese / foreign models on their own - https://www.federalregister.gov/public-inspection/2026-21447/order-exclusion-and-removal-of-deepseek-products-from-federal-civilian-executive-branch-information
* China possibly restricting or banning the export of certain models that perform certain functions - this is rumored to possibly be in the works by the Chinese government to protect AI tooling that writes malware, tools built for defending critical infrastructure, Chinese core data (Source - https://www.mofcom.gov.cn/zwgk/zcfb/art/2026/art_0a31a3c9ac404f7a9b0e917ce3412997.html ). 

## Corporate 

Protecting IP / Sensitive Business Practices with Lower Cost Locally Tuned Models - https://x.com/brian_armstrong/status/2109412046244913643 - Coinbase 

NDAs With AI Sections on Deal Evaluation - https://x.com/BillDA/status/2110509457272979895 - contractual attempt at preventing the training on CIMs (Confidential Information Memorandums)<br />

Blocking AI Agents - https://x.com/trikcode/status/2111622265284546620 - Delta, JPM Chase, Yelp, Amazon all have started some amount of AI agent blocking for a variety of reasons from the costs to serving these bots, preventing unfair consumer habits, security, etc.

## Economics

Corporate Token Spend - https://ramp.com/data/ai-index-oct-2026 - Ramp AI Index, median firm spending ~$16/employee as per September 2026

Accenture Limiting Some Employee Token Spend - https://www.404media.co/accenture-tells-employees-they-can-now-spend-only-29-on-claude-per-month/ - sensationalized headline, but Accenture forcing some employees not on premium plans to far lower token spend budgets if they can't directly bill the token usage to a project

## Attack Vectors

AI Agents Summarizing Your Inbox - https://blog.barracuda.com/2026/08/04/ai-enabled-email-accounts-insider-threat and https://blog.barracuda.com/2026/10/07/email-attacks-target-both-humans-ai-assistants - the second link specifically where email AI agents are subjected to malicious prompts not viewable to the human. Very obvious security risk.

Purchasing Router Datasets - https://x.com/shoucccc/status/2098169782541631871 - Builds off this paper https://arxiv.org/abs/2604.08407 ("Your Agent Is Mine: Measuring Malicious Intermediary Attacks on the LLM Supply Chain". Data sent through routers by AI users harvested, sold and not sanitized / enforce cryptographic integrity / etc.
