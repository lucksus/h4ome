
function setNode(holon, name, value) {
    var newHolon = holon//_.cloneDeep(holon)
    newHolon._holon_nodes[name] = value
    return newHolon
}
