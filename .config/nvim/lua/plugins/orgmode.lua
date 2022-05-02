require('orgmode').setup_ts_grammar()

-- Doc : https://github.com/nvim-orgmode/orgmode/blob/master/DOCS.md#global-settings
-- Reference : https://github.com/nvim-orgmode/orgmode/blob/master/lua/orgmode/config/defaults.lua#L50

-- \oit : insert todo after current todo
-- \oc : open capture prompt
-- >>/<< : promote/demote (increase/decrease headline indentation)
-- Ctrl-C : Save current capture content to org_default_notes_file and close capture window
-- cit : cycle between todo keywords
-- \ot : change tags on headline
-- Ctrl-a / Ctrl-x : increase/decrease time under the cursor

-- :today: and :now: snippets

-- \oo: open link/date under cursor
-- \oaa : show agenda for the week
-- \oat : show all todo
-- \ois : schedule todo

-- g? : show help
require('orgmode').setup({
    org_agenda_files = {"~/org/*.org"},

    org_agenda_templates = {
        t = {
            description = 'Task',
            template = [[
* TODO %?
  SCHEDULED: %t]]
        },
        m = {
            description = 'Meetings',
            template = [[
* %t | %^{TITLE}
  Attendees: Jérôme Pin

  Notes:
*** %?]]
        },
        n = {
            description = 'Notes',
            template = [[
* %t | %^{TITLE}

  Notes:
*** %?]]
        }
    },

    org_default_notes_file = "~/org/refile.org",

    org_indent_mode = "noindent",

    org_todo_keywords = {'TODO(t)', 'WAITING(w)', '|', 'DONE(d)', 'DELEGATED(e)'},
    org_todo_keyword_faces = {
        TODO = ':foreground red',
        WAITING = ':foreground orange',
        DONE = ':foreground green',
        DELEGATED = ':slant italic :underline on'
    },

    mappings = {
        org = {
            org_todo = '<leader>ct'
        }
    }
})

require("org-bullets").setup({
    symbols = {"◉", "○", "✸", "✿"}
})
