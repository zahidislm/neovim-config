-- Previous Buffer
kmap{key="K", cmd="<Plug>(CybuPrev)"}

-- Next Buffer
kmap{key="J", cmd="<Plug>(CybuNext)"}

-- Tab Cycling
kmap{mode={"n", "v"}, key="<s-tab>", cmd="<plug>{CybuLastusedPrev}"}
kmap{mode={"n", "v"}, key="<c-tab>", cmd="<plug>(CybuLastusedNext)"}

-- Close Buffer
kmap{key="<Leader>d", cmd="<cmd>bp<BAR>bd#<CR>"}

-- Close all buffers except current
kmap{key="<Leader>da", cmd="<cmd>%bd|e#|bd#<CR>"}
