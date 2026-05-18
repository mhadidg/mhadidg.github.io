---
title: "Averages lies"
date: "2026-05-10"
summary: "Averages lies, most often than not"
description: "Averages lies, most often than not"
toc: false
readTime: false
autonumber: false
math: true
tags: [ ]
showTags: false
hideBackToTop: true
hidePagination: true
---

Suppose you run an A/B test on a signup page. Your baseline conversion is 3%. Now you want to ship a new version, but
you're not certain it would be better, so you opt for an A/B experiment to decide. After running the experiment, you've
got the numbers:

- Baseline average is 3.0%
- New version average is 3.5%

Which one is better? If you feel like you have enough data to decide already. You're absolutely wrong. Let me explain.

Let say there are two realities of this experiment: two companies with the exact same experiment and result, but
different number of customers. The first got 100 customers and the other had 1000 customers.

Now, in which reality the chances that the new version is better than the baseline is higher? The answer is the
1000-customer reality. And the reason why is the whole point of this post.

Let's start with the intuition. Imagine you flip a coin 4 times and get 3 heads — 75%. Now imagine you flip the same
coin 4000 times and get 3000 heads — also 75%. Same rate. But in the first case you'd shrug: 3 out of 4 heads happens
all the time with a fair coin. In the second case you'd bet your house the coin is biased. The rate alone tells you
nothing. The rate plus the sample size tells you whether the rate is signal or noise.

Same thing here. To turn that intuition into a number, we need to talk about a few concepts. I'll introduce each one
right before we use it, so the math never gets ahead of the meaning.

## Reality #1: 100 customers per group

**Concept: standard error.** Your conversion rate of 3% is a *sample* statistic — you computed it from the 100 people
you happened to observe. If you ran the same experiment again on a different 100 people, you'd get a slightly different
number: maybe 2%, maybe 4%. The standard error (SE) is a measure of how much that number would jiggle around from sample
to sample. It's the "typical distance" between your observed rate and the true underlying rate.

Don't confuse it with standard deviation. Standard deviation describes how spread out the *individuals* are. Standard
error describes how spread out the *summary statistic* is across hypothetical re-runs of the experiment. They're related
but they answer different questions. SD says "how varied are people?" SE says "how much should I trust this average?"

For a conversion rate (a proportion), the standard error has a tidy closed form:

$$\text{SE}(p) = \sqrt{\frac{p(1-p)}{n}}$$

That formula falls out of the fact that each user is a Bernoulli trial — they either converted or they didn't — and the
variance of a Bernoulli is $p(1-p)$. Average $n$ of them together and you divide by $n$, then take the square root to
get back to the units of the original measurement.

Plugging in:

- Control SE: $\sqrt{0.03 \cdot 0.97 / 100} \approx 1.71$ pp
- Treatment SE: $\sqrt{0.035 \cdot 0.965 / 100} \approx 1.84$ pp

So your control's "true" conversion rate could very plausibly be anywhere within ~1.7 percentage points of 3%, and
similarly for the treatment. With observed rates only 0.5 pp apart, those uncertainty clouds overlap heavily — and
that's the problem.

**Concept: standard error of the difference.** What we actually care about isn't the SE of either rate on its own; it's
the SE of the *gap* between them. Because both rates have their own noise, and we're subtracting them, the noise
compounds.

For two *independent* samples (which A/B groups are, by construction of the randomization), variances add. Always. So
when you subtract two random quantities, their variances still add — subtracting doesn't cancel noise, it accumulates
it. Taking the square root to get back to a standard error:

$$\text{SE}(\text{diff}) = \sqrt{\text{SE}_C^2 + \text{SE}_T^2} \approx \sqrt{1.71^2 + 1.84^2} \approx 2.51 \text{ pp}$$

So the gap between the two arms — which you observed as 0.5 pp — has a typical wobble of about 2.5 pp around its true
value. The signal is much smaller than the noise.

**Concept: confidence interval.** A 95% confidence interval is a range constructed such that, if you ran this entire
experiment many times, about 95% of the intervals you'd construct would contain the true effect. Loosely (and slightly
wrong, but useful as a mental model): it's the range of true effects that are *compatible* with what you observed.

For an approximately normal estimate, the 95% CI is the point estimate $\pm 1.96$ standard errors. The 1.96 comes from
the normal distribution: 95% of the mass lies within 1.96 SDs of the mean. People often round to 2.

$$\text{CI}_{95\%} = 0.5 \pm 1.96 \cdot 2.51 \text{ pp} \approx [-4.4 \text{ pp},\ +5.4 \text{ pp}]$$

Read that interval slowly. It contains a four-point regression. It contains a five-point lift. Your "experiment" is
consistent with the new version being a catastrophe and consistent with it being a massive win, and you cannot
distinguish between those two stories using this data.

**Concept: the Bayesian version.** The CI tells you which true effects are compatible with the data, but it doesn't
directly answer the question on everyone's mind: *"given what I saw, what's the probability the new version is actually
better?"* That question is technically Bayesian — it's asking about a probability over the unknown true effect, not over
hypothetical re-runs of the experiment.

