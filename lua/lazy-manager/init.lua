-- Bootstrap package manager
require("lazy-manager.bootstrap").setup()
local lazy_opts = require("lazy-manager.config")

-- Initilize plugins
require("lazy").setup("plugins", lazy_opts)
