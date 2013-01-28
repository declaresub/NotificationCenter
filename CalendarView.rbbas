#tag Class
Protected Class CalendarView
	#tag Method, Flags = &h0
		Function DayRect(row as Integer, column as Integer) As Realbasic.Rect
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Draw(g as Graphics)
		  
		  
		  dim today as new Date //pass this in.
		  //pull into function
		  dim firstDate as new Date(today.Year, today.Month)
		  firstDate.Day = firstDate.Day - (firstDate.DayOfWeek - 1)
		  
		  
		  
		  dim rowCount as Integer = 5 //or 4...
		  dim columnCount as Integer = 7
		  
		  dim gridWidth as Integer = CType(Round(g.Width/columnCount), Integer)
		  dim gridHeight as Integer = CType(Round(g.Height/rowCount), Integer)
		  dim gridLeft as Integer =  0
		  dim gridTop as Integer = 0
		  
		  
		  //draw weekend day backgrounds.
		  
		  g.ForeColor = HolidayBackgroundColor
		  g.FillRect 0, 0, gridWidth, g.Height
		  g.FillRect (columnCount - 1) * gridWidth, 0, gridWidth, g.Height
		  
		  //draw today background
		  const secondsInOneDay = 86400.0
		  dim dayDiff as Integer = CType(Floor(today.TotalSeconds/secondsInOneDay), Integer) - CType(Floor(firstDate.TotalSeconds/secondsInOneDay), Integer)
		  dim todayRow as Integer = dayDiff\7
		  dim todayColumn as Integer = dayDiff mod 7
		  
		  g.ForeColor = TodayBackgroundColor
		  g.FillRect todayColumn * gridWidth, todayRow * gridHeight, gridWidth, gridHeight
		  
		  
		  
		  
		  //draw grid
		  
		  g.ForeColor = self.BorderColor
		  g.DrawRect 0, 0, g.Width, g.Height
		  
		  //draw day grid.  If # days = 28 and first day of month falls on first day of week, then
		  //grid is 7 x 4; otherwise, it's 7 x 5
		  
		  gridLeft = gridWidth
		  gridTop = gridHeight
		  
		  for row as Integer = 1 to rowCount - 1
		    g.DrawLine 0, gridTop, g.Width - 1, gridTop
		    gridTop = gridTop + gridHeight
		  next
		  
		  for column as Integer = 1 to columnCount - 1
		    g.DrawLine gridLeft, 0, gridLeft, g.Height - 1
		    gridLeft = gridLeft  +gridWidth
		  next
		  
		  
		  //add days
		  
		  //add short day names to first row
		  //to be localized...
		  g.TextFont = self.DateTextFont
		  g.TextSize = self.DateTextSize
		  g.ForeColor = self.DateTextColor
		  dim rightTextMargin as Integer = 4
		  dim textMarginTop as Integer = 4
		  dim theDate as new Date(firstDate)
		  dim gridRight as Integer = gridWidth
		  dim DayNames() as String = Array("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
		  for column as Integer = 0 to columnCount - 1
		    dim day as String = DayNames(column) + " " + Str(theDate.Day)
		    g.DrawString(day, gridRight - rightTextMargin - g.StringWidth(day), textMarginTop + g.TextAscent)
		    gridRight = gridRight + gridWidth
		    theDate.Day = theDate.Day + 1
		  next
		  
		  gridTop = gridHeight
		  for row as Integer = 1 to rowCount - 1
		    gridRight = gridWidth
		    for column as Integer = 0 to columnCount - 1
		      dim day as String = Str(theDate.Day)
		      g.DrawString(day, gridRight - rightTextMargin - g.StringWidth(day), gridTop + textMarginTop + g.TextAscent)
		      gridRight = gridRight + gridWidth
		      theDate.Day = theDate.Day + 1
		    next
		    gridTop = gridTop + gridHeight
		  next
		  
		  
		  
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		BorderColor As Color = &cCCCCCC
	#tag EndProperty

	#tag Property, Flags = &h0
		DateTextColor As Color = &c777777
	#tag EndProperty

	#tag Property, Flags = &h0
		DateTextFont As String = "Lucida Grande"
	#tag EndProperty

	#tag Property, Flags = &h0
		DateTextSize As Integer = 11
	#tag EndProperty

	#tag Property, Flags = &h0
		HolidayBackgroundColor As Color = &cFBFBFB
	#tag EndProperty

	#tag Property, Flags = &h0
		TodayBackgroundColor As Color = &cE9EFF7
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="BorderColor"
			Group="Behavior"
			InitialValue="&cCCCCCC"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DateTextColor"
			Group="Behavior"
			InitialValue="&c777777"
			Type="Color"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DateTextFont"
			Group="Behavior"
			InitialValue="Lucida Grande"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="DateTextSize"
			Group="Behavior"
			InitialValue="11"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="HolidayBackgroundColor"
			Group="Behavior"
			InitialValue="&cFBFBFB"
			Type="Color"
		#tag EndViewProperty
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
			Name="TodayBackgroundColor"
			Group="Behavior"
			InitialValue="&cE9EFF7"
			Type="Color"
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