The frequentist's CI and the Bayesian's "probability of improvement" are different objects, but when you put a flat (
uninformative) prior on the effect, they line up neatly. The probability that the true difference is greater than zero
is just the probability that a normal distribution centered at your observed difference, with width equal to the SE,
exceeds zero:

$$P(\text{true diff} > 0) \approx \Phi\!\left(\frac{\text{observed diff}}{\text{SE}(\text{diff})}\right) = \Phi(0.5 / 2.51) \approx 58\%$$

where $\Phi$ is the standard normal CDF — i.e., "what fraction of a bell curve lies below this z-score." A z-score of
0.2 puts you only barely past the midpoint.

You ran the experiment, looked at the results, and now you're 58% sure. That is a coin flip with a small nudge. You
would do roughly as well by skipping the experiment entirely and shipping based on whichever variant the PM liked
better.

## Reality #2: 1000 customers per group

Same math, ten times the sample. Now I can just turn the crank because we've already established what every term means:

- Control SE: $\sqrt{0.03 \cdot 0.97 / 1000} \approx 0.54$ pp
- Treatment SE: $\sqrt{0.035 \cdot 0.965 / 1000} \approx 0.58$ pp
- SE of the difference: $\sqrt{0.54^2 + 0.58^2} \approx 0.79$ pp
- 95% CI: $0.5 \pm 1.96 \cdot 0.79 \approx [-1.05 \text{ pp},\ +2.05 \text{ pp}]$
- $P(\text{new is actually better}) \approx \Phi(0.5 / 0.79) \approx 74\%$

Better. The interval is much tighter. The probability is meaningfully above 50%. But — and this is the part most teams
miss — the CI still comfortably contains zero. If you ship the new version on the strength of these numbers, you're
committing to a decision you'd lose about 1 time in 4. For most product changes, that's not the bar you want.

**Concept: why SE shrinks like $\sqrt{n}$ and not $n$.** Look back at the SE formula: $\sqrt{p(1-p)/n}$. The $n$ is
under a square root. That means going from 100 to 1000 customers (10x the data) only shrank the standard error by a
factor of $\sqrt{10} \approx 3.16$. To halve your uncertainty you need 4x the users. To cut it by 10x you need 100x.

Why $\sqrt{n}$? Intuitively: noise partially cancels out as you add more independent observations, but it doesn't cancel
perfectly. Some samples are too high, some too low, and on net they offset — but only to the degree that the noise is
independent. The math of "independent errors partially cancelling" gives you exactly the $\sqrt{n}$ shrinkage. It's one
of the most important relationships in applied statistics, and it's the brutal economics of experimentation: "let's just
collect a bit more data" is often a much bigger ask than it sounds.

## The magic number

**Concept: minimum detectable effect (MDE).** The MDE is the smallest true effect that your experiment, given its sample
size, could *reliably* detect. Run an experiment whose MDE is bigger than the effect you'd plausibly care about, and
you've built a metal detector that only beeps for buried cars: it won't find the coins you were actually looking for.

The standard formulation flips the CI construction around. We want our 95% CI to *exclude zero*, which requires the
observed effect to be at least $1.96$ standard errors away from zero. Setting that as our threshold and solving for $n$:

$$n \approx \frac{2 \cdot p(1-p) \cdot 1.96^2}{\text{MDE}^2}$$

For a 0.5 pp lift on a 3% baseline:

$$n \approx \frac{2 \cdot 0.0325 \cdot 0.9675 \cdot 3.84}{(0.005)^2} \approx 9{,}650 \text{ per arm}$$

About **10,000 per arm**. So:

- 100 customers per arm: ~100x too small. Result is noise.
- 1000 customers per arm: ~10x too small. Result is suggestive but not decisive.
- 10,000 customers per arm: now we're talking.

If you also want decent statistical *power* — the ability to reliably detect the effect when it's there, not just rule
out zero on a single readout — bump that to ~16,000 per arm. (The 1.96 in the formula gets replaced by roughly 2.8,
which accounts for both the false-positive threshold and the false-negative one.) And that's for a single test, on a
single metric, with no peeking, no segmentation, no multiple-comparisons correction. Add any of those and the number
climbs further.

## Why this matters more than it sounds

The point estimates didn't change between the two realities. Same 3.0% and 3.5%, same 0.5 pp lift, same "the new version
looks better." What changed was how much we should *believe* the lift, and that depends entirely on sample size — a
number that is completely invisible if you only look at the conversion rates on a dashboard.

This is the silent killer of A/B testing programs. The team runs a "quick test" on a few hundred users. The new variant
comes out 0.5 points ahead. Someone says "looks good, let's ship it." They did not run a test. They drew a sample so
small that random noise dominates any realistic effect, looked at which direction the noise happened to point, and
shipped that direction. Maybe half the time the noise was pointing the right way; the other half they just shipped the
worse variant and never found out.

The rule that falls out of this: before you read out *any* experiment, compute the minimum detectable effect for the
sample size you actually have. If the MDE is larger than the effect you would plausibly care about, the experiment
cannot answer your question — no matter what number it produces. At that point your honest options are to get more data,
find a way to reduce variance (CUPED, better metrics, stratification), or accept that this decision has to be made on
judgment rather than evidence. What you can't do is pretend the underpowered readout is a signal. That's how worse
variants ship.
