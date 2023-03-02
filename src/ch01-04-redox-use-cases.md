# Redox Use Cases

Redox is a general purpose operating system that can be used in many situations. Some of the key use cases for Redox are as follows.

## Server Room

Redox has the potential to be a secure server platform for cloud services and web hosting. The improved safety and reliability Redox can provide, as it matures, makes it an excellent fit for the server room. Work remains to be done on support for key server technologies such as databases and web servers, as well as compatibility with high-end server hardware.

Redox has plans underway for [virtualization](https://en.wikipedia.org/wiki/OS-level_virtualization) support. Although running an instance of Linux in a container on Redox will lose some of the benefits of Redox, it can limit the scope of vulnerabilities. Redox-on-Redox and Redox-on-Linux virtualization have the potential to be much more secure than Linux-on-Linux. These capabilities are still a ways off, but are among the objectives for the Redox team.

## Desktop

The development of Redox for the desktop is well underway. Although support for accelerated graphics is limited at this time, Redox does include a graphical user interface, and integration with GUI libraries like [Iced](https://iced.rs/) and [Slint](https://slint-ui.com/) are ongoing efforts.

A Demo version of Redox is available with several games and applications to try. However, the most important objective for desktop Redox is for hosting the development of Redox. We are working through issues with some of our build tools, and other developer tools such as editors have not been tested under daily use, but we continue to make this a priority.

Due to a fairly limited list of currently supported hardware, once self-hosted development is available, developers may need to obtain a Redox-specific development machine. We are adding more hardware compatibility as quickly as we can, and we hope to be able to support Redox development on a wide array of workstations and laptops in the near future.

## Infrastructure

Redox's modular architecture make it ideal for many telecom infrastructure applications, such as routers, telecom components, edge servers, etc., especially as more functionality is added to these devices. There are no specific plans for remote management yet, but Redox's potential for security and reliability make it ideal for this type of application.

## Embedded and IoT

For embedded systems with complex user interfaces and broad feature sets, Redox has the potential to be an ideal fit. As everyday appliances become Internet-connected devices with sensors, microphones and cameras, they have the potential for attacks that violate the privacy of consumers in the sanctity of their homes. Redox can provide a full-featured, reliable operating system while limiting the likelihood of malicious attack. At this time, Redox does not yet have touchscreen support, video capture, or support for sensors and buttons, but these are well-understood technologies and can be added as it becomes a priority.

## Mission-Critical Applications

Although there are no current plans to create a version of Redox for mission-critical applications such as satellites or air safety systems, it's not beyond the realm of possibility. As tools for correctness proofs of Rust software improve, it may be possible to create a version of Redox that is proven correct, within some practical limits.
