"******************* function calls --------------------------------------------
com! Su call util#sudoWrite()
com! Cam call util#CamelCase()
com! Gram call util#WordProcessor()
com! Cpractice lua require('utils.compiler').cpractice()
com! Agenda lua require('utils').agenda()
com! ClearBack call util#transparency()

lua require('mappings').ranger()
