extern float cp_x;
extern float cp_y;
extern float radius;
vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 t = Texel(texture,texture_coords);
    vec4 c = vec4 (1.0, 1.0, 0.0, 1.0);
    float dx = cp_x - texture_coords.x;
    float dy = cp_y - texture_coords.y;
    float dr = sqrt(dx*dx + dy*dy);
    if ( dr < radius)
    { 
         return t * c;
    } 
    else
    {
        return t;
    }
}