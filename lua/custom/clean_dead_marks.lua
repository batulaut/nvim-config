vim.api.nvim_create_user_command("CleanDeadMarks", function()
    local stale_marks = {}

    for _, mark in ipairs(vim.fn.getmarklist()) do
        local name = mark.mark:sub(2)
        local file = mark.file

        if #name == 1 and name >= "A" and name <= "Z" and file then
            if vim.uv.fs_stat(file) == nil then
                stale_marks[#stale_marks + 1] = name
            end
        end
    end

    if #stale_marks == 0 then
        print("No stale global marks found.")
        return
    end

    vim.cmd("delmarks " .. table.concat(stale_marks, " "))
    print("Deleted marks: " .. table.concat(stale_marks, ", "))
end, {
    desc = "Remove stale global marks",
})
