# RCE2026B — הוראות הגשה והשלמות אחרונות

המסמך להגשה:

`RCE20268_Israel_Ofir_Elad_ENGLISH.docx`

המסמך נכתב באנגלית, מוגדר משמאל לימין, ואינו כולל הערות עריכה או הוראות פנימיות.

## 1. השלמות בתוך קובץ ה-Word

יש לפתוח את העמוד הראשון ולהשלים בטבלת המגישים:

| מיקום | מה להשלים |
|---|---|
| שורה `Israel Mahari` | ת"ז, מייל ומספר טלפון |
| שורה `Ofir` | שם משפחה מלא, ת"ז, מייל ומספר טלפון |
| שורה `Elad` | שם משפחה מלא, ת"ז, מייל ומספר טלפון |

יש לוודא שהשמות באנגלית זהים לשמות הרשומים בעמדת המידע.

אין צורך להוסיף למסמך הערות על קבצים חסרים, הורדות או תהליך העריכה.

## 2. מבנה תיקיית ההגשה

יש להכין תיקייה במבנה הבא:

```text
RCE2026B_Submission/
├── RCE20268_Israel_Ofir_Elad_ENGLISH.docx
├── Articles/
│   ├── 01_MITRE_TrickBot.pdf
│   ├── 02_Malpedia_TrickBot.pdf
│   ├── ...
│   └── קובץ PDF נפרד לכל מקור שנעשה בו שימוש
└── AI_Documentation/
    ├── AI_01_Codex_APT41.png
    ├── AI_02_Codex_SolarWinds.png
    └── AI_FULL_TRANSCRIPT.txt
```

אפשר לדחוס את התיקייה ל-ZIP או RAR. אם הקובץ גדול מדי, מותר לפצל למספר הודעות מייל.

## 3. הורדת המאמרים

יש להוריד כל מקור ידנית כ-PDF מלא ונפרד:

1. לפתוח את הקישור.
2. לסגור חלונות Cookies, הרשמה או פרסומות.
3. להמתין עד שהעמוד נטען במלואו.
4. לבחור `Print` ואז `Save as PDF`.
5. לבדוק שה-PDF כולל את כל תוכן המאמר, הכותרת, התרשימים והקישור.
6. לא לשמור עמוד HTML מקומי.
7. לא להוריד או להריץ קובצי נוזקה בינאריים.

### מקורות עיקריים על TrickBot

1. MITRE ATT&CK — TrickBot S0266  
   https://attack.mitre.org/software/S0266/

2. Malpedia — TrickBot  
   https://malpedia.caad.fkie.fraunhofer.de/details/win.trickbot

3. SentinelOne — TrickBot Browser Hooking  
   https://www.sentinelone.com/labs/how-trickbot-malware-hooking-engine-targets-windows-10-browsers/

4. ESET — TrickBot Technical Deep Dive and Disruption  
   https://www.welivesecurity.com/2020/10/12/eset-takes-part-global-operation-disrupt-trickbot/

5. Microsoft — TrickBot Disruption Update  
   https://blogs.microsoft.com/on-the-issues/2020/10/20/trickbot-ransomware-disruption-update/

6. Eclypsium — TrickBoot Technical Report  
   https://eclypsium.com/wp-content/uploads/TrickBot-Now-Offers-TrickBoot-Persist-Brick-Profit.pdf

7. Microsoft — MS17-010  
   https://learn.microsoft.com/en-us/security-updates/securitybulletins/2017/ms17-010

8. NVD — CVE-2017-0144  
   https://nvd.nist.gov/vuln/detail/CVE-2017-0144

9. NVD — CVE-2017-0145  
   https://nvd.nist.gov/vuln/detail/CVE-2017-0145

### מקורות לסעיפים העצמאיים

10. CVE-2025-32463  
    https://www.cve.org/CVERecord?id=CVE-2025-32463

11. MITRE D3FEND — System Call Filtering  
    https://d3fend.mitre.org/technique/d3f:SystemCallFiltering/

12. MITRE D3FEND — Process Eviction  
    https://d3fend.mitre.org/technique/d3f:ProcessEviction/

13. MITRE ATT&CK — APT41  
    https://attack.mitre.org/groups/G0096/

14. MITRE ATT&CK — XCSSET  
    https://attack.mitre.org/software/S0658/

15. Sophos — RobbinHood BYOVD  
    https://news.sophos.com/en-us/2020/02/06/robbinhood-ransomware-brings-a-vulnerable-driver-to-the-party/

16. MITRE D3FEND — Process Spawn Analysis  
    https://d3fend.mitre.org/dao/artifact/d3f:ProcessSpawnAnalysis/

17. Check Point — IsDebuggerPresent  
    https://anti-debug.checkpoint.com/techniques/debug-flags.html

18. MITRE ATT&CK — Bypass UAC T1548.002  
    https://attack.mitre.org/techniques/T1548/002/

19. Mandiant — SolarWinds-SUNBURST  
    https://cloud.google.com/blog/topics/threat-intelligence/evasive-attacker-leverages-solarwinds-supply-chain-compromises-with-sunburst-backdoor

20. Morphisec — NanoCore RAT  
    https://blog.morphisec.com/nanocore-under-the-microscope

21. Trend Micro — NetWalker Fileless Ransomware  
    https://www.trendmicro.com/en_us/research/20/e/netwalker-fileless-ransomware-injected-via-reflective-loading.html

