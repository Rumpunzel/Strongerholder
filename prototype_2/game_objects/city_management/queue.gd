class_name Queue
extends Node


var queue: Array = [ ]



func requeue(object: Object):
	queue.append(object)


func pop_front() -> Object:
	return queue.pop_front()


func empty() -> bool:
	return queue.empty()
