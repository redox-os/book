Why MIT?
=======

As licensing is rather controversial, this is a frequently asked question.

The GPL is good for forcing people who make changes to the source to contribute back. GPL stipulates that source code that is modified, compiled, and then distributed must be published under the GPL license. This prevents a company like Google, for example, from keeping most modifications to the Linux kernel for Android private.

Since operating systems are such an integrated part of our lives, we want as little restriction as possible.

The MIT license opens up a lot of possibilities, which are simply not plausible with, say, the GPL:
- It allows for the distribution of proprietary changes to the Redox operating system. FreeBSD, for example, has been used in both Apple OS X and the Sony PS4
- It allows for the incorporation of GPL-incompatible code into the kernel, like OpenZFS
- MIT is compatible with GPL - Projects licensed as GPL can still be distributed with Redox
- Microkernel architecture means that driver maintainers could choose their own license to meet their needs

We wanted to encourage the use, modification, and packaging of Redox in absolutely all realms. Open source should be open, for everyone. We do not desire limiting the usage of the software. Therefore, MIT was the license of choice.

But what if someone "steals" the source code?
---------------------------------------------

What if Apple comes along and decides that Redox would be a good base for their next OS X?

We wouldn't mind if they did that. In order to successfully steal a project, you'd have to make _some_ improvements over the upstream version. You can't sell an apple for $2, if another person stands right next to you, giving them away for free. For this reason, making a (potentially proprietary) fork interesting requires putting some time and money into it.

There is nothing wrong with building on top of Redox. You can't _unfairly_ abuse our project by making proprietary extensions. That's simply not possible. For a fork to gain interest, you will have to put effort into it no matter what.

Building on top of Redox, whether it gets to upstream or not, is a thing we appreciate.
---------------------------------------------------------------------------------------

We like to have a decentralized structure of the project, allowing people to do whatever they want, no matter how they intend to share it.

Copyleft licenses are upstream-centric, whereas permissive licenses can be thought of as more downstream-centric. We happen to prioritize downstream more than upstream.
