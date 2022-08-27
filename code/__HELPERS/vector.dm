/vector
	var/x = 0
	var/y = 0

/vector/New(nx = 0, ny = 0)
	x = nx
	y = ny

/vector/proc/get_normalized()
	var/scale = get_scale()
	var/vector/new_vector = new(x / scale, y / scale)
	return new_vector

/vector/proc/get_scale()
	return sqrt(x * x + y * y)

/vector/proc/sub_vector(var/vector/sub)
	src.x -= sub.x
	src.y -= sub.y

/vector/proc/add(x, y)
	src.x += x
	src.y += y

/vector/proc/sub(x, y)
	src.x -= x
	src.y -= y

/vector/proc/sub_vector_result(var/vector/sub)
	return new /vector(x - sub.x, y - sub.y)

/vector/proc/get_theta(var/vector/vec)
	var/vector/new_vector = multiply(vec)
	return arccos(new_vector.x + new_vector.y)

/vector/proc/multiply(var/vector/vec)
	var/vector/new_vector = new(x * vec.x, y * vec.y)
	return new_vector

/vector/proc/get_turf(var/z)
	return locate(x, y, z)

/vector/proc/isNull()
	return (!x && !y)

/vector/proc/get_vec_dir()
	if(abs(x) > abs(y))
		if(x > 0)
			return EAST
		else
			return WEST
	else
		if(y > 0)
			return NORTH
		else
			return SOUTH