# Payload Generator
 
Payload Generator is a tool to generate the most common Meterpreter payloads via MSFvenom, part of the Metasploit framework.
 

# About
Payload Generator is a wrapper around MSFvenom that provides a more user friendly experience to generate multiple types of payloads. Our intent is to make user experience a$

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
