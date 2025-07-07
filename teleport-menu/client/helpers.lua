-- Helper function to add two vec2 objects
local function add_vec2(v_a, v_b)
    return vec2(v_a.x + v_b.x, v_a.y + v_b.y)
end

-- Helper function to check if a point is inside a triangle
-- pt, v1, v2, v3 should be vec2 objects
local function is_point_in_triangle(pt, v1, v2, v3)
    local function sign(p1, p2, p3)
        return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
    end

    local d1 = sign(pt, v1, v2)
    local d2 = sign(pt, v2, v3)
    local d3 = sign(pt, v3, v1)

    local has_neg = (d1 < 0) or (d2 < 0) or (d3 < 0)
    local has_pos = (d1 > 0) or (d2 > 0) or (d3 > 0)

    return not (has_neg and has_pos)
end

return {
    add_vec2 = add_vec2,
    is_point_in_triangle = is_point_in_triangle
}
