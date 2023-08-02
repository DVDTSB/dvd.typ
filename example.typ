#import "dvd.typ": *

#show: project.with(
  title: "dvd's typst template",
  subtitle: "a kinda cool typst template",
  author: "dvdtsb"
)

#outline("Contents")

= Primes

== Introduction

Primes, prime factorization, and greatest common divisor are fundamental concepts in number theory and play a crucial role in various mathematical and computational applications. In this document, we will explore these concepts and their properties through various theorems and examples. Let's dive into the world of numbers and uncover some intriguing patterns and relationships!

== Getting Mathy
#theorem(name:[Euler's primes])[
  Primes are positive integers greater than $1$ that have no divisors other than $1$ and themselves.
]

#lemma(name:[Prime Factorization])[
  Prime factorization is the process of representing a composite number as a product of its prime factors.
]

#corollary(name:[Fundamental Theorem of Arithmetic])[
  The Fundamental Theorem of Arithmetic states that every positive integer greater than 1 can be expressed as a unique product of prime numbers.
]

#problem(name:[Prime Factorization of $84$])[
  Find the prime factorization of the number $84$.
]

#example(name:[Prime Factorization Example])[
  Let's find the prime factorization of the number $84$ step by step.
  $84$ can be divided by $2$ to get $42$.
  $42$ can be divided by $2$ to get $21$.
  $21$ can be divided by $3$ to get $7$.
  $7$ is a prime number.
  Therefore, the prime factorization of 84 is $2 dot 2 dot 3 dot 7$.
]

#definition(name:[Greatest Common Divisor (GCD)])[
  The greatest common divisor (GCD) of two or more integers is the largest positive integer that divides each of them without any remainder.
]

#observation(name:[GCD Terminology])[
  The GCD is also known as the greatest common factor (GCF) or highest common divisor (HCD).
]

#hint(name:[Finding GCD])[
  To find the GCD of two numbers, find their prime factorizations and identify the common prime factors.
]

#claim(name:[GCD of $36$ and $48$])[
  The GCD of $36$ and 48 is $12$.
]

#proof(name:[Proof of GCD Claim])[
  Let's prove the claim by finding the prime factorizations of $36$ and $48$.
  Prime factorization of $36$: $2 dot 2 dot 3 dot 3$
  Prime factorization of $48$: $2 dot 2 dot 2 dot 2 dot 3$
  The common prime factors are $2$ and $3$.
  Therefore, the GCD of $36$ and $48$ is $2 dot 2 dot 3 = 12$.
]

