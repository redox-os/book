# Schemes and Resources

An essential design choice made for Redox is to refer to resources using scheme-rooted paths.
This gives Redox the ability to:

- Treat resources (files, devices, etc.) in a consistent manner
- Provide resource-specific behaviors with a common interface
- Allow management of names and namespaces to provide sandboxing and other security features
- Enable device drivers and other system resource management to communicate with each other using the same mechanisms available to user programs
