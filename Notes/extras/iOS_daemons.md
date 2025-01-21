Copy of [this reddit
post](https://www.reddit.com/r/jailbreak/comments/10v7j59/tutorial_list_of_ios_daemons_and_what_they_do/)
([Archive.is](https://archive.is/QMOzb))


Note: The line at the top appear in redditor's table rows 310 & 311.
This appears to be a mistake so I moved up.
(They used a tool [ExcelToReddit](https://xl2reddit.github.io/))
Otherwise I copied the table and ran 
`%s/^\s*[0-9]*\s*\(\w*\)\s*\(.*\)/| \1 | \2 |/`
To convert to a markdown format

-------------

Some daemons need a restart of the device to begin to function. Therefore troubleshooting is extremely troublesome, as you have to re-jailbreak multiple times if you are in a tethered JB situation. However, I've spent days compiling this list.
So wherever you start in your project. You allready got a head start thanks to this info. 

| Process | Description |
|:--------|:------------|
| ABDatabaseDoctor | AddressBook database repair |
| absd | Application identifier Fairplay Client Connected #DRM plugin? |
| accessoryd | Removing this will make accessories such as docks and other cables not be able to do anything except charge. |
| accountsd | Accountsd is a daemon, part of the Accounts framework. Apple's developer documentation says this framework helps users access and manage their external accounts from within apps, without requiring them to enter login credentials |
| adid | ??? Ad id? |
| AdminLite | When and app is not responding, this force closes it. You'll have to wait for unresponsive apps if you delete this. The AdminLite framework's sole purpose is act as a client to the com.apple.AdminLite service. There is are 2 functions in this framework, the high-level AdminLiteNVRAMSet and the low-level nvram_set. |
| afcd | AFC (Apple File Conduit) is a service that runs on every iPhone / iPod, which iTunes uses to exchange files with the device. It is jailed to the directory /private/var/mobile/Media, which is on the second (non-OS) partition. The AFC service is handled by /usr/libexec/afcd, and runs over the usbmux protocol. |
| aggregate | Create aggregate logs |
| akd | AuthKit |
| and | keyboardlayout |
| Applecredentialmanager | ? |
| ApplecredentialManager |  |
| apsd | apple push service |
| askpermissiond | It is a security/safety process that detects if the user should be asked for permission by password or other notification. |
| aslmanager | apple system log |
| assertion_agent | Create power assertion to prevent different kinds of sleep |
| assertiond | Assertiond is the iOS system daemon responsible for monitoring application performance and access rights at runtime. Two things it monitors are the wall-clock time and the CPU time a process has access to. |
| AssetCacheLocator | The caching server speeds up the download of software distributed by Apple through the Internet. |
| assetsd | connected to the photos application "doesnt work without it". Assetsd "handles names and description of photos" I think |
| assistivetouchd | assistivetouchd "a funtional shortcutbutton that is draggable anywhere on the homescreen" |
| atc | air traffic control |
| atc | .atwakeup 	ATWAKEUP daemon sends a ping (aka signal) approximately every 10 seconds to any "sleeping" paired Bluetooth media device to wake it up...just in case you press the "Play" button in either the control center or multitasking view. |
| auth | .agent 	  |
| AuthBrokerAgent | The AuthBrokerAgent is responsible for handling proxy credentials. If the credentials of a proxy setup are improperly stored (for example in one's keychain) then the AuthBrokerAgent can runaway. |
| awdd | apple wireless diagnostics daemon |
| backboardd | BackBoard, is a daemon introduced in iOS 6 to take some of the workload off of SpringBoard. Its chief purpose is to handle events from the hardware, such as touches, button presses, and accelerometer information. |
| backupd | backupd daemon backs up your files every hour, meaning that when your Time Machine backup is running, you'll notice backupd using up some CPU and memory |
| bird | icloud documents |
| Bluetool | ???? probably bluetooth related no sure try to keep off |
| bluetoothd | bluetooth module |
| bookassetd | seems to be tied to the download of books with the app "books" |
| bootps | my own plugin probably |
| BTServer | Bluetooth |
| BTServer | .le 	Bluetooth |
| BTServer | .map 	Bluetooth |
| BTServer | .pbap 	Bluetooth |
| cache_delete | deletes some kind of cache |
| cache_delete_app | deletes some kind of cache |
| cache_delete_daily | deletes some kind of cache  |
| cache_delete_mobile | deletes some kind of cache |
| calaccessd | runs when it syncs with email accounts or anything to do with your calender |
| CallHistorySyncHelper | for mobile phones |
| captiveagent | Handle captive WiFi login |
| cdpd | tied to account and login services "probably a securityservice" |
| certui | .relay 	When you are on a public network (like my school) and Safari can't verify what website it is connecting to, it will say "This website is not verified" or something like that, and asks if you want to still continue. Feel free to delete this.  |
| cfnetworkagent | Core Foundation networking |
| cfprefsd | .xpc.daemon 	Core Foundation preference sync |
| circlejoinrequested | ?????? securityrelated / Has something to do with connecting to nearby iOS devices but i could be wrong. |
| cloudd | icloud |
| cloudkeychianproxy | iCloud Keychain |
| cloudpaird | icloud related service |
| cloudphotod | icloud related service |
| CloudPhotoDerivative | Thumbnails for icloud |
| cmfsyncagent | Communications Filter Synchronization Agent |
| CommCenter | cellular data network |
| CommCenterMobileHelper | cellular data network |
| CommCenterRootHelper | cellular data network |
| companion_proxy | handles connections to certain other devices using ports https://docs.libimobiledevice.org/libimobiledevice/latest/companion__proxy_8h.html |
| configd | System Configuration Server, which means it monitors and reports on your Mac’s settings and status |
| contacts | donation agent 	Provide contacts from a sync provider |
| contactsd | Contacts handler |
| containermanagerd | Mange App and Group containers |
| contextstored | coreduetrelated which means it monitors and reports on your Mac’s settings and status |
| CoreAuthentication | handles biometric data / touch id |
| corecaptured | WiFi / Bluetooth diagnostic capture |
| coreduetd | Coreduetd is the daemon that is used to coordinate with your Mac other Apple devices in close proximity, to facilitate Handoff and synchronize with Office 365, iCloud Drive, and similar.   |
| coreidvd | iDVD is a discontinued DVD-creation application for Mac OS produced by Apple Inc. iDVD allows the user to burn QuickTime movies, MP3 music, ...Final release: 7.1.2 / July 11, 2011; this may be required for imovie |
| coreparsec | .sillhouette 	part of Siri AI |
| coreservices | .lsactivity.plist 	 lsactivity controls and helps with testing of the UserActivity feature and frameworks. The tool processes its arguments as command [ options... ] [ command [options...]]*   |
| corespotlightservice | .plist 	spotlight |
| coresymbolicationd | .plist 	25 Symbolication means replacing memory addresses with symbols (like functions or variables) or for example adding function names and line number information. It is used for debugging and analyzing crash reports. |
| cr4shedd | Crashed/ has to do with logging and diagnostics |
| crash_mover | .plist 	moves crash logs |
| CrashHousekeeping | removes logs |
| crashreportcopymobile | .plist 	copy crash log |
| ctkd | .plist 	Cloud Token Kit daemon |
| Cydia | .startup 	  |
| dasd | .plist 	Duet Activity Scheduler (DAS) maintains a scored list of background activities which usually consists of more than seventy items. Periodically, it rescores each item in its list, according to various criteria such as whether it is now due to be performed, i.e. clock time is now within the time period in which Centralized Task Scheduling (CTS) calculated it should next be run. |
| dataaccessd | his daemon deals with syncing with Exchange and Google Sync |
| DataDetectorsSource | The DataDetectorsSourceAccess command manages and controls access to the content of dynamic sources for the DataDetectors clients. This tool should not be run directly.  |
| defragd | Defragment for APFS |
| destinationd | maps destination service |
| device | -o-matic 	Figure out what profile to present when the device is connected via USB |
| devicecheckd | DeviceCheck is anticheat/modify software, might be riquiredReduce fraudulent use of your services by managing device state and asserting app integrity. |
| diagnosticd | Diagnostics |
| diagnosticextensionsd | Diagnostic extension / plugins |
| distnoted | Distributed notificaions Distnoted is a system message notification process. Often Distnoted will go wild when another process crashes. This other process is what distnoted is attempting to processs the system message for. Locum is an example of a process that sometimes crashes and is tied to finder. |
| dmd | YNOPSIS remotemanagementd DESCRIPTION remotemanagementd handles HTTP communication with an Mobile Device Management (MDM) Version 2 server, delivering configuration information to the local Device Management daemon (dmd), and sending status messages back to the server.   |
| DMHelper | Kechain, SSL, bla bla, keep on |
| DragUI | multitasking UI |
| duetexpertd | reportedly an iCloud-related service. Not removable.???? |
| DumpBasebandCrash | Dumps crash for baseband. Baseband/telephony, disable if you do not want crash log or if you dont have mobile network |
| DumpPanic | Dumps a log |
| EscrowSecurityAlert | Escrow is a data security measure in which acryptographic key is entrusted to a third party (i.e., kept in escrow). Under normal circumstances, the key is not released to someone other than the sender or receiver without proper authorization |
| fairplayd | .A2 	FairPlay is Apple's propietary DRM used to encrypt media purchased from the iTunes Store |
| familycircled | familycircled is a daemon for iCloud Family |
| familynotificationd | notification about family control "kid lock" |
| fdrhelper | Factory Data Reset |
| Filecoordination | coordinates the reading and writing of files and directories among file presenters. |
| Fileprovider | An extension other apps use to access files and folders managed by your app and synced with a remote storage. |
| findmydeviced | find my iphone |
| fmfd | Find my friends |
| fmflocatord | Find my friends |
| followupd | This looks like it's involved in the mechanics of notifications on a low level |
| fs_task_scheduler | filesystem task scheduler |
| fseventsd | Filesystem events |
| ftp | -proxy-embedded 	File Transfer Protocol, keep this on |
| GameController |  |
| gamed | gamecenter |
| geocorrectiond | GPS/Telemetry related |
| geod | Geo-fencing + GPS |
| GSSCred | The gsscred table is used on server machines to lookup the uid of incoming clients connected using RPCSEC_GSS |
| hangreporter | logging of unactive apps "unactive apps are spinning, and will be sampled by spindump tool to dump logs" |
| hangtracerd | logger |
| healthd | HealthKit |
| heartbeat | WatchOS heartbeat? |
| homed | HomeKit |
| hostapd | user space daemon for access points, including, e.g., IEEE 802.1X/WPA/EAP Authenticator for number of Linux and BSD drivers |
| house_arreset | iTunes file transfer for application documents |
| iap2d | USB 2.0 Acessory ON/OFF |
| iapauthd | iAccessory authentication |
| iapd | iAccessory Protocol handler Deals with companion apps for accessories |
| iaptransportd | iAccessory |
| idamd | ??????? |
| identityservicesd | identityservicesd is a background process (Identity Services Daemon) that deals with third-party credentials |
| idscredentialsagent | identity services |
| idsremoteurlconnectionagent | That software is ready to make any Instant Messaging connections you decide to make. |
| imagent | Instant Message Agent (iMessage) |
| imautomatischistorydeletionagent | iMessage History Deletion Agent |
| imtransferagent | iMessage attachment handler |
| ind | .plist 	???????? |
| insecure_notification | ??????? #If i remember correctly. This daemon went absolutely crazy at some point. It can become a CPU hog. |
| installation_proxy | Manages applications on a device. [most likely needed] |
| installcoordinationd | installation software for installing apps |
| installd | Mandatory for Appstore, probably installation software |
| IOAccelMemoryInfoCollector | probably logging |
| iomfb_bics_daemon | maybe needed for banking apps and other apps |
| iosdiagnosticsd | iOS Diagnostics is an Apple internal application. It is the iOS equivalent of an internal Apple OS X application named "Behavior Scan", used at the Genius Bar to detect and test different aspects of the device. ... app, and the diagnostic data is sent over the air to the genius' device |
| lskdmsed | Local System Kernel Debug Memory Daemon? |
| itunescloudd | iTunes cloud and Home Sharing |
| itunesstored | Mandatory for Appstore  |
| jetsam | 12412526 	  |
| keybagd | Keybagd is a service that first appeared on iOS, and was used to control access to encrypted user data based on device state- some data can still be unencrypted while the device remains locked, but other data cannot. It's since migrated into macOS. |
| languageassetd | may be related to Siri try to leave on |
| libnotificationd | DEBUGGING Disable used by cr4shed |
| locationd | Location services   |
| lockdown | lockdownd is a daemon that provides system information to clients using liblockdown.dylib, e.g. the IMEI, UDID, etc. Every information provided by lockdownd can be obtained via other means, e.g. the IMEI can be found using IOKit. The only advantage of using lockdownd is it has root privilege, hence avoiding having to assume super user. |
| logd | Logging Daemon |
| lsd | Launch Services daemon |
| lskdd | Local System Kernel Debug Daemon? |
| managedconfiguration | -mdm 	Mobile Device Manager daemon |
| managedconfiguration | -tesla 	  |
| managedconfiguration | -profile 	.mobileprofile management |
| Maps | .pushdaemon 	push notification for maps? |
| matd | ??? försök att ha på |
| mDNSResponer | Behövs för Webbsidor mDNSResponder, is a core part of the Bonjour protocol. Bonjour is Apple’s zero-configuration networking service, which basically means it’s how Apple devices find each other on a network. Our process, mDNSResponder, regularly scans your local network looking for other Bonjour-enabled devices. |
| MDNSResponerHelper | mDNSResponder, is a core part of the Bonjour protocol. Bonjour is Apple’s zero-configuration networking service, which basically means it’s how Apple devices find each other on a network. Our process, mDNSResponder, regularly scans your local network looking for other Bonjour-enabled devices. |
| mdt | ??? försök ha på |
| mediaanalysisd | used for videos and photos maybe |
| mediaartworkd | iTunes Cover Art |
| medialibraryd | ?? try to leave on |
| mediaremoted | MediaRemote is a framework that is used to communicate with the media server, mediaserverd. It can be utilized to query the server for now playing information, play or pause the current song, skip 15 seconds, etc. |
| mediaserverd | MediaRemote is a framework that is used to communicate with the media server, mediaserverd. It can be utilized to query the server for now playing information, play or pause the current song, skip 15 seconds, etc. |
| memory | -maintenance 	probably cleans RAM or something |
| midiserver | -ios 	midi such as MIDI |
| misagent | Provisioning profiles   |
| MobileAccessoryUpdater | It seems that fud is the firmware update daemon of com.apple.MobileAccessoryUpdater that presumably is responsible for firmware downloads for bluetooth peripherals and running the firmware update daemon |
| mobileactivationd | Activation services. If you disable this, you may get temporary de-activation of your device, among other things.  |
| mobileassetd | Mobileassetd is the daemon in charge of managing and downloading assets when other apps ask for them. Examples: dictionaries (for the user to see definitions of words), fonts, time zone database, firmware for accessories, voice recognition data for the Hey Siri feature, and OTA updates of the iOS firmware. I would recommend killing this daemon using CocoaTop and hopefully the issue should be fixed. |
| mobilecheckpoint | dont know, low info, leave alone |
| MobileFileIntegrity | checks file integrity |
| mobilegestalt | The libMobileGestalt.dylib, even though technically not a framework per se, it is of utmost importance, as it serves iOS as a central repository for all of the system's properties - both static and runtime. In that, it can be conceived as the parallel of OS X's Gestalt, which is part of CoreServices (in CarbonCore). But similarities end in name only. OS X's Gestalt is somewhat documented (in its header file), and has been effectively deprecared as of 10.8. MobileGestalt is entirely undocumented, and isn't going away any time soon. |
| MobileInternetSharing | 3G-4G-5G InternetSharing |
| mobilestoredemod | storedemo function |
| mobilestoredemodhelper | storedemo function |
| mobiletimerd | alarm clock perhaps |
| mobilewatchdog | watchdogd is part of the watchdog infrastructure, it ensures that both the kernel and user spaces are making progress.If the kernel or user space is stuck, a reboot will be triggered by the watchdog infrastructure. |
| mstreamd | is the process that transports pictures and video located on apple servers |
| mtmergeprops | mergeProps is a function that handles combining the props passed directly to a compoment |
| nand_task_scheduler |  |
| navd | connected to gps and maps |
| ndoagent | new device outreach service |
| neagent | -ios 	Network Extension - Agent |
| nehelper | -embedded 	 nehelper is part of the Network Extension framework. It is responsible for vending the Network Extension configuration to Network Extension clients and applying changes to the Network Extension configuration.   |
| nesessionmanager | The nesessionmanager daemon If you look at the implementation of the ne_session_* functions, you will note that these functions are sending their request through XPC to the root dameon nesessionmanager located at the path /usr/libexec/nesessionmanager. This daemon is listening for commands and handles them in the method -(void)[NESMSession handleCommand:fromClient:]. By looking at the logging strings, you can find the code for each command: cstr_00072C74 "%.30s:%-4d %@: Ignore restart command from %@, a pending start command already exists" cstr_00072CCA "%.30s:%-4d %@: Stop current session as requested by an overriding restart command from %@" cstr_00072D7D "%.30s:%-4d %@: Received a start command from %@, but start was rejected" cstr_00072DFD "%.30s:%-4d %@: Received a start command from %@" cstr_00072E2D "%.30s:%-4d %@: Skip a %sstart command from %@: session in state %s" cstr_00072E73 "%.30s:%-4d %@: Received a stop command from %@ with reason %d" cstr_00072F7E "%.30s:%-4d %@: Received an enable on demand command from %@" For example when an IKEv2 service is started, the method -(void)[NESMIKEv2VPNSession createConnectParametersWithStartMessage:] will be called. The architecture of the daemon is out of the scope of this article. |
| NetworkLinkConditioner |  |
| networkserviceproxy | Apple Network Service Proxy executable |
| newsd | Apple News |
| newspolicyd |  |
| NoATWAKEUP | dont know, but disabling is widely done |
| notification_proxy | leave on |
| notifyd | It's a system daemon that runs in the background to communicate with the update server. Killing it wouldn't disable it, but you shouldn't disable it anyways... Photo app depends on it "Ipad Air" |
| nsurlsessiond | assume Safarirelated and such |
| nsurlstoraged | nsurlstoraged is the daemon that makes this local storage possible. Safari is the main application that actually uses this capability, but a number of other Apple programs also use it: Mail, Calendar, and iCloud, |
| obliteration | Erase device via AppleEffacableStorage |
| openssh |  |
| oscard | responsible for sensors such as autorotation |
| OTACrashCopier | Moves crashes from Over the Air software updates to /var/mobile/Library/Logs. Feel free to remove the daemon |
| OTATaskingAgent | Tells the device to periodically check for OTA updates. Feel free to remove.  |
| parsecd | Siri related process I think |
| passd | Apple Passbook is a mobile application on an iPhone or iPod Touch that allows users to store .pkpass files called passes. Apple allows vendors to easily build passes that can be used as coupons, boarding passes, tickets, loyalty cards or gift certificates. |
| pasteboard | copy paste |
| perboardservice | v2 	dont touch PREBOARDSERVICE / First login screen |
| PerfPowerServicesExtended | PerfPowerServices -- manages structured log archives that enable retrieval of system power and performance data. DESCRIPTION The PerfPowerServices daemon works only within the context of a launchd job and should not be run from the command line. |
| personad |  |
| pfd | Packet Filter |
| photoanalysisd | Photo Library |
| pipelined | In computing, a pipeline, also known as a data pipeline,[1] is a set of data processing elements connected in series, where the output of one element is the input of the next one. The elements of a pipeline are often executed in parallel or in time-sliced fashion. Some amount of buffer storage is often inserted between elements. |
| pluginkit | pkd -- management and supervision daemon for plug-in services |
| powerd | When your Mac goes to sleep after being idle, powerd is what makes that happen |
| powerloghelperd | This is used to monitor any incompatibilities with 3rd party chargers.  |
| PowerUIAgent | com.apple.PowerUIAgent process is associated with the optimized battery charging optio |
| preboardservice | first login screen LEAVE ALONE |
| printd | Delete this if you don't use AirPrint |
| dprivacyd | Differential Privacy |
| progressd | com.apple.progressd progressd is the ClassKit sync agent. It handles syncing classes, class members, student handouts and progress data between student and teacher man-aged Apple ID accounts. |
| protectedcloudstorage |  |
| ProxiedCrashCopier | Move crash reports from devices like the Apple WatchMove crash reports from devices like the Apple Watch |
| ptpd | Picture Transfer Protocol used to transfer images via usb  |
| purplebuddy | related to restoration and backup from icloud "try to leave alone" |
| PurpleReverseProxy | has to do with image and restore and such try to leave alone |
| quicklook | Quicklook is the function that offers Finder built-in preview of any selected document in multicolumn Finder, or control-mouse click the file choosing the Quick Look menu, or File menu's Quicklook function. Previews in the Finder's Get Info window do the same thing |
| racoon | Virtual Private Network service on off |
| rapportd | Daemon that enables Phone Call Handoff and other communication features between Apple devices. Use '/usr/libexec/rapportd -V' to get the version. |
| recentsd | Most recently used |
| remotemanagementd | remotemanagementd handles HTTP communication with an Mobile Device Management (MDM) Version 2 server, delivering configuration information to the local Device Management daemon (dmd), and sending status messages back to the server.   |
| replayd | Gamecenter instant replay function |
| ReportCrash | log files |
| ReportCrash | .Jetsam 	log files |
| Reportcrash | .SimulateCrash 	log files |
| ReportMemoryException | The ReportMemoryException command is a system service which should only be launched by launchd. It generates memory usage diagnostic logs as indicated by system events such as memory limit violations. |
| reversetemplated | Create user folder layout from template |
| revisiond | Historical file revision management |
| roleaccountd | ?? leave alone This folder appears to be used for iOS updates, |
| rolld |  |
| routined | routined is a per-user daemon that learns historical location patterns of a user and predicts future visits to locations |
| rtcreportingd | looks to be a phone home to verify that your device is authorised for home sharing |
| Safari | .SafeBrowsing 	  |
| SafariBookmarksSyncAgent |  |
| SafariCloudHistoryPushAgent |  |
| safarifetcherd | Safari extension retrieves web pages and does a lot of the heavy lifting |
| SChelper | Smart Card helper |
| screensharigserver | AirPlay |
| scrod | voice control related |
| searchd | Spotlight |
| securityd | Handle keychains etc |
| securityuploadd | The securityuploadd daemon collects information about security events from the local system, and uploads them to Apple's Splunk servers in the cloud |
| SepUpdateTimer | Summertime Wintertime timer |
| sharingd | Generic "Share" action handler |
| sidecar | -relay 	 Use iDevice as a screen |
| signpost_reporter | Signposts is a developer feature created by Apple to help developers diagnose performance problems in applications. |
| siriactionsd | Siri voice shortcuts |
| siriknowledged | Siri related extension |
| softwareupdated | update service |
| softwareupdateservicesd | Tells iOS how to start and execute an OTA update, feel free to remove. Although DO NOT attempt an OTA update with this removed. I feel that it also stops the update from happening if the device is jailbroken.  |
| spindump | dumps information log of spinning "stuck" app |
| splashboardd | makes springboard function |
| SpringBoard |  |
| storage_mounter | The iPad Camera Connection Kit depends on this daemon. Delete if you don't use it, or if you don't have an iPad. |
| storebookkeeperd | probably has to do with book app |
| streaming_zip_conduit | Handle untrusted Zip content out of process |
| studentd | studentd manages the Apple Classroom experience for students and teachers that use MDM and the Apple School Manager service. |
| suggestd | suggestd is daemon that processes user content in order to detect contacts, events, named entities, etc. It receives content from Mail, Spotlight, Messages and other apps. |
| swcagent | Shared Web Credentials, uses NSURLSession to fetch the apple-app-site-association file. |
| swcd | Shared Web Credentials |
| symptomsd | helper 	symptomsd runs as part of the CrashReportor framework. |
| symptomsd | helper 	syncdefaultsd |
| sysdiagnose | DEBUGGING |
| sysdiagnose_helper | DEBUGGING |
| syslogd | Logs system events |
| systemstats | DEBUGGING systemstatsd is a "daemon" type process that generates data that the systemstats program can print out. It normally only runs when the systemstats program is actually run, which is only done manually from the Terminal as far as I know. It prints out a bunch of data that might be worth knowing. From a Terminal window you can |
| tailspind | DEBUGGING An application asks tailspind and spindump to take a snapshot of the state of that application and write it out to disk, or; Some application or process would consume maximum CPU for some period of time (30 seconds seems to be the general consensus), and then tailspind and spindump would fire up to take a snapshot of what was going on for future debugging purposes. |
| tccd | Total and Complete Control -TCC’s background service is tccd, whose only documented control is in tccutil, which merely clears existing settings from lists in the Privacy tab of the Security & Privacy pane. Its front end is that Privacy tab. In the unified log, TCC’s entries come from the subsystem com.apple.TCC. |
| telephonyutilites | telephony utilities |
| TextInput | .kbd 	input of text |
| timed | Network Time Protocol |
| timezoneupdates | TimezoneUpdates |
| tipsd | Tip of the day |
| touchsetupd | Touch Accommodations to fit your specific fine-motor skills needs. It's recommended that you configure your preferences |
| trustd | PKI trust evaluation // Required for web surfing, required for safe certificates |
| tvremoted | Apple TV remote app |
| tzlinkd | Time Zones |
| UsageTrackingAgent | UsageTrackingAgent monitors and reports usage budgets set by Health, Parental Controls, or Device Management. |
| usb | -networking-addnetwork 	usb/lightning to ethernet i think |
| UserEventAgent | The UserEventAgent utility is a daemon that loads system-provided plugins to handle high-level system events which cannot be monitored directly by launchd.3555 |
| userfs_helper | user fileystem helper |
| userfsd | user filesystem? |
| VideoSubscriberAccount | Video Subscriber Account provides APIs to help you create apps that require secure communication with a TV provider’s authentication service. The framework also informs the Apple TV app about whether your user has a subscription and the details of that subscription. |
| videosubscriptionsd | /usr/libexec/videosubscriptionsd (more correctly id’ed as com.apple.VideoSubscriberAccount.videosubscriptionsd) is part of the single sign-on video subscription services that Apple introduced into OSX/tvOS/iOS. Its part of the Video Subscriber Account framework (VideoSubscriberAccount.framework) and specifically relates to authenticating for video streaming/playback. |
| voiced | Deals with voice control |
| voicemod | Deals with voice control "I think" |
| VoiceOverTouch | Voice Over Touch Function |
| wapic | Deals with errors with Wifi networks with Chinese characters in the name /can prob be deleted |
| watchlistd | dunno leave on |
| WebBookmarks | bookmarks web |
| webinspectord | webinspectord is the service in charge of all operations related to the use of the ‘Web Inspector’ on iOS. It runs an XPC service known as // webinspectord relays commands between Web Inspector and targets that it can remotely inspect, such as WKWebView and JSContext instances. |
| wifid | wifi ID (maybe pass and such |
| wififirmwareloaderlegacy | firmwarefile for wifi |
| wifivelocityd | used with wifi may be deactivated? |
| wirelessproxd | , maybe used with airdrop wifi related  |
| WirelessRadioManager | WIFI  |
| asd | daemon |
| synctodefaultsd | most likely related to icloud sync |
| cloudkeychainproxy3 | icloud keychain |
| analytics |  |
| captiveagent | checks to see if you are on a captive wifi network, such as subscription hotspot or "Mcdonalds wifi" |
| timerd | timer function in clock app |
| pkd | manages plugins in safari launchd |
| Oscard | Core Motion Process accelerometer, gyroscope, pedometer, and environment-related events. |
| imdpersistance | IMDPersistenceAgent. It tells you that it is part of Messages application. It provides a background process for persistent messaging to notification center and other items, especially Facetime. If you don't use any of that, go ahead and kill it but it will come back if you've enabled any messaging protocols. |
| cryptotokenkit | CryptoTokenKitAccess security tokens and the cryptographic assets they store.You use the CryptoTokenKit framework to easily access cryptographic tokens. Tokens are physical devices built in to the system, located on attached hardware (like a smart card), or accessible through a network connection. Tokens store cryptographic objects like keys and certificates. They also may perform operations—for example, encryption or digital signature verification—using these objects. You use the framework to work with a token’s assets as if they were part of your system, even though they remain secured by the token.  |
