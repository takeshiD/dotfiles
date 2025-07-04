return {
    "epwalsh/pomo.nvim",
    version = "*", -- Recommended, use latest release instead of latest commit
    lazy = true,
    cmd = { "TimerStart", "TimerRepeat", "TimerSession" },
    dependencies = {
        -- Optional, but highly recommended if you want to use the "Default" timer
        "rcarriga/nvim-notify",
    },
    opts = function()
        require("pomo").setup({
            update_interval = 1000,
            notifiers = {
                {
                    name = "Default",
                    opts = {
                        sticky = true,
                        title_icon = "󱎫",
                        text_icon = "󰄉",
                    },
                },

                -- The "System" notifier sends a system notification when the timer is finished.
                -- Available on MacOS and Windows natively and on Linux via the `libnotify-bin` package.
                { name = "System" },

                -- You can also define custom notifiers by providing an "init" function instead of a name.
                -- See "Defining custom notifiers" below for an example 👇
                -- { init = function(timer) ... end }
            },

            timers = {
                Break = {
                    { name = "System" },
                },
            },
            sessions = {
                pomodoro = {
                    { name = "Work",        duration = "25m" },
                    { name = "Short Break", duration = "5m" },
                    { name = "Work",        duration = "25m" },
                    { name = "Short Break", duration = "5m" },
                    { name = "Work",        duration = "25m" },
                    { name = "Long Break",  duration = "15m" },
                },
            },
        })
    end
}
