**[TRACKING: instructions.md Step 1; syllabus p.1 metadata requirement]**

| Full Name (Hebrew) | Full Name (English) | ID Number (ת"ז) | Email Address | Phone Number | Lecture Group (Day/Hour) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| [Student 1 - Hebrew Name] | [Student 1 - English Name] | [Student 1 ID] | [Student 1 Email] | [Student 1 Phone] | [Student 1 Group] |
| [Student 2 - Hebrew Name] | [Student 2 - English Name] | [Student 2 ID] | [Student 2 Email] | [Student 2 Phone] | [Student 2 Group] |

**[TRACKING: instructions.md report title; syllabus Tasks 1 and 2]**

# Reverse Engineering Research Project

**TrickBot Modular Malware, Independent Technical Briefings, and Conti Leaked Source-Code Evaluation**

> **Research dates:** 6-7 June 2026
> **Scope rule:** Sections explicitly marked optional in the syllabus are omitted.  
> **Safety rule:** This report describes architecture and defensive implications. It does not reproduce deployable malware, exploit code, or operational instructions.

---

**[TRACKING: instructions.md Step 2; syllabus Task 1, mandatory technical profile]**

## Task 1 - TrickBot Modular Malware Dossier

**[TRACKING: instructions.md Step 2, Architecture Overview; syllabus Task 1 technical-detail requirement]**

### 1. Architecture Overview

TrickBot is a **modular, multi-stage Windows malware platform**, not merely a
single banking Trojan. Microsoft describes a typical chain containing a
changing wrapper, an in-memory loader, and the main malware module. The loader
decrypts functions only when needed, resolves APIs dynamically, and starts the
main module in memory. On 64-bit systems, some variants use Heaven's Gate and a
64-bit loader before injection into a suspended process [S1].

The main component establishes persistence, identifies the host, decrypts its
configuration, and retrieves only the modules needed for that campaign. This
design separates stable orchestration from specialized capabilities and lets
operators replace individual components without rebuilding the entire platform.
Kaspersky catalogued dozens of 32-bit and 64-bit modules, while Check Point
reported more than 20 modules active across TrickBot's lifetime [S2][S3].

**Representative functional modules**

| Module or family | Defensive interpretation |
| :--- | :--- |
| `systeminfo` / `networkDll` | Collects operating-system, process, domain, network, and Active Directory context. |
| `pwgrab` / `tdpwgrab` | Targets credentials and application data, including browsers, mail, remote-access tools, keys, and wallets. |
| `injectDll` / `webiDll` | Performs browser interception and web-inject activity against financial sessions. |
| `adll` | Uses native administration tools to collect Active Directory database and registry-hive material. |
| `bcClient` / `NewBCtestn` | Supplies reverse-proxy capability and can support movement through a compromised host. |
| `mshare`, `tab`, `mworm` / `nworm`, `wormDll` | Implements network propagation through shares, remote execution, stolen credentials, or an SMB exploit path. |

**Architectural consequence:** defenders should correlate the loader,
module-fetch behavior, memory execution, process injection, scheduled-task
persistence, and the behavior of each downloaded module. A signature for one
module cannot represent the full TrickBot platform.

**[TRACKING: syllabus Task 1 critical-reading requirement]**

### Source Comparison and Research Quality

The TrickBot sources describe different generations and should not be treated
as interchangeable. Malwarebytes' 2016 report [S6] is useful as an early view
of the emerging family and its configuration cryptography. The 2018
Malwarebytes, Palo Alto, and F5 reports [S4][S5][S8] document intermediate
delivery, obfuscation, and propagation changes. Microsoft's 2020 anatomy [S1]
provides the clearest end-to-end loader and execution-chain overview.
Kaspersky's 2021 module catalogue [S2] is the most detailed source in this
report for comparing individual plug-ins, while Check Point's 2022 report [S3]
is a later view of the platform's continued module evolution. The reports
therefore complement one another: early sources establish lineage, detailed
technical sources explain mechanisms, and later sources show which components
changed over time.

**[TRACKING: instructions.md Step 2, Infection Chain; syllabus Task 1 internal-mechanism requirement]**

### 2. Infection and Execution Chain

1. **Delivery:** historically, malicious Office documents, links, or another
   loader such as Emotet delivered the first stage [S4].
2. **Wrapper execution:** a frequently changing wrapper obscures the stable
   loader and reduces simple hash-based detection [S1].
3. **In-memory loading:** the loader decrypts code and strings at runtime,
   resolves Windows APIs dynamically, and launches the core component [S1].
4. **Privilege and persistence:** variants may attempt UAC bypass and create
   scheduled tasks. Main components and plug-ins are commonly injected into
   legitimate processes such as `svchost.exe` [S1][S5].
5. **Configuration bootstrap:** the bot decrypts embedded or local
   configuration data, derives a bot identity and campaign tag, and contacts
   controller infrastructure for updated configuration and modules [S1][S6].
6. **Capability expansion:** modules perform credential theft, discovery,
   browser interception, proxying, Active Directory collection, propagation,
   or delivery of later payloads [S2].
7. **Network expansion:** propagation modules enumerate reachable systems and
   domain resources, then use SMB shares, remote execution, credentials, or an
   exploit-dependent path [S2][S7].

This chain also explains why a forensic image may show different artifacts on
different hosts: the controller can assign modules by architecture, campaign,
privilege level, and network position.

**[TRACKING: instructions.md Step 2, Cryptographic Layer; syllabus Task 1 internal technical mechanism]**

### 3. Cryptographic and Obfuscation Layer

TrickBot's cryptography changed between generations, so no single algorithm
describes every sample.

- **Configuration and module protection:** early documented variants used AES
  in CBC mode. A custom iterative SHA-256 construction derives key and IV
  material from the encrypted blob. If AES parsing failed, the implementation
  could attempt an ECC-based path [S6].
- **Additional wrapping:** later configurations added a first-stage DWORD-wise
  XOR layer before the established configuration decoder. F5 observed the key
  and data length stored at the front of the configuration object [S8].
- **Runtime concealment:** the loader decrypts individual functions and strings
  only for use, then can re-encrypt them. APIs are resolved dynamically instead
  of appearing as a complete static import table [S1][S8].
- **Windows CryptoAPI in resource handling:** a documented variant acquired a
  provider with `CryptAcquireContextW`, imported key material with
  `CryptImportKey`, operated on an encrypted resource, and released handles
  with `CryptDestroyKey` [S9]. These calls describe that analyzed variant, not a
  guaranteed invariant of all TrickBot builds.
- **Certificate-chain subversion in browser interception:** newer `injectDll`
  variants hooked `CertGetCertificateChain` and
  `CertVerifyCertificateChainPolicy` so a locally generated certificate could
  support interception without normal browser validation failures [S2].

The protected objects include the hardcoded bootstrap configuration, updated
controller lists, module binaries, module-specific configuration, and
web-inject rules. Cryptography here serves **confidentiality from analysts,
integrity/control of tasking, and signature instability**, rather than a single
user-facing encryption function.

**[TRACKING: instructions.md Step 2, Vulnerability Registry; syllabus Task 1 item 9]**

### 4. Vulnerability and Propagation Registry

The MS17-010 bulletin covers a family of SMBv1 defects represented by
**CVE-2017-0143 through CVE-2017-0148**. These include remote-code-execution and
information-disclosure conditions in Microsoft SMBv1 [S10].

| CVE | Assignment-relevant interpretation |
| :--- | :--- |
| CVE-2017-0143 | SMBv1 remote-code-execution vulnerability in the MS17-010 cluster. |
| CVE-2017-0144 | SMBv1 remote-code-execution vulnerability most commonly associated with EternalBlue reporting. |
| CVE-2017-0145 | SMBv1 remote-code-execution vulnerability in the same bulletin. |
| CVE-2017-0146 | SMBv1 remote-code-execution vulnerability in the same bulletin. |
| CVE-2017-0147 | SMBv1 remote-code-execution vulnerability in the same bulletin. |
| CVE-2017-0148 | SMBv1 information-disclosure vulnerability in the same bulletin. |

**Attribution caveat:** listing the complete MS17-010 cluster does not prove
that every TrickBot build exploited every CVE. Kaspersky identifies
`wormDll` as an EternalBlue propagation component that places shellcode in
`lsass.exe` memory and retrieves TrickBot [S2]. Palo Alto also warned that
other TrickBot SMB propagation behavior differed from WannaCry's EternalBlue
implementation [S4]. Therefore, the defensible conclusion is:

- TrickBot had an EternalBlue-capable propagation path.
- TrickBot also used share- and credential-based propagation.
- Sample-specific reverse engineering is required before assigning a precise
  exploit implementation to one CVE.

**[TRACKING: instructions.md TrickBot visual placeholder]**

![TrickBot Modular Architecture and Execution Chain Diagram](./images/trickbot_architecture.png)

---

**[TRACKING: instructions.md Step 3 Q11; syllabus p.4 Q11]**

## Q11 - Recent Vulnerability: CVE-2024-3400

**CVE-2024-3400** is a critical PAN-OS GlobalProtect vulnerability disclosed on
12 April 2024. Palo Alto Networks describes the root condition as arbitrary
file creation leading to operating-system command injection. On affected,
specifically configured PAN-OS 10.2, 11.0, and 11.1 firewalls, an unauthenticated
network attacker could execute code with root privileges [S11][S12].

**Mechanism summary**

- Untrusted GlobalProtect request data reached a file-creation path without a
  safe trust boundary.
- Attacker-controlled data later entered a privileged command-execution
  context.
- The impact crossed from a network-facing service to root-level appliance
  execution.
- Cloud NGFW, Panorama appliances, Prisma Access, and older PAN-OS branches
  listed by the vendor were not affected [S11].

Operationally, exploitation could provide full control of the firewall,
credential or configuration access, persistence opportunities, and a pivot
point into protected networks. The CVE was observed in production exploitation,
which is why product configuration and exact hotfix levels matter more than the
headline CVSS score alone.

**[TRACKING: instructions.md Q11 visual placeholder]**

![NVD Registry Technical Overview for Chosen CVE](./images/cve_nvd_registry.png)

---

**[TRACKING: instructions.md Step 3 Q12; syllabus p.4 Q12]**

## Q12 - Two MITRE D3FEND Defensive Techniques

The following entries come from different D3FEND parent pillars.

**[TRACKING: instructions.md Q12 Detect branch; MITRE D3FEND D3-PSA]**

### Detect: Process Spawn Analysis (D3-PSA)

Process Spawn Analysis evaluates process-creation attributes such as user,
image path, process name, parent relationship, arguments, and security context
to identify unauthorized execution [S13].

**Configuration principles**

- Collect process-creation telemetry with full image path, command line, user,
  integrity level, signer, hash, and parent process.
- Normalize command-line parsing before applying detections.
- Alert on impossible or rare parent-child relationships, execution from
  user-writable paths, and trusted names launched from untrusted locations.
- Do not trust parent PID alone; attackers can spoof it.

**[TRACKING: instructions.md Q12 Harden branch; MITRE D3FEND D3-ACH]**

### Harden: Application Configuration Hardening (D3-ACH)

Application Configuration Hardening reduces attack surface by disabling
unneeded features and limiting permissions according to the application's
actual environment [S14].

**Configuration principles**

- Disable unused remote interfaces, scripting, plug-ins, and legacy protocols.
- Run services with dedicated least-privilege identities.
- Restrict write access to configuration, extension, and executable paths.
- Maintain a version-controlled security baseline and alert on drift.

The first technique detects suspicious execution after process creation; the
second reduces which application behaviors are available before exploitation.

---

**[TRACKING: instructions.md Step 3 Q13; syllabus p.4 Q13]**

## Q13 - Chinese Threat Group: APT41

MITRE tracks **APT41 (G0096)** as a Chinese state-sponsored espionage group that
also conducts financially motivated operations. Aliases include **Wicked Panda,
Brass Typhoon, BARIUM**, and partial overlap with **Winnti Group** reporting
[S15].

**Target profile**

- Healthcare, telecommunications, technology, finance, education, retail, and
  video-game organizations.
- Campaigns across at least 14 countries.
- Public-facing applications, software supply chains, and credentialed access
  are recurring entry points.

**Verified custom or closely associated tooling**

- `BLACKCOFFEE`, `HIGHNOON`, `LOWKEY`, `DEADEYE`
- `DUSTPAN`, `DUSTTRAP`, `KEYPLUG`
- Winnti-family backdoors and web shells such as China Chopper
- Commodity support tools including Cobalt Strike, Mimikatz, and Impacket

The distinction matters: commodity tools do not uniquely identify APT41.
Attribution depends on infrastructure, victimology, timing, certificates,
malware lineage, and TTP combinations.

**Notable campaign:** MITRE's C0017 record describes an APT41 campaign from May
2021 through February 2022 that compromised at least six U.S. state-government
networks through vulnerable public-facing applications. Reported activity
included rapid adoption of public vulnerabilities, web shells, credential
access, staging, and exfiltration of personally identifiable information
[S35].

---

**[TRACKING: instructions.md Step 3 Q14; syllabus p.4 Q14]**

## Q14 - macOS Malware: RustBucket

**RustBucket** is a multi-stage macOS family associated by Jamf with the
BlueNoroff/Lazarus ecosystem. Its first stage was a compiled AppleScript
application masquerading as an internal PDF viewer. The Objective-C second
stage opened a specially prepared PDF and retrieved a later payload [S16].

**Processor architecture**

- Intel Macs execute `x86_64` Mach-O code natively.
- Apple Silicon Macs execute `arm64` natively and may run supported Intel code
  through Rosetta 2.
- Jamf analyzed both ARM and Intel RustBucket executables, demonstrating that
  operators accounted for both hardware populations [S16].

A multi-architecture deployment can ship separate architecture-specific
binaries or a universal Mach-O containing both slices. Native ARM64 support
avoids relying on Rosetta availability and changes reverse-engineering details:
register conventions, instruction set, calling convention, and disassembler
output differ from x86-64. The high-level Objective-C application behavior,
bundle structure, and Cocoa APIs can remain similar across both builds.

---

**[TRACKING: instructions.md Step 3 Q15; syllabus p.4 Q15]**

## Q15 - Bring Your Own Vulnerable Driver (BYOVD)

BYOVD is a defense-evasion and privilege technique in which an attacker with
sufficient installation rights loads a **legitimately signed but vulnerable
kernel driver**. The signature satisfies the normal driver trust path, while
unsafe device-control handlers expose privileged operations to user mode.

**Real case:** `mhyprot2.sys` version 1.0.0.0, the Genshin Impact anti-cheat
driver, is tracked as **CVE-2020-36603**. NVD states that it inadequately
restricts unprivileged function calls and can permit SYSTEM-level code
execution after administrative installation [S17]. Trend Micro documented
ransomware operators using the signed driver to terminate security processes
[S18].

**Pipeline**

1. The attacker obtains administrative execution through an earlier compromise.
2. The signed vulnerable driver is dropped and registered as a kernel service.
3. A user-mode controller opens the device object and sends exposed IOCTLs.
4. The driver performs privileged memory or process operations on the
   controller's behalf.
5. Security products are terminated or altered from kernel context, after which
   the primary payload proceeds.

Mitigation requires more than patching the original game: vulnerable-driver
blocklists, WDAC/HVCI, driver inventory, and alerts on new kernel services are
needed because an old signed driver can be carried independently.

---

**[TRACKING: syllabus p.5 Q17; defensive mechanism]**

## Q17 - Defensive Mechanism: Process Spawn Analysis

Process Spawn Analysis is a defensive mechanism under MITRE D3FEND's Detect
pillar. It compares process-creation attributes such as parent and child image,
command line, user, integrity level, path, and signer to identify execution
that does not fit the host's expected behavior [S13].

A practical implementation should collect complete process-creation telemetry,
normalize command lines, and alert on rare parent-child relationships,
executables launched from user-writable directories, and trusted filenames
running from unexpected paths. This section intentionally overlaps Q12 because
the syllabus specifically emphasizes Process Analysis for Q17.

---

**[TRACKING: syllabus p.5 Q18; anti-debugging mechanism]**

## Q18 - Anti-Debugging Technique: IsDebuggerPresent

Windows exposes `IsDebuggerPresent`, which returns a nonzero value when the
calling process is running under a user-mode debugger [S36]. Malware can call
this API early and then exit, delay, suppress payload deployment, or execute a
decoy path when analysis is detected. MITRE classifies this behavior under
Debugger Evasion (T1622), alongside checks of the Process Environment Block,
hardware breakpoints, timing differences, and exception behavior [S37].

This check is easy for an analyst to recognize and bypass, so it should be
treated as an evasion signal rather than a strong security boundary.

---

**[TRACKING: syllabus p.5 Q19; privilege-escalation mechanism]**

## Q19 - Privilege Escalation: UAC Bypass

MITRE ATT&CK defines Bypass User Account Control as T1548.002. UAC normally
mediates elevation from a lower-integrity process to administrator privileges,
but some trusted Windows components and auto-elevated COM objects have been
abused to start attacker-controlled code without the expected consent prompt
[S38].

The technique normally requires that the compromised user already belongs to
the local Administrators group; it bypasses the UAC prompt rather than creating
administrator rights from nothing. Defensive controls include removing
unnecessary local-administrator membership, using the highest practical UAC
enforcement level, patching Windows, and correlating registry changes with
unexpected launches of auto-elevated binaries.

---

**[TRACKING: instructions.md Step 3 Supply Chain; syllabus p.5 Q24; instructions label Q20]**

## Q24 (Instructions: Q20) - XZ Utils Supply-Chain Backdoor

The **XZ Utils 5.6.0 and 5.6.1** incident, tracked as **CVE-2024-3094**, is a
landmark attempted supply-chain compromise.

**Execution/distribution timeline**

- **24 February 2024:** xz 5.6.0 was released.
- **9 March 2024:** xz 5.6.1 was released.
- The malicious build logic was present in release tarballs, while key trigger
  material was absent from the ordinary Git source view.
- **29 March 2024:** Andres Freund publicly reported the issue after tracing
  abnormal `sshd` CPU use and authentication latency; Red Hat issued its urgent
  alert the same day [S19][S20].

The injected build process produced a modified `liblzma` that, under specific
Linux build and service conditions, could interfere with `sshd` authentication
through systemd-linked dependencies. The compromise targeted the **build and
distribution trust chain**, not a normal xz feature [S19].

**Blast radius**

Affected packages reached development or unstable distributions including
Fedora Rawhide/Fedora 40 beta and Debian unstable contexts. Discovery occurred
before broad inclusion in stable enterprise distributions, sharply limiting
real-world deployment. The potential impact was nevertheless severe because xz
is a transitive dependency in widely deployed Linux software.

No authoritative source provides a reliable count of compromised organizations
or computers. The defensible answer is therefore that malicious packages
entered several development/testing distribution channels, but discovery
preceded broad stable-enterprise rollout and prevented a measurable
SolarWinds-scale victim population.

---

**[TRACKING: instructions.md Step 3 RAT briefing; syllabus p.5 Q21]**

## Q21 - Popular RAT Framework: Remcos

MITRE tracks **Remcos (S0332)** as a closed-source Windows remote-control and
surveillance tool that has repeatedly appeared in malicious campaigns [S21].

**Capabilities**

- Keylogging and clipboard collection.
- Automated screenshots and application-window discovery.
- Microphone capture and remote environmental observation.
- File search, upload, download, deletion, and archive creation.
- Registry control, persistence through Run keys, and UAC-bypass commands.
- Stored-browser-data collection and remote command execution.

The controller sends tasking to the installed agent; the agent invokes Windows
APIs, packages results, and returns them over its remote channel. Keylogging
captures input events over time, while screenshots and window enumeration give
the operator visual and contextual awareness. These features make Remcos both a
legitimate dual-use administration product and a high-risk post-compromise
tool when deployed without authorization.

MITRE records operational use by LazyScripter, Gamaredon Group, APT-C-36
(Blind Eagle), and Gorgon Group, as well as use during Operation Spalax [S21].

---

**[TRACKING: instructions.md Step 3 fileless briefing; syllabus p.5 Q22]**

## Q22 - Fileless Malware Example: Kovter

“Fileless” describes an execution technique, not an absence of all artifacts.
Attackers use trusted interpreters, registry-resident content, and
memory-resident loading so the principal payload does not need to exist as a
conventional executable on disk.

**Named example:** Microsoft documented Kovter as an almost-fileless
click-fraud Trojan in July 2016. Most malicious code was stored in the Windows
registry. A randomly assigned file extension and shell-open handler ultimately
invoked `mshta`; startup shortcuts or a Run-key-launched batch file triggered
that registered handler [S39].

**Technique and campaign context**

- The important system interpreter is `mshta.exe`, launched through a malicious
  shell-open association.
- Persistence data and most code remain in registry values, while small
  shortcut, batch, or nonstandard-extension files act as triggers.
- Microsoft tied the analyzed generation to malvertising campaigns and noted
  that complete remediation required removing both the registry content and
  the trigger files [S39].

More generally, PowerShell, WMI, and reflective DLL loading can execute content
without normal disk-backed module loading [S22][S23]. Evidence still exists in
process, script-block, AMSI, registry, memory, and network telemetry.

---

**[TRACKING: syllabus p.5 Q23; WebInject malware]**

## Q23 - WebInject Malware Example: TrickBot

TrickBot is a documented WebInject malware family. Its `injectDll` and related
web-inject components intercept browser activity and alter or observe selected
financial sessions according to downloaded targeting rules [S2]. Later
variants also hooked certificate-chain validation functions so locally
generated certificates could support interception without ordinary browser
certificate errors [S2].

WebInject should not be reduced to changing a webpage's appearance. It operates
inside or alongside the browser's transaction path, where it can capture form
data, insert attacker-controlled fields, redirect requests, or manipulate what
the victim sees while preserving the appearance of a legitimate banking
session.

---

**[TRACKING: instructions.md Step 3 AI vulnerability; syllabus p.5 Q20]**

## Q20 - LLM Infrastructure Vulnerability: Prompt Injection

OWASP classifies **Prompt Injection as LLM01:2025**. A direct injection comes
from the user; an indirect injection is embedded in external content such as a
web page, document, email, or image that the model later processes [S24].

The core weakness is a trust-boundary failure: instructions and data are
represented in the same natural-language context, while the model may also
hold tools or credentials. A successful injection can manipulate output,
disclose sensitive context, invoke unauthorized functions, or influence a
high-impact decision.

**Mitigation**

- Treat retrieved content and model output as untrusted.
- Give the model least-privilege, task-specific credentials.
- Validate tool arguments and outputs with deterministic code.
- Require human approval for privileged or irreversible actions.
- Separate external content from control instructions.
- Continuously test direct, indirect, multilingual, encoded, and multimodal
  injection cases.

RAG and fine-tuning can improve relevance but do not remove this architectural
risk [S24].

---

**[TRACKING: instructions.md Step 3 AI-enabled threat activity; syllabus p.5 Q25]**

## Q25 - Documented Threat-Actor Use of AI

Public reporting supports three distinct patterns.

- **Code assistance:** OpenAI and Microsoft reported that Charcoal Typhoon used
  models to debug code and generate scripts, while other state-affiliated
  actors requested scripting help, vulnerability research, and methods for
  hiding processes or evading detection [S25].
- **Social engineering:** Crimson Sandstorm and Emerald Sleet used models to
  draft or improve content suitable for spear-phishing. Later Microsoft
  reporting describes AI as an accelerator for polished lures, translation,
  identity maintenance, and malware debugging rather than a fully autonomous
  attacker [S25][S26].
- **Machine-learning components inside stealers:** trojanized Telegram and
  WhatsApp applications used Google's ML Kit OCR to find cryptocurrency seed
  phrases in stored screenshots. SparkCat later used an OCR plug-in in malicious
  Android and iOS applications for the same objective [S27][S28].

The evidence does not justify claiming that LLMs independently conducted these
campaigns. Human operators retained control of targeting and deployment; AI
reduced language, coding, and data-processing friction.

---

**[TRACKING: instructions.md Step 3 Q26; syllabus p.5 Q26]**

## Q26 - Iranian Threat Group: MuddyWater

MITRE identifies **MuddyWater (G0069)** as an Iranian cyber-espionage group
assessed to be subordinate to the Ministry of Intelligence and Security. Aliases
include **Earth Vetala, MERCURY, Static Kitten, Seedworm, TEMP.Zagros, Mango
Sandstorm, TA450**, and **MuddyKrill** [S29].

**Target profile**

- Government, telecommunications, finance, defense, and oil and gas.
- Strong focus on the Middle East, with activity also in Asia, Africa, Europe,
  and North America.

**Tool registry**

- `POWERSTATS` PowerShell backdoor
- `PowGoop` loader
- `Small Sieve` Python backdoor
- `Mori` and `MuddyC2Go` backdoors
- `Out1` Python tooling
- Commodity utilities such as LaZagne, Mimikatz, and remote-administration tools

Common tradecraft includes spear-phishing, PowerShell/VBScript/JavaScript
execution, cloud file-sharing services for payload delivery, browser credential
theft, and HTTP-based command and control. As with APT41, a commodity tool alone
is insufficient attribution evidence.

---

**[TRACKING: instructions.md Step 3 Q29; syllabus p.6 Q29]**

## Q29 - iOS Vulnerability Cluster: Operation Triangulation

Operation Triangulation used a zero-click iMessage chain against iOS versions
up to 16.2. The attachment was processed without visible user interaction.
Kaspersky's reconstructed chain includes:

- **CVE-2023-41990:** remote code execution through an undocumented TrueType
  font instruction.
- JavaScriptCore manipulation and a privilege-escalation stage.
- **CVE-2023-32434:** XNU integer overflow used to gain broad physical-memory
  read/write capability.
- **CVE-2023-38606:** bypass of hardware-backed Page Protection Layer controls
  through undocumented MMIO behavior on A12-A16 SoCs [S30].

After kernel-level compromise, the chain removed exploitation artifacts,
launched an invisible Safari stage, and installed the TriangleDB espionage
platform.

**Persistence correction:** the toolset was **not persistent across reboot**.
Kaspersky reported that devices could be **reinfected after reboot**, which can
look like persistence from outside but is technically a fresh zero-click
compromise [S31]. This distinction is important in both incident response and
reverse engineering.

---

**[TRACKING: syllabus p.6 Q30; persistence technique]**

## Q30 - Persistence Technique: Windows Scheduled Task

Windows Scheduled Task abuse is MITRE ATT&CK T1053.005. An attacker can register
a task that starts a payload at logon, startup, a fixed time, or a recurring
interval. Tasks can also run under another security context such as `SYSTEM`
when the creator has sufficient rights [S40].

Defenders should monitor task creation and modification through `schtasks`,
PowerShell, WMI, COM, and Task Scheduler files or registry data. Suspicious
indicators include hidden tasks, misleading update names, payloads in
user-writable directories, and task creation followed by execution from
`taskeng.exe` or Task Scheduler's service process.

---

**[TRACKING: syllabus p.6 Q31; local privilege escalation technique]**

## Q31 - Local Privilege Escalation: UAC Bypass

A specific local privilege-escalation technique is UAC bypass (T1548.002).
Malware running for a user who is already a local administrator may abuse an
auto-elevated Windows component, COM interface, or trusted registry lookup to
start attacker-controlled code at high integrity without the normal consent
dialog [S38].

The prerequisite matters: UAC bypass commonly changes the integrity level of an
administrator's process; it does not automatically turn a standard user into an
administrator. Monitoring should correlate changes to known UAC-related
registry paths with launches of unusual auto-elevated binaries.

---

**[TRACKING: syllabus p.6 Q32; lateral-movement technique]**

## Q32 - Lateral Movement: SMB and Windows Admin Shares

MITRE ATT&CK T1021.002 covers lateral movement through SMB and Windows
administrative shares such as `ADMIN$`, `C$`, and `IPC$`. With valid
administrator credentials or reusable hashes, an attacker can copy tools to a
remote system and combine SMB/RPC access with service creation, scheduled
tasks, WMI, or another remote-execution mechanism [S41].

Defensive priorities are limiting local-administrator reuse, disabling SMBv1,
segmenting networks, restricting administrative shares, and alerting when a
host accesses many peer systems followed by remote service or task creation.

---

**[TRACKING: syllabus p.6 Q33; exfiltration technique]**

## Q33 - Exfiltration: Existing Command-and-Control Channel

Exfiltration Over C2 Channel is MITRE ATT&CK T1041. Instead of opening a new
network path, malware encodes stolen files or records into the same HTTP,
HTTPS, DNS, or custom protocol already used for command and control [S42].

Reusing the channel reduces new network indicators and lets the attacker apply
existing encryption or authentication. Defenders can look for unusual outbound
volume, long sessions, repeated uploads after archive creation, abnormal
request sizes, and endpoint collection activity immediately before C2 traffic.

---

**[TRACKING: instructions.md Step 4; syllabus Task 2 mandatory leaked-source evaluation]**

## Task 2 - Conti Ransomware Leaked Source-Code Evaluation

**[TRACKING: instructions.md Step 4 repository hyperlink; syllabus Task 2 source-code URL requirement]**

### 1. Repository and Provenance

Public research states that Conti source material was leaked on 27 February
2022, alongside internal communications, after the group publicly supported
Russia's invasion of Ukraine [S32].

**Research links**

- Public mirror used for structural review:
  <https://github.com/gharty03/Conti-Ransomware>
- Course-recommended malware-source index:
  <https://github.com/ytisf/theZoo/tree/master/malware/Source/Original>
- Peer-reviewed analysis:
  <https://doi.org/10.1109/ACCESS.2022.3207757>

The GitHub mirror warns that it contains fixes to intentionally damaged or
missing build material. It is therefore a **secondary mirror**, not an
authenticated original development repository [S33]. The `theZoo` link is an
index recommended by the course material, but its current `Source/Original`
listing is not evidence that it hosts this exact Conti tree [S34]. This report
does not download, compile, or execute either repository.

**[TRACKING: instructions.md Step 4 codebase structure; syllabus Task 2 technical analysis]**

### 2. Codebase Structure

The public mirror reports **C++ (62.8%) and C (37.2%)** and exposes the
following root structure: `.vs/`, `Debug/`, `Release/`, `builder/`,
`decryptor/`, `locker/`, `ContiLocker_v2.sln`, `R3ADM3.txt`, and repository
metadata [S33]. The first three directories are development/build artifacts;
the meaningful product divisions are `builder`, `decryptor`, and `locker`.

The high-level structure separates:

| Area | Function |
| :--- | :--- |
| Builder/configuration | Produces campaign-specific locker configuration and embedded values. |
| Locker/encryptor | Enumerates local and network files, applies encryption policy, writes ransom notes, and coordinates worker threads. |
| Decryptor | Reverses file transformation when supplied with matching key material. |
| API and string abstraction | Resolves libraries/functions dynamically and hides sensitive strings behind hashes or obfuscation macros. |
| Cryptographic modules | Implements asymmetric key wrapping and high-throughput file encryption primitives. |
| Filesystem/share enumeration | Walks directories, applies exclusion rules, and discovers network shares. |
| Network scanner | Enumerates candidate hosts and services used to find reachable shares. |
| Thread pool and queues | Schedules file and network work concurrently for throughput. |
| Logging/memory/string helpers | Supplies custom runtime support shared by the operational components. |

The IEEE analysis identifies dynamic library loading, API hashing,
anti-hooking/unhooking, command-line modes, share enumeration, network scanning,
shadow-copy deletion, and multithreaded encryption as explicit source-level
flows [S32]. Representative functional units discussed in analyses include API
resolution, filesystem traversal, network scanning, encryption, RSA/key
handling, thread-pool queues, logging, memory allocation, and custom strings.

**[TRACKING: instructions.md Step 4 functional-module analysis; syllabus Task 2]**

### 3. Functional Interpretation

- **Startup and argument parsing** choose local, network, or combined encryption
  scope and optional host-list input.
- **API resolution** keeps much of the true dependency set out of the static
  import table.
- **Anti-hook logic** attempts to restore clean system-library code before
  sensitive operations, reducing visibility from user-mode hooks.
- **Discovery** enumerates local volumes, directories, network addresses, and
  shares while applying exclusions.
- **Concurrency** places file work into queues consumed by multiple threads,
  increasing encryption throughput.
- **Cryptography** uses fast symmetric file encryption combined with
  attacker-controlled asymmetric key protection so recovery material is not
  locally available.

This is an architectural description only. Build steps, weaponization changes,
keys, and deployable code are intentionally excluded.

**[TRACKING: instructions.md Step 4 reverse-engineering advantage; syllabus Task 2]**

### 4. Why Source Accelerates Reverse Engineering

Source code collapses uncertainties that take substantial time to resolve in
assembly:

- Function and type boundaries are explicit.
- Data structures, queue ownership, and thread synchronization are visible.
- Conditional compilation reveals variant behavior.
- Error paths and exclusions are distinguishable from anti-analysis tricks.
- Cryptographic intent can be separated from compiler-generated operations.
- Source names provide hypotheses that can be validated against binaries and
  telemetry.

Source review does **not** replace binary analysis. A leak may be incomplete,
modified, older than the observed sample, or built with different flags.
Reverse engineers should use it as a comparative map, then verify each claim
against the executable, runtime behavior, and independent reporting.

**[TRACKING: instructions.md Step 4 repository visual placeholder]**

![Leaked Source Code GitHub Repository Structure Overview](./images/leaked_source_repo.png)

**[TRACKING: instructions.md Step 4 code visual placeholder]**

![Code Snippet of Core Malware Functional Module](./images/source_code_snippet.png)

---

**[TRACKING: syllabus Task 2 Part B; required for a two-person team]**

## Task 2B - Public Exploit/POC Source-Code Reference

### Selected Vulnerability: CVE-2015-1538 (Android Stagefright)

CVE-2015-1538 is an integer-overflow vulnerability in
`SampleTable::setSampleToChunkParams` within Android's `libstagefright`.
Malformed MP4 atom data can trigger unchecked multiplication, memory
corruption, and potentially remote code execution in the media-processing
context on affected Android releases before build LMY48I [S43][S44].

Google’s August 2015 Nexus bulletin rated the issue Critical, listed Android
5.1 and earlier as affected, and explained that remote content could reach the
vulnerable media path through mechanisms including MMS, email, web browsing,
or media playback [S44]. NVD published the CVE record on 30 September 2015 and
links to a public high-level-language exploit/POC reference in Exploit Database
entry 38124 [S43][S45].

**POC/source reference**

- Exploit Database entry:
  <https://www.exploit-db.com/exploits/38124/> [S45]
- This report links to the public research artifact but does not reproduce its
  payload, shellcode, build steps, or execution instructions.
- The assignment's own example identifies this entry as acceptable because the
  machine-code portion is accompanied by explanatory source and analysis.

**Search trail**

1. `Stagefright CVE`
2. `CVE-2015-1538 POC source code`
3. `CVE-2015-1538 Exploit-DB 38124`
4. Cross-check against NVD and the Android security bulletin.

**Reverse-engineering value:** the public source makes the malformed media
structure and parser assumptions easier to understand than a binary crash
alone. Analysts must still validate architecture, Android build, mitigations,
and exploitability against the exact target rather than assuming that an old
POC applies unchanged.

---

**[TRACKING: instructions.md Step 5; syllabus source-list and article-copy requirements]**

## Reversed Bibliography

The complete numbered bibliography and source preservation checklist are in
[`sources/source_manifest.md`](./sources/source_manifest.md). Every inline
reference `[S#]` maps to that register.

No full third-party articles are reproduced in this project. Before course
submission, the student should create a separate, lawful PDF print or full-page
screenshot of each cited article as required by the syllabus.

---

**[TRACKING: instructions.md Step 6; syllabus p.2 AI policy]**

## AI Utility and Compliance Record

The AI-use record is in [`ai/ai_usage_log.md`](./ai/ai_usage_log.md). It records
the supplied prompts, research workflow, corrections, and manual verification
tasks without claiming that AI output is an authoritative source.

**[TRACKING: instructions.md Step 6 visual placeholder]**

![AI Workspace Interaction Audit Log History Screenshot](./images/ai_interaction_proof.png)

---

**[TRACKING: instructions.md omission rule; syllabus optional-section policy]**

## Scope Compliance Statement

The report intentionally omits the syllabus sections explicitly marked
optional, including historical background, full C2 infrastructure analysis,
threat-group economics, Cyber Kill Chain mapping, anti-debug catalogues,
additional injection-method surveys, and other optional expansions. Mandatory
short independent questions selected by `instructions.md` are retained.
