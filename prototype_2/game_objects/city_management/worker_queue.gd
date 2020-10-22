class_name WorkerQueue, "res://assets/icons/icon_worker_queue.svg"
extends Queue



func add_worker(puppet_master: Node2D):
	queue.append(puppet_master)
	
	#print("\nWORKER APPLICATIONS\n%s\n" % [queue])



func remove_worker(puppet_master: Node2D):
	queue.erase(puppet_master)
