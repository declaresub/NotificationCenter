#tag Class
Protected Class DirectoryVisitor
	#tag Method, Flags = &h0
		Sub Visit(f as FolderItem)
		  dim items() as FolderItem
		  dim lastIndex as Integer = f.Count
		  for i as Integer = 1 to lastIndex
		    dim item as FolderItem = f.TrueItem(i)
		    if item <> nil then
		      items.Append item
		    end if
		  next
		  
		  raiseEvent Visiting(f, items)
		  
		  for each item as FolderItem in items
		    if item.Directory then
		      self.Visit(item)
		    end if
		  next
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event Visiting(parent as FolderItem, items() as FolderItem)
	#tag EndHook


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
