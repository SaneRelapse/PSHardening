# This script needs to be run as ADMINISTRATOR inside Powershell terminal and not Powershell ISE
# The script you're about to run aims to enhance the security of notepad.exe by enabling several important process mitigations.
# These mitigations make it more difficult for attackers to exploit vulnerabilities in notepad.exe and prevent common techniques such as code injection or process migration.
# Let's break down what each of the settings does and how they help prevent attackers from migrating into notepad.exe (a common target for injection attacks, such as those from tools like Metasploit):

# 1. DEP (Data Execution Prevention)
# Purpose: DEP prevents code from being run in areas of memory that are not explicitly marked as executable. This is critical for stopping many forms of buffer overflow attacks, where an attacker tries to inject malicious code into non-executable memory areas.
# Effect on Migration: If an attacker tries to inject shellcode or any malicious payload into a region of memory that is not executable, DEP will block it. This makes it harder for attackers to use notepad.exe as a victim for shellcode execution.

# 2. ForceRelocateImages
# Purpose: This setting forces the relocation of memory images used by notepad.exe to avoid certain predictable memory addresses. Attackers often rely on the predictability of memory locations (such as the location of injected code) to exploit vulnerabilities. By relocating the memory images, it makes this strategy much harder.
# Effect on Migration: This mitigates attacks that depend on knowing the location of code in memory, making it more difficult for attackers to inject or execute code in specific, predictable memory locations.

# 3. HighEntropy ASLR (Address Space Layout Randomization)
# Purpose: ASLR randomizes the memory addresses used by applications, including stack, heap, and libraries. High entropy ASLR adds even more randomness to the address space, making it harder for an attacker to guess where important structures (such as function pointers, code sections, or libraries) are located in memory.
# Effect on Migration: With high-entropy ASLR, attackers cannot rely on fixed memory addresses to hijack a process or inject malicious code. Even if an attacker successfully exploits a vulnerability in notepad.exe, the memory locations they rely on will be unpredictable, significantly reducing their chances of success.

# 4. SEHOP (Structured Exception Handling Overwrite Protection)
# Purpose: SEHOP protects against exploits that attempt to overwrite exception handling structures in memory. These types of attacks often rely on manipulating exception handlers to jump to attacker-controlled code (e.g., via buffer overflows).
# Effect on Migration: If an attacker tries to use an SEH-based technique to take control of notepad.exe (such as during a buffer overflow or other exception-based attacks), SEHOP prevents this manipulation, making it much harder for the attacker to hijack the process.

# 5. CFG (Control Flow Guard)
# Purpose: CFG helps prevent certain types of code injection attacks by ensuring that control flow (such as function calls or returns) is directed only to valid, known locations. It effectively prevents an attacker from diverting the flow of execution to malicious code.
# Effect on Migration: If an attacker tries to inject code into notepad.exe and redirect the process’s execution flow to it, CFG will block any such illegal attempts. This is crucial for preventing successful exploits such as ROP (Return-Oriented Programming) and other control flow manipulation techniques.

# 6. BlockDynamicCode
# Purpose: This prevents the execution of dynamically generated code. This includes code that might be injected by an attacker or generated at runtime (such as shellcode or scripts executed from memory).
# Effect on Migration: If an attacker tries to inject dynamically generated code into notepad.exe, such as using a technique like reflective DLL injection or writing and executing code in memory, this mitigation will block such actions.

# How This Helps Prevent Process Migration
# Hardens Memory: Mitigations like DEP, ASLR, and ForceRelocateImages harden memory usage and prevent attackers from reliably predicting where to inject malicious code, making it difficult for them to inject or manipulate the process.
# Protects Against Code Execution: With protections like HighEntropy ASLR, SEHOP, CFG, and BlockDynamicCode, the script ensures that attackers cannot easily redirect the flow of execution or run arbitrary code in the context of notepad.exe. This means that even if an attacker manages to get malicious code into notepad.exe, they are less likely to be able to execute it.
# Prevents Malicious Code Injection: BlockDynamicCode specifically stops many types of injection attacks by preventing dynamically generated code from running, which is a common technique used by attackers to inject their payloads into a running process.

Import-Module ProcessMitigations 

# Set the process mitigations for notepad.exe
Set-ProcessMitigation -Name notepad.exe -Enable DEP, ForceRelocateImages, HighEntropy, SEHOP, CFG, BlockDynamicCode
