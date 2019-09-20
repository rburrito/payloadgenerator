# PGen
PGen is a tool to generate the most common Meterpreter payloads via MSFvenom, part of the Metasploit framework.
About

# About
PGen is a wrapper around MSFvenom that provides a more user friendly experience to generate multiple types of payloads. Our intent is to make user experience as uncomplicated as possible to produce a payload. Instead of users going through MSFvenom manually looking for a specific payload, our goal is to automate the process for them while customizing the payload generating experience. Payload Generator asks users questions defining their target and calls msfvenom directly to generate a payload.

Required input from the user:

    Platform: Windows, Linux, OSX
    Architecture: 64 bit or 32 bit
    Shell: Bind or reverse
    If it is a reverse shell: Your IP and the port you want to listen on
    If it is a bind shell: Target IP and port
    Meterpreter: y or n
    Type: Staged or Stageless
    Format: exe, raw, pl, rb, c, elf
    Name of your generated payload file
    Includes an encoding option to evade antivirus detection.
