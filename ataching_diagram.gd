# START AREA COLIDE (AttachPoint.gd)
	#-> defered: attach (AttachPoint.gd)
	#-> signal attached -> _on_attached(ItemHolder.gd)
	#-> signal attached -> _on_attached(InputDoor.gd)
	#-> signal attached
	
# START SPAWN (ItemHolder.gd)
	#-> attach (AttachPoint.gd)

#START INPUT DETACH (Attachable.gd)
	#-> signal detached -> _on_detached (AttachPoint.gd)
	#-> signal detached -> _on_detached (ItemHolder.gd)
	#-> signal detached -> _on_ItemHolder_detached (InputDoor.gd)
	#	-> signal detached 
	#					   dispense::yield (OuputDoor.gd)
	
#START DELETE ATACHED (ItemHolder.gd)
	#->_on_detached ( AttachPoint.gd
