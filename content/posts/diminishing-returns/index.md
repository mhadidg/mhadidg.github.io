---
title: "Diminishing returns"
date: "2025-02-15"
summary: "When over-optimization becomes counterproductive"
description: "When over-optimization becomes counterproductive"
toc: false
readTime: false
autonumber: true
math: true
tags: [ ]
showTags: false
hideBackToTop: true
hidePagination: true
---

I used to believe that the more we optimize, the better. Add more tests. More linting rules. More metrics. Better code,
better outcomes. Makes intuitive sense, right?

Things usually start well. You introduce TypeScript. Prettier. A good CI pipeline. You aim for 80% test coverage. You
refactor some parts of the codebase that clearly need cleanup. Things are getting better. Fewer bugs. Less anxiety
during deployments.

More is better. Let's do another round...

95% test coverage. More complex linting configs. Harsh thresholds on [cyclomatic complexity]. Refactors that touch
working code just to align it stylistically.

At some point, the returns start diminishing. Of course, the codebase looks "better," but PRs are taking longer. The
test suite is slower. Engineers start writing tests to satisfy coverage, not to prevent bugs. Metrics are good, progress
is not.

Well-known phenomenon, *The Law of Diminishing Returns*, where extra units of effort yield less and less benefit.
Sometimes even net negative. The cost, [cognitive] or otherwise, starts outweighing the gain.

Most engineers would probably agree on this, but we fail to apply it all the time. It’s inherently hard. Sometimes we
obsessively optimize for performance, quality, or elegance. But rarely question: *“Are we optimizing past the point of
usefulness here?”*

Engineers love elegance (let's hope so), but we sometimes confuse elegance with excess polish. Just because a function
is a bit messy doesn’t mean it’s worth a refactor. Just because a test is missing doesn’t mean it’s risky. If it’s been
working nicely for a while, if it’s stable, and if changing it costs more than it returns, it’s probably fine.

That doesn’t mean we should sacrifice quality in favor of progress, but be more careful to see where it truly matters.
That comes down to realizing where fixing something is actually worth the effort. And where it doesn’t.

[cyclomatic complexity]: https://www.sonarsource.com/learn/cyclomatic-complexity

[cognitive]: https://github.com/zakirullin/cognitive-load
