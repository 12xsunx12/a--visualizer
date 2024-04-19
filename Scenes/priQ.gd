class_name priQ extends Node2D

var elements: Array = []

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func enqueue(item):
	var entry = {"item": item, "priority": item.f}
	elements.append(entry)
	var index = elements.size() - 1
	while index > 0:
		var parent_index = (index - 1) / 2
		if elements[parent_index]["priority"] > elements[index]["priority"]:
			var temp = elements[parent_index]
			elements[parent_index] = elements[index]
			elements[index] = temp
			index = parent_index
		else:
			break

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func dequeue():
	var min_element = elements[0]["item"]
	var last_element = elements.pop_back()
	if elements.size() > 0:
		var index = 0
		while true:
			var left_child = 2 * index + 1
			var right_child = 2 * index + 2
			var min_child = -1
			if left_child < elements.size():
				min_child = left_child
			if right_child < elements.size() and elements[right_child]["priority"] < elements[left_child]["priority"]:
				min_child = right_child
			if min_child == -1 or last_element["priority"] <= elements[min_child]["priority"]:
				break
			elements[index] = elements[min_child]
			index = min_child
		elements[index] = last_element
	return min_element

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func is_empty() -> bool:
	return elements.size() == 0

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func clear() -> void:
	elements.clear()

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func size() -> int:
	return elements.size()

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func get_elements():
	return elements

# // - - - - - - - - - - - - - - - - - - - - - - - - - 
func set_start(start_node):
	enqueue(start_node)
	
