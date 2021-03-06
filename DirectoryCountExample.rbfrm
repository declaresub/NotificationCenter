#tag Window
Begin Window DirectoryCountExample
   BackColor       =   &hFFFFFF
   Backdrop        =   ""
   CloseButton     =   True
   Composite       =   False
   Frame           =   0
   FullScreen      =   False
   HasBackColor    =   False
   Height          =   400
   ImplicitInstance=   True
   LiveResize      =   True
   MacProcID       =   0
   MaxHeight       =   32000
   MaximizeButton  =   False
   MaxWidth        =   32000
   MenuBar         =   ""
   MenuBarVisible  =   True
   MinHeight       =   64
   MinimizeButton  =   True
   MinWidth        =   64
   Placement       =   0
   Resizeable      =   True
   Title           =   "Directory Count"
   Visible         =   True
   Width           =   600
   Begin Thread Thread1
      Height          =   32
      Index           =   -2147483648
      Left            =   -26
      LockedInPosition=   False
      Priority        =   5
      Scope           =   0
      StackSize       =   0
      TabPanelIndex   =   0
      Top             =   438
      Width           =   32
   End
   Begin PushButton PushButton1
      AutoDeactivate  =   True
      Bold            =   ""
      ButtonStyle     =   0
      Cancel          =   ""
      Caption         =   "Count"
      Default         =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   494
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   False
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   358
      Underline       =   ""
      Visible         =   True
      Width           =   80
   End
   Begin Label Label1
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   20
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   1
      TabPanelIndex   =   0
      Text            =   ""
      TextAlign       =   0
      TextColor       =   &h000000
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   170
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   554
   End
   Begin ProgressWheel ProgressWheel1
      AutoDeactivate  =   True
      Enabled         =   True
      Height          =   16
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   2
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Top             =   172
      Visible         =   False
      Width           =   16
   End
   Begin Label Label2
      AutoDeactivate  =   True
      Bold            =   ""
      DataField       =   ""
      DataSource      =   ""
      Enabled         =   True
      Height          =   20
      HelpTag         =   ""
      Index           =   -2147483648
      InitialParent   =   ""
      Italic          =   ""
      Left            =   20
      LockBottom      =   ""
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   ""
      LockTop         =   True
      Multiline       =   ""
      Scope           =   0
      Selectable      =   False
      TabIndex        =   3
      TabPanelIndex   =   0
      Text            =   ""
      TextAlign       =   0
      TextColor       =   &h000000
      TextFont        =   "System"
      TextSize        =   0
      TextUnit        =   0
      Top             =   195
      Transparent     =   False
      Underline       =   ""
      Visible         =   True
      Width           =   426
   End
End
#tag EndWindow

#tag WindowCode
	#tag Event
		Sub Close()
		  If Thread1.State <> Thread.NotRunning then
		    Thread1.Kill
		  End If
		  
		  NotificationCenter.Remove(AddressOf HandleVisitNotification, "VisitDirectory", nil)
		  
		  
		  //I know that some notifications were registered with sender = control on
		  //this window.  This general bit of code will clean them all out.
		  NotificationCenter.Remove(nil, "", self)
		  for i as Integer = 0 to ControlCount - 1
		    dim c as Control = Control(i)
		    NotificationCenter.Remove(nil, "", c)
		  next
		End Sub
	#tag EndEvent

	#tag Event
		Sub Open()
		  NotificationCenter.Add(AddressOf HandleThreadStart, "Thread.Run.Start", Thread1)
		  NotificationCenter.Add(AddressOf HandleThreadEnd, "Thread.Run.End", Thread1)
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub HandleThreadEnd(name as String, sender as Object, info as Dictionary)
		  PushButton1.Enabled = true
		  ProgressWheel1.Visible = false
		  NotificationCenter.Remove(AddressOf HandleVisitNotification, "VisitDirectory", nil)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleThreadStart(name as String, sender as Object, info as Dictionary)
		  PushButton1.Enabled = false
		  ProgressWheel1.Visible = true
		  NotificationCenter.Add(AddressOf HandleVisitNotification, "VisitDirectory", nil)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleVisit(visitor as DirectoryVisitor, parent as FolderItem, items() as FolderItem)
		  NotificationCenter.PostToMainThread("VisitDirectory", visitor, new Dictionary("parent" : parent, "itemcount": 1 + UBound(items)))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleVisitNotification(name as String, sender as Object, info as Dictionary)
		  const KeyParent = "Parent"
		  const KeyItemCount = "itemcount"
		  
		  if info <> nil and info.HasKey(KeyParent) then
		    dim item as FolderItem = info.Value(KeyParent)
		    if item <>nil then
		      If Label1 <> nil then
		        Label1.Text = "Visiting "+ item.ShellPath + "..."
		      End If
		      VisitCount = VisitCount + info.Value(KeyItemCount)
		      if Label2 <> nil then
		        Label2.Text = "Visited Count: " + Str(VisitCount)
		      end if
		    end if
		  end if
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h21
		Private Delegate Sub Untitled()
	#tag EndDelegateDeclaration


	#tag Property, Flags = &h21
		Private VisitCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Visitor As DirectoryVisitor
	#tag EndProperty


#tag EndWindowCode

#tag Events Thread1
	#tag Event
		Sub Run()
		  NotificationCenter.PostToMainThread("Thread.Run.Start", me)
		  //give the UI an opportunity to update in response to thread start.
		  App.YieldToNextThread
		  dim visitor as new DirectoryVisitor
		  AddHandler visitor.Visiting, WeakAddressOf HandleVisit
		  visitor.Visit(SpecialFolder.UserHome)
		  NotificationCenter.PostToMainThread("Thread.Run.End", me)
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events PushButton1
	#tag Event
		Sub Action()
		  VisitCount = 0
		  Thread1.Run
		End Sub
	#tag EndEvent
#tag EndEvents
