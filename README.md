# Lewis & Short (Julia)

![version 1.0.0](https://img.shields.io/badge/Lewis & Short (Julia)-1.0.0-orange) ![Julia 1.7.3](https://img.shields.io/badge/Julia-1.7.3-green)

This is an implementation of a web-application for consulting [*A Latin Dictionary.* Founded on Andrews’ edition of Freund's Latin dictionary, revised, enlarged, and in great part rewritten by Charlton T. Lewis, Ph.D., and Charles Short, LL.D. (Oxford: Clarendon Press, 1879).](https://en.wikipedia.org/wiki/A_Latin_Dictionary). It is written in [Julia](https://julialang.org) with the [Dash framework](https://dash.plotly.com/julia/introduction). It is the successor to an [earlier version](http://folio2.furman.edu/lewis-short/index.html), written in [ScalaJS](https://www.scala-js.org) (See, [this blog post about that earlier version, and the data behind it](https://eumaeus.github.io/2018/10/30/lsj.html))

## Why Rewrite a Working App in Julia?

1. I needed to get good at Julia and Dash.
2. The ScalaJS version, to achieve sufficient performance, requires a back-end microservice to do the heavy lifting of querying, mapping, and filtering the 51,600 entries in the lexicon. So the app was "online only", and requires some ongoing babysitting to keep running. This implementation in Julia can run entirely offline\*.
3. The Dash framework imposes a number of restrictions on how components of a web-app, and data, interact. These restrictions require some thought, but results in a simpler, more stable, and more maintainable architecture. The Scala version (the *Lewis & Short* app and necessary microservice) required about 4,500 lines of code. This implementation required only 800.

\* In "entirely offline mode", the app will not be able to download the EB Garamond font from Google, so the text will not be as attractive as it might be.

## Running *LSJ* on Your Machine

1. Download [Julia](https://julialang.org/downloads/) and do whatever it takes to install it.
2. Clone this repository.
3. In a terminal, `cd` into `LSJ.jl`, *e.g.* `cd ~/Desktop/LSJ.jl`, if you cloned the repository onto your Desktop.
4. In the terminal: `julia dashboard/lewisshort.jl`.
5. When it is up and running (the initial load may take a while, as it downloads and compiles necessary libraries), visit `http://localhost:8054/` in your browser.

## Bugs or Errors in Data

You can report bugs in the program, or errors in data, by [submitting an Issue on GitHub](https://github.com/Eumaeus/LSJ.jl/issues).


