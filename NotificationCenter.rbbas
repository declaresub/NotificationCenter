#tag Class
Protected Class NotificationCenter
	#tag Method, Flags = &h0
		 Shared Sub Add(handler as NotificationHandler, name as String = "", sender as Object = nil)
		  #pragma disableBackgroundTasks
		  
		  for each item as Dictionary in Handlers
		    if item.Value("handler") = handler and item.Value("name") = name and item.Value("sender") = sender then
		      return
		    end if
		  next
		  
		  Handlers.Append new Dictionary("handler" : handler, "name" : name, "sender" : sender)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Function MakeMainThreadQueueTimer() As Timer
		  dim t as new Timer
		  t.Period = 0
		  t.Mode = Timer.ModeOff
		  AddHandler t.Action, AddressOf PostQueue
		  return t
		End Function
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Sub NotificationHandler(name as String, sender as Object, info as Dictionary)
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		 Shared Sub Post(name as String, sender as Object = nil, info as Dictionary = nil)
		  #pragma disableBackgroundTasks
		  
		  for each item as Dictionary in Handlers
		    if (item.Value("name") = "" or item.Value("name") = name) and (item.Value("sender") = nil or item.Value("sender") = sender) then
		      dim h as NotificationHandler = item.Value("handler")
		      h.Invoke(name, sender, info)
		    end if
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Shared Sub PostQueue(t as Timer)
		  #pragma disableBackgroundTasks
		  
		  MainThreadQueueLock.Signal
		  try
		    dim q() as Dictionary = MainThreadQueue
		    dim foo(-1) as Dictionary
		    MainThreadQueue = foo
		    
		    for i as Integer = 0 to UBound(q)
		      dim item as Dictionary = q(i)
		      Post(item.Value("name"), item.Value("sender"), item.Value("info"))
		    next
		  finally
		    MainThreadQueueLock.Release
		  end try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub PostToMainThread(name as String, sender as Object = nil, info as Dictionary = nil)
		  if App.CurrentThread = nil then
		    Post(name, sender, info)
		  else
		    MainThreadQueueLock.Signal
		    try
		      MainThreadQueue.Append new Dictionary("name" : name, "sender" : sender, "info" : info)
		      MainThreadQueueTimer.Period = 0
		      MainThreadQueueTimer.Mode = Timer.ModeSingle
		    finally
		      MainThreadQueueLock.Release
		    end try
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		 Shared Sub Remove(handler as NotificationHandler, name as String, sender as Object)
		  #pragma disableBackgroundTasks
		  
		  dim newHandlers() as Dictionary
		  
		  for each item as Dictionary in Handlers
		    if (handler = nil or item.Value("handler") <> handler) and (name = "" or item.Value("name") <> name) and (sender = nil or item.Value("sender") <> sender) then
		      newHandlers.Append item
		    end if
		  next
		  
		  Handlers = newHandlers
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private Shared Handlers() As Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  static d as new Dictionary
			  return d
			End Get
		#tag EndGetter
		Private Shared HandlersForName As Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private Shared MainThreadQueue() As Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  static s as new Semaphore
			  return s
			End Get
		#tag EndGetter
		Private Shared MainThreadQueueLock As Semaphore
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h21
		#tag Getter
			Get
			  static t as Timer = MakeMainThreadQueueTimer
			  return t
			End Get
		#tag EndGetter
		Private Shared MainThreadQueueTimer As Timer
	#tag EndComputedProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
