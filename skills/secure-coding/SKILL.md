---
name: secure-coding
description: Use when the user wants code reviewed for security before it ships — e.g. "is this secure", "review my auth", "could one user read another user's data", "check this API route / migration / access policy". Reviews authorization and data-exposure defects in the actual code, not a generic vulnerability checklist.
---

# Secure Coding

## Overview

Review a specific change — or a named area of a codebase — for the defects
that let one user read or write what belongs to another, and report what is
exploitable today versus what is worth hardening.

Most damage in a product like the ones this repo helps plan does not come
from injection or scripting attacks. It comes from **authorization bugs that
pass every test**, because the obvious check succeeds while the data leaks by
another route. The work is finding the other route, in this codebase — not
reciting a generic vulnerability list.

**Announce at start:** "I'm using the secure-coding skill to review this code for authorization and data-exposure defects."

## Process Flow

1. **Scope the review.** Ask what to review: a specific change, a feature
   area, or the whole data-access layer. Also ask what the sensitive data
   actually is — which records would be damaging for the wrong person to read
   or modify. Ask about reading separately from writing: who is allowed to
   *know* a thing is often the product itself, and confidentiality failures
   are silent, because nobody files a ticket saying they saw data they
   shouldn't have. Without that answer everything looks equally important and
   the review degrades into a checklist.
2. **Clarifying questions.** Ask one at a time. What distinct roles or
   tenants exist? Is there a privileged path (admin console, background job,
   support tool)? Is this pre-launch, or live with real user data? Any area
   already known to be weak?
3. **Map the trust boundary.** From the code, list every entry point an
   attacker can reach while ignoring the UI entirely — public routes, remote
   procedure endpoints, direct database access from a client. A check
   performed by the *caller* of an endpoint protects nothing; only checks
   inside the endpoint count.
4. **Find what runs privileged.** Service credentials, elevated database
   roles, functions executing with their definer's rights, internal jobs.
   Each one bypasses the policy layer wholesale, so each is its own trust
   boundary and must re-implement every check it skips.
5. **Test each authorization rule against its own premise.** List the fields
   and claims the rule reads, then ask of each: can the subject being checked
   write this value, directly or indirectly? A rule whose premise its own
   subject controls enforces nothing — and the resulting read is *legitimate*,
   so nothing logs and nothing alerts.
6. **Run the code through the bypass taxonomy.** Don't verify the happy path;
   it always passes. Try each of these:
   - **Direct read** of another subject's record.
   - **Enumeration** — drop the filter entirely, request the collection.
   - **Read through a relation** — the parent is permitted, so pull the
     protected child through it (nested selects, ORM includes, joins, nested
     API fields). Rules on the child are frequently not evaluated the way the
     author assumed.
   - **Rewrite the premise** — change the field a rule depends on, read
     legitimately, change it back. Ask whether that leaves any trace.
   - **Flip the gate** — if a state value unlocks visibility, can the subject
     set that state? Two writes and a read.
   - **Self-grant** — is a privilege field writable by the account that holds
     it? Any endpoint accepting a whole object turns into this.
   - **Ownership on write** — update and delete paths are routinely guarded
     by "the record exists", never by "and it belongs to you".
   - **Tamper with the record of what happened** — can audit or history rows
     be edited or deleted, by anyone, including privileged paths?
7. **Check the silent-failure modes.** A wrong rule usually returns zero rows
   rather than an error, which reads as "security is working" in every manual
   test. Verify the *allow* direction as explicitly as the deny direction — a
   completely broken rule passes every deny-only test. Flag rules that depend
   on a record which may not exist yet; those deny quietly and look correct.
8. **Check secrets and public surfaces.** What makes a value public is how
   the build pipeline treats it, not which file holds it — a value carrying a
   build-time public prefix ships to every client no matter how it is stored.
   Confirm no privileged credential wears one, that none are logged, and that
   server-only modules are unreachable from client code.
9. **Before proposing any new control, find the existing one.** The default
   failure of a security review is that it ends in new mechanism. New
   mechanism is itself attack surface, and a control duplicating one already
   in place is worse than nothing — two places now encode the same rule, and
   they will drift apart. For each gap, trace what the system already does
   with that request and show whether it is genuinely unmet. "This needs no
   change, and here is the line that already enforces it" is a complete
   finding, not a failure to deliver. Only once a gap is shown to be real,
   recommend the smallest thing that closes it, naming which existing
   mechanism was checked and why it falls short.
10. **Rank the findings.** Two groups, in this order: **exploitable now**,
    and **hardening**. For each exploitable finding give the file and line,
    the concrete sequence of requests that exploits it, and the smallest fix
    that closes it. Don't pad the first group to look productive.
11. **Write the doc** to
    `docs/security/YYYY-MM-DD-<scope-slug>-security-review.md` in the user's
    project (create `docs/security/` if it doesn't exist).
12. **Self-review.** Check that every finding traces to code actually read,
    and that every exploit sequence is one you could walk through step by
    step. If nothing was found, say which taxonomy items were actually tried
    and what was left unexplored — never declare the code secure.
13. **User review gate.** Point the user to the file and ask them to review
    before treating it as final. This skill reports findings; it does not
    apply fixes unless the user asks for them separately.

## Output Template

```markdown
# <Scope> — Security Review

> Generated by the secure-coding skill on <date>. Review and edit before treating this as final.

## 1. Scope Reviewed
## 2. Trust Boundaries & Privileged Paths
## 3. Exploitable Findings (ranked)
## 4. Already Enforced — No Change Needed
## 5. Hardening Opportunities
## 6. Silent-Failure Risks
## 7. Not Reviewed / Low Confidence
```
