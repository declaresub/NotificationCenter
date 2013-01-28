#tag Class
Protected Class App
Inherits Application
	#tag Event
		Sub Close()
		  NotificationCenter.Post("Application.Closing")
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  //your code here.
		  
		  //Will be invoked for every notification.
		  NotificationCenter.Add(AddressOf LogNotification)
		  
		  
		  NotificationCenter.Post("Application.Opened")
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Shared Sub LogNotification(name as String, sender as Object, info as Dictionary)
		  System.DebugLog "Notification '" + name + "' posted."
		End Sub
	#tag EndMethod


	#tag Constant, Name = kEditClear, Type = String, Dynamic = False, Default = \"&Delete", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"&Delete"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"&Delete"
	#tag EndConstant

	#tag Constant, Name = kFileQuit, Type = String, Dynamic = False, Default = \"&Quit", Scope = Public
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"E&xit"
	#tag EndConstant

	#tag Constant, Name = kFileQuitShortcut, Type = String, Dynamic = False, Default = \"", Scope = Public
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"Cmd+Q"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"Ctrl+Q"
	#tag EndConstant


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
