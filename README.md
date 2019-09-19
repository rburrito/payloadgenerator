# Payload Generator
 
Paymaker is a tool to generate the most common Meterpreter payloads via MSFvenom (part of the Metasploit framework).
 

# About
Payload Generator is a wrapper around MSFvenom which gives the users a more friendly and simpler experience to generate multiple types of payloads, based on their choice. Our intent is to make the experience uncomplicated to produce their payload.
Instead of users going through MSFvenom manually looking for a specific payload, our goal is to automate the process for them as well as customizing the payload generating experience (or customize the payload for their needs).  We will ask the user questions defining their target and call msfvenom to generate a payload based on user responses.
 
Required input from the user: 
* Platform: Windows, Linux, OSX
* Architecture: 64 bit or 32 bit
* Shell: Bind or reverse
* If it is a reverse shell: Your IP and the port you want to listen on
* If it is a bind shell: Target IP and port
* Meterpreter: y or n
* Type: Staged or Stageless
* Format: exe, raw, pl, rb, c, elf
* Name of your generated payload file
* Includes an encoding option to evade antivirus detection. 
