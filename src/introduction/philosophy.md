# Our Philosophy

We believe in [free software](https://www.gnu.org/philosophy/free-sw.html).

Redox OS will be packaged only with compatible free software, to ensure that the entire default distribution may be *inspected*, *modified*, and *redistributed*. Software that does not allow these features, i.e. proprietary software, is against the goals of security and freedom and will not be endorsed by Redox OS. We endorse the [GNU Free System Distribution Guidelines](https://www.gnu.org/distros/free-system-distribution-guidelines.html).

To view a list of compatible licenses, please refer to the [GNU List of Licenses](https://www.gnu.org/licenses/license-list.html).

Redox OS is predominately MIT X11-style licensed, including all software, documentation, and fonts. There are only a few exceptions to this:
- GNU Unifont, which is GPLv2
- Fira font, which is SIL Open Font License 1.1
- Faba and Moka icons, which are GPLv3
- Newlib C library, [which is a number of free software licenses, mostly BSD](https://github.com/bminor/newlib/blob/master/COPYING.NEWLIB)
- NASM, which is BSD 2-clause

The MIT X11-style license has the following properties:
- It gives you, the user of the software, complete and unrestrained access to the software, such that you may *inspect*, *modify*, and *redistribute* your changes
  - *Inspection* Anyone may inspect the software for security vulnerabilities
  - *Modification* Anyone may modify the software to fix security vulnerabilities
  - *Redistribution* Anyone may redistribute the software to patch the security vulnerabilities
- It is compatible with GPL licenses - Projects licensed as GPL can be distributed with Redox OS
- It allows for the incorporation of GPL-incompatible free software, such as OpenZFS, which is CDDL licensed
- The microkernel architecture means that driver maintainers could choose their own free software license to meet their needs


