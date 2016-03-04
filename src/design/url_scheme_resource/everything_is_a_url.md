"Everything is an URL"
======================

"Everything is an URL" is an important principle in the design of Redox. Roughly, it means that the API, design, and ecosystem is centered around URLs, schemes, and resources as the main communication primitive. In other words, applications communicate with each other, the system, daemons, and so on, using URLs. As such, programs do not have to create their own constructions for communicating.

By unifying the API in this way, you get an extremely consistent, clean, and flexible interface.

We can't really claim credits of this concept (except for the implementation and exact design). The idea is not a new one: The concept is very similar to _9P_ from _Plan 9_ by Bell Labs.

How it differs from "everything is a file"
------------------------------------------

> TODO