22. Virus Bulletin — Dridex  
    https://www.virusbulletin.com/uploads/pdf/magazine/2015/vb201507-Dridex.pdf

23. MITRE ATLAS  
    https://atlas.mitre.org/

24. OWASP Top 10 for LLM Applications  
    https://owasp.org/www-project-top-10-for-large-language-model-applications/

25. Recorded Future — Rhadamanthys 0.7.0  
    https://go.recordedfuture.com/hubfs/reports/mtp-2024-0926.pdf

26. Check Point — MuddyWater and BugSleep  
    https://research.checkpoint.com/2024/new-bugsleep-backdoor-deployed-in-recent-muddywater-campaigns/

27. Apple — CVE-2023-32434  
    https://support.apple.com/en-us/102162

28. Kaspersky — Operation Triangulation  
    https://www.kaspersky.com/blog/triangulation-attack-on-ios/48353/

29. MITRE ATT&CK — Registry Run Keys T1547.001  
    https://attack.mitre.org/techniques/T1547/001/

30. MITRE ATT&CK — Token Impersonation T1134.001  
    https://attack.mitre.org/techniques/T1134/001/

31. MITRE ATT&CK — SMB Admin Shares T1021.002  
    https://attack.mitre.org/techniques/T1021/002/

32. MITRE ATT&CK — Exfiltration Over C2 T1041  
    https://attack.mitre.org/techniques/T1041/

33. Lockheed Martin — Cyber Kill Chain  
    https://www.lockheedmartin.com/en-us/capabilities/cyber/cyber-kill-chain.html

### מקורות למטלה 2

34. Conti leaked source-code repository — עיון סטטי בלבד  
    https://github.com/gharty03/Conti-Ransomware

35. IEEE Access — Analysis of Conti Leaked Source Code  
    https://doaj.org/article/a1f9eedb587e4e7c85a488c87c61a7e7

אין צורך להוריד את קוד Conti למחשב. מספיק לשמור PDF מלא של עמוד המאגר ושל מאמר הניתוח.

## 4. תיעוד השימוש ב-AI

הקבצים נמצאים בתיקייה:

`AI_Documentation`

יש לצרף:

- `AI_01_Codex_APT41.png`
- `AI_02_Codex_SolarWinds.png`
- `AI_FULL_TRANSCRIPT.txt`

שתי התמונות כבר מוטמעות גם בסעיף 28 במסמך ה-Word.

התמונות מתעדות:

- שם הכלי: OpenAI Codex.
- גרסה: GPT-5.
- תאריך השימוש.
- הפרומפט המלא.
- התשובה הגולמית.
- המקורות ששימשו לבדיקה.

## 5. בדיקה מול דרישות המטלה

המסמך כולל את כל סעיפי החובה:

- פרקים 1, 3, 4 ו-9 על TrickBot.
- סעיפים 11, 12, 13, 15, 17–26, 28–33.
- סעיפים אופציונליים 14 ו-34.
- מטלה 2 על קוד המקור שדלף של Conti.
- סיכום, דעה אישית ומסקנות.

קטע Process Hollowing אינו נדרש ולא נכלל:

- מטלה 2 דורשת איתור קוד מקור שדלף או POC/Exploit קיים.
- הקטע הקודם לא היה קוד שדלף.
- הוא לא היה POC לחולשת CVE.
- הוא לא מימש Process Hollowing מלא.
- קישור לקוד Conti ומאמר IEEE עונים ישירות לדרישת מטלה 2.

## 6. בדיקה חזותית לפני שליחה

לאחר השלמת הפרטים האישיים:

1. לפתוח את קובץ ה-Word ב-Microsoft Word.
2. לוודא שכל הטקסט מיושר משמאל לימין.
3. לוודא שהכותרות אינן נחתכות בין עמודים.
4. לבדוק ששתי תמונות ה-AI קריאות.
5. לבדוק שהטבלה בעמוד הראשון אינה גולשת מחוץ לעמוד.
6. לעבור על הקישורים ולוודא שהם נפתחים.
7. לא להמיר את המסמך הראשי ל-PDF. ההגשה הראשית חייבת להיות DOCX או ODT.

## 7. שליחת המייל

כתובת:

`sre2025asre@gmail.com`

שורת נושא:

```text
RCE2026B + full names + ID numbers
```

בגוף המייל יש לכתוב עבור כל מגיש:

- שם מלא בעברית.
- שם מלא באנגלית.
- ת"ז.
- מספר טלפון.
- כתובת מייל.
- יום ושעת קבוצת ההרצאה.

מועד ההגשה לפי קובץ ההוראות:

`June 24, 2026`

אין לשלוח באמצעות Google Drive או Dropbox. ההגשה היא במייל בלבד.

## 8. צ'ק-ליסט סופי

- [ ] כל פרטי המגישים הושלמו בעמוד הראשון.
- [ ] קובץ ה-Word נפתח ונבדק חזותית.
- [ ] כל מאמר נשמר כ-PDF מלא ונפרד.
- [ ] תיקיית `AI_Documentation` צורפה.
- [ ] כל הקבצים נארזו ב-ZIP/RAR או חולקו למספר מיילים.
- [ ] שורת הנושא כוללת `RCE2026B`, שמות ות"ז.
- [ ] גוף המייל כולל את פרטי כל חברי הצוות.
- [ ] ההודעה נשלחה לכתובת הנכונה.
