setlocal commentstring=//%s
au BufWritePost *.glsl,*.vert,*.frag,*.geom,*.vs,*.fs Dispatch glslangValidator %
