Why Free Software?
=======

Redox OS will be packaged only with compatible free software, to ensure that the entire default distribution may be *inspected*, *modified*, and *redistributed*. Software that does not allow these features, i.e. proprietary software, is against the goals of security and freedom and will not be endorsed by Redox OS. We therefore comply with the [GNU Free System Distribution Guidelines](http://www.gnu.org/distros/free-system-distribution-guidelines.html).

To view a list of compatible licenses, please refer to the [GNU List of Licenses](http://www.gnu.org/licenses/license-list.html).

For more information about free software, [please view this page](http://www.gnu.org/philosophy/free-sw.html).

Free Software is more Secure
-------------------------------------
Redox OS is predominately MIT X11-style licensed, including all software, documentation, and fonts. There are only a few exceptions to this:
- GNU Unifont, which is GPLv2
- Fira font, which is SIL Open Font License 1.1
- Oxygen icons from KDE, which are LGPLv3
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

Proprietary Software is not Secure
----------------------------------
Consider the following clause, from [Microsoft Windows 10's EULA](https://www.microsoft.com/en-us/Useterms/Retail/Windows/10/UseTerms_Retail_Windows_10_English.htm):
```
c.  Restrictions. The manufacturer or installer and Microsoft reserve all
    rights (such as rights under intellectual property laws) not expressly
    granted in this agreement. For example, this license does not give you
    any right to, and you may not:

(i)     use or virtualize features of the software separately;

(ii)    publish, copy (other than the permitted backup copy), rent, lease, or
        lend the software;

(iii)   transfer the software (except as permitted by this agreement);

(iv)    work around any technical restrictions or limitations in the software;

(v)     use the software as server software, for commercial hosting, make the
        software available for simultaneous use by multiple users over a
        network, install the software on a server and allow users to access it
        remotely, or install the software on a device for use only by remote
        users;

(vi)    reverse engineer, decompile, or disassemble the software, or attempt to
        do so, except and only to the extent that the foregoing restriction is
        permitted by applicable law or by licensing terms governing the use of
        open-source components that may be included with the software; and

(vii)   when using Internet-based features you may not use those features in any
        way that could interfere with anyone else’s use of them, or to try to
        gain access to or use any service, data, account, or network, in an
        unauthorized manner.
```

These are clauses typical of proprietary software licenses, but disallowed in free software licenses. These clauses makes it possible for Microsoft to sue and seek damages from individuals who attempt to *inspect*, *modify*, or *redistribute* the software that they have installed. Redox OS abhors such limitations on your freedom. As Redox OS focuses on security, keep in mind the following:
- *Inspection* Software that cannot be legally studied, cannot have security flaws identified by the community. Crackers will take advantage of this, as they have no problem breaking the law, and will identify security flaws and utilize them for their own gains.
- *Modification* Software that cannot be legally changed, cannot have security flaws fixed by the community. Again, this will lead to identified security flaws being left unfixed for long periods of time.
- *Distribution* Software that cannot be legally distributed, cannot have security flaws patched by the community. This will lead to a number of vulnerable installations, even after an identified security flaw has been fixed.
